import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Styled genre/info chip used on show cards and detail screens.
class InfoChip extends StatelessWidget {
  final String label;
  final Color? color;

  const InfoChip({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final bg = (color ?? AppColors.primary).withValues(alpha: 0.15);
    final fg = color ?? AppColors.primaryLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
