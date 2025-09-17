import 'package:flutter/material.dart';
import 'package:fastlocation/src/shared/colors/app_colors.dart';
import 'package:fastlocation/src/shared/metrics/app_metrics.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionText;
  
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppMetrics.iconExtraLarge * 2,
              color: AppColors.grey,
            ),
            const SizedBox(height: AppMetrics.marginMedium),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppMetrics.marginSmall),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionText != null) ...[
              const SizedBox(height: AppMetrics.marginLarge),
              ElevatedButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}