import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Compact star-rating badge displayed on show cards.
class RatingBadge extends StatelessWidget {
  final double? rating;

  const RatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    if (rating == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.rating.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.rating.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.rating, size: 12),
          const SizedBox(width: 3),
          Text(
            rating!.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.rating,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
