import 'package:flutter/material.dart';
import '../../../theme/shopkit_theme.dart';
import '../../../config/flexible_widget_config.dart';

class ProductGridActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? semanticsLabel;
  final FlexibleWidgetConfig? config;
  final ShopKitTheme theme;
  const ProductGridActionButton({super.key, required this.icon, required this.color, required this.onTap, required this.theme, required this.config, this.semanticsLabel});
  T _get<T>(String key, T def) => config?.get<T>(key, def) ?? def;
  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: _get('actionButtonSize', 32.0),
      height: _get('actionButtonSize', 32.0),
      decoration: BoxDecoration(
        color: theme.surfaceColor.withValues(alpha: _get('actionButtonBackgroundOpacity', 0.9)),
        borderRadius: BorderRadius.circular(_get('actionButtonBorderRadius', 16.0)),
        boxShadow: _get('showActionButtonShadow', true)
            ? [
                BoxShadow(
                  color: theme.onSurfaceColor.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Icon(icon, color: color, size: _get('actionButtonIconSize', 18.0)),
    );
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: GestureDetector(onTap: onTap, child: button),
    );
  }
}
