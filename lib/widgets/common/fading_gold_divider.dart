import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class FadingGoldDivider extends StatelessWidget {
  final double thickness;
  final double verticalMargin;
  final double horizontalMargin;

  const FadingGoldDivider({
    super.key,
    this.thickness = 1.0,
    this.verticalMargin = 0.0,
    this.horizontalMargin = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      height: thickness,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.goldFadeGradient,
      ),
    );
  }
}
