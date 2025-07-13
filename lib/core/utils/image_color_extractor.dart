import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Utility class for extracting dominant colors from images
class ImageColorExtractor {
  // Cache to store extracted colors to avoid re-processing the same images
  static final Map<String, Color> _colorCache = {};

  /// Extracts the dominant color from a network image
  /// Returns the dominant color or a fallback color if extraction fails
  static Future<Color> extractDominantColor({
    required String imageUrl,
    Color fallbackColor = const Color(0xFF6B5AFD), // AppColors.primary
    bool useCache = true,
  }) async {
    // Check cache first
    if (useCache && _colorCache.containsKey(imageUrl)) {
      return _colorCache[imageUrl]!;
    }

    try {
      // Create an image provider from the network URL
      final imageProvider = NetworkImage(imageUrl);

      // Extract colors using material_color_utilities
      final colors = await _getColorsFromImage(imageProvider);

      Color? dominantColor;
      if (colors.isNotEmpty) {
        // Get the first suitable color
        dominantColor = colors.first;

        // Ensure it's suitable for status bar
        dominantColor = _ensureStatusBarSuitableColor(dominantColor);

        // Cache the result
        if (useCache) {
          _colorCache[imageUrl] = dominantColor;
        }

        return dominantColor;
      }

      return fallbackColor;
    } catch (e) {
      // Log error in debug mode
      debugPrint('Failed to extract color from image: $e');
      return fallbackColor;
    }
  }

  /// Extracts colors from an image using material_color_utilities
  static Future<List<Color>> _getColorsFromImage(ImageProvider provider) async {
    try {
      // Extract dominant colors from image
      final quantizerResult = await _extractColorsFromImageProvider(provider);
      final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
        (key, value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
      );

      // Score colors for color scheme suitability
      final List<int> filteredResults = Score.score(
        colorToCount,
        desired: 1,
      );
      final List<int> scoredResults = Score.score(
        colorToCount,
        filter: false,
      );

      return <dynamic>{
        ...filteredResults,
        ...scoredResults,
      }.toList().map((argb) => Color(argb as int)).toList();
    } catch (e) {
      debugPrint('Error getting colors from image: $e');
      return [];
    }
  }

  /// Extracts colors from image provider using quantization
  static Future<QuantizerResult> _extractColorsFromImageProvider(
    ImageProvider imageProvider,
  ) async {
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    final completer = Completer<ui.Image>();

    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      imageStream.removeListener(listener);
      completer.complete(imageInfo.image);
    });

    imageStream.addListener(listener);
    final image = await completer.future;

    final ByteData? byteData = await image.toByteData();
    if (byteData == null) {
      throw Exception('Failed to get byte data from image');
    }

    final Uint8List pixels = byteData.buffer.asUint8List();
    final quantizer = QuantizerCelebi();

    return quantizer.quantize(pixels, 128);
  }

  /// Converts ABGR to ARGB format
  static int _getArgbFromAbgr(int abgr) {
    const int red = 0x000000ff;
    const int blue = 0x00ff0000;
    return (abgr & 0xff00ff00) | ((abgr & red) << 16) | ((abgr & blue) >> 16);
  }

  /// Clears the color cache
  static void clearCache() {
    _colorCache.clear();
  }

  /// Ensures the extracted color is suitable for use as a status bar color
  /// Adjusts very light colors to be darker for better contrast with white icons
  static Color _ensureStatusBarSuitableColor(Color color) {
    // Calculate luminance to determine if the color is too light
    final luminance = color.computeLuminance();

    // If the color is too light (luminance > 0.7), darken it
    if (luminance > 0.7) {
      final hsl = HSLColor.fromColor(color);
      return hsl.withLightness((hsl.lightness * 0.6).clamp(0.0, 1.0)).toColor();
    }

    // If the color is too dark (luminance < 0.1), lighten it slightly
    if (luminance < 0.1) {
      final hsl = HSLColor.fromColor(color);
      return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    }

    return color;
  }

  /// Determines the appropriate icon brightness for a given background color
  static Brightness getIconBrightness(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Brightness.dark : Brightness.light;
  }
}
