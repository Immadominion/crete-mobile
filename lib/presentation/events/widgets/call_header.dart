import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/voice_models.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class CallHeader extends StatefulWidget {
  final VoiceSession session;
  final VoidCallback onMinimize;
  final VoidCallback onEndCall;
  final bool isScreenSharing;

  const CallHeader({
    super.key,
    required this.session,
    required this.onMinimize,
    required this.onEndCall,
    this.isScreenSharing = false,
  });

  @override
  State<CallHeader> createState() => _CallHeaderState();
}

class _CallHeaderState extends State<CallHeader> {
  late Stream<String> _durationStream;

  @override
  void initState() {
    super.initState();
    _durationStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) =>
          _formatDuration(DateTime.now().difference(widget.session.startTime)),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Back/Minimize button
          GestureDetector(
            onTap: widget.onMinimize,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),

          SizedBox(width: 16.w),

          // Call info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.session.title,
                  style: AppTypography.geistMedium16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 2.h),

                Row(
                  children: [
                    // Live indicator
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 6.w),

                    // Duration
                    StreamBuilder<String>(
                      stream: _durationStream,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '00:00',
                          style: AppTypography.geistRegular13.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        );
                      },
                    ),

                    if (widget.session.communityName != null) ...[
                      Text(
                        ' • ',
                        style: AppTypography.geistRegular13.copyWith(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),

                      Text(
                        widget.session.communityName!,
                        style: AppTypography.geistRegular13.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Participants count
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people,
                  color: Colors.white.withOpacity(0.8),
                  size: 16.sp,
                ),

                SizedBox(width: 4.w),

                Text(
                  '${widget.session.participants.length}',
                  style: AppTypography.geistMedium13.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
