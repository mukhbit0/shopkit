import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model representing a menu item for navigation
class MenuItemModel extends Equatable {
  const MenuItemModel({
    required this.id,
    required this.label,
    required this.route,
    this.iconUrl,
    this.icon,
    this.badgeCount,
    this.isEnabled = true,
    this.subItems,
  });

  /// Unique identifier for the menu item
  final String id;

  /// Display label for the menu item
  final String label;

  /// Navigation route/path for the menu item
  final String route;

  /// Optional icon URL for the menu item
  final String? iconUrl;

  /// Optional icon widget for the menu item
  final Widget? icon;

  /// Optional badge count to show notifications
  final int? badgeCount;

  /// Whether the menu item is enabled
  final bool isEnabled;

  /// Optional sub-menu items for dropdown/expandable menus
  final List<MenuItemModel>? subItems;

  /// Create MenuItemModel from JSON
  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
        id: json['id'] as String,
        label: json['label'] as String,
        route: json['route'] as String,
        iconUrl: json['iconUrl'] as String?,
        badgeCount: json['badgeCount'] as int?,
        isEnabled: json['isEnabled'] as bool? ?? true,
        subItems: (json['subItems'] as List<dynamic>?)
            ?.map(
                (item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  /// Convert MenuItemModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'route': route,
        'iconUrl': iconUrl,
        'badgeCount': badgeCount,
        'isEnabled': isEnabled,
        'subItems': subItems?.map((item) => item.toJson()).toList(),
      };

  /// Create a copy with modified properties
  MenuItemModel copyWith({
    String? id,
    String? label,
    String? route,
    String? iconUrl,
    Widget? icon,
    int? badgeCount,
    bool? isEnabled,
    List<MenuItemModel>? subItems,
  }) =>
      MenuItemModel(
        id: id ?? this.id,
        label: label ?? this.label,
        route: route ?? this.route,
        iconUrl: iconUrl ?? this.iconUrl,
        icon: icon ?? this.icon,
        badgeCount: badgeCount ?? this.badgeCount,
        isEnabled: isEnabled ?? this.isEnabled,
        subItems: subItems ?? this.subItems,
      );

  @override
  List<Object?> get props => [
        id,
        label,
        route,
        iconUrl,
        badgeCount,
        isEnabled,
        subItems,
      ];
}
