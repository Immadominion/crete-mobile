import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceActivityIndicator extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final double height;
  final int barCount;

  const VoiceActivityIndicator({
    super.key,
    required this.animation,
    required this.color,
    this.height = 24.0,
    this.barCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(barCount, (index) {
          return Container(
            width: 3.w,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final animationDelay = index * 0.2;
                final adjustedAnimation =
                    (animation.value + animationDelay) % 1.0;
                final barHeight = height * (0.3 + 0.7 * adjustedAnimation);

                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: barHeight.h,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.7 + 0.3 * adjustedAnimation),
                      borderRadius: BorderRadius.circular(1.5.r),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
