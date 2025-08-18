import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';

/// Minimal style extension enum helper used by CheckoutStep theming.
enum ShopKitThemeStyle { material3, materialYou, neumorphism, glassmorphism, cupertino, minimal, retro, neon }

extension ShopKitThemeStyleExtension on ShopKitThemeStyle {
	static ShopKitThemeStyle fromString(String s) {
		switch (s) {
			case 'materialYou':
				return ShopKitThemeStyle.materialYou;
			case 'neumorphism':
				return ShopKitThemeStyle.neumorphism;
			case 'glassmorphism':
				return ShopKitThemeStyle.glassmorphism;
			case 'cupertino':
				return ShopKitThemeStyle.cupertino;
			case 'minimal':
				return ShopKitThemeStyle.minimal;
			case 'retro':
				return ShopKitThemeStyle.retro;
			case 'neon':
				return ShopKitThemeStyle.neon;
			default:
				return ShopKitThemeStyle.material3;
		}
	}
}

/// Minimal theme config used by the bespoke themed builder in CheckoutStep.
class ShopKitThemeConfig {
	final Color? backgroundColor;
	final double borderRadius;
	final bool enableShadows;
	final Color? shadowColor;
	final double elevation;

	// Additional flags expected by some themed builders
	final bool enableGradients;
	final bool enableBlur;
	final Color? primaryColor;
	final Color? onPrimaryColor;

	ShopKitThemeConfig({
		this.backgroundColor,
		this.borderRadius = 8.0,
		this.enableShadows = true,
		this.shadowColor,
		this.elevation = 2.0,
		this.enableGradients = false,
		this.enableBlur = false,
		this.primaryColor,
		this.onPrimaryColor,
	});

	static ShopKitThemeConfig forStyle(ShopKitThemeStyle style, BuildContext context) {
		final theme = Theme.of(context).extension<ShopKitTheme>();
		return ShopKitThemeConfig(
			backgroundColor: theme?.surfaceColor,
			borderRadius: 8.0,
			enableShadows: true,
			shadowColor: theme?.onSurfaceColor,
			elevation: 2.0,
			enableGradients: false,
			enableBlur: false,
			primaryColor: theme?.primaryColor,
			onPrimaryColor: theme?.onPrimaryColor,
		);
	}
}
