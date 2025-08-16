import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `VariantPicker` widget.
@immutable
class VariantPickerTheme extends ThemeExtension<VariantPickerTheme> {
  final Color? selectedChipColor;
  final Color? unselectedChipColor;
  final TextStyle? selectedChipTextStyle;
  final TextStyle? unselectedChipTextStyle;
  final BorderSide? selectedChipBorder;
  final BorderSide? unselectedChipBorder;
  final TextStyle? groupTitleStyle;

  const VariantPickerTheme({
    this.selectedChipColor,
    this.unselectedChipColor,
    this.selectedChipTextStyle,
    this.unselectedChipTextStyle,
    this.selectedChipBorder,
    this.unselectedChipBorder,
    this.groupTitleStyle,
  });

  @override
  VariantPickerTheme copyWith({
    Color? selectedChipColor,
    Color? unselectedChipColor,
    TextStyle? selectedChipTextStyle,
    TextStyle? unselectedChipTextStyle,
    BorderSide? selectedChipBorder,
    BorderSide? unselectedChipBorder,
    TextStyle? groupTitleStyle,
  }) {
    return VariantPickerTheme(
      selectedChipColor: selectedChipColor ?? this.selectedChipColor,
      unselectedChipColor: unselectedChipColor ?? this.unselectedChipColor,
      selectedChipTextStyle: selectedChipTextStyle ?? this.selectedChipTextStyle,
      unselectedChipTextStyle: unselectedChipTextStyle ?? this.unselectedChipTextStyle,
      selectedChipBorder: selectedChipBorder ?? this.selectedChipBorder,
      unselectedChipBorder: unselectedChipBorder ?? this.unselectedChipBorder,
      groupTitleStyle: groupTitleStyle ?? this.groupTitleStyle,
    );
  }

  @override
  VariantPickerTheme lerp(ThemeExtension<VariantPickerTheme>? other, double t) {
    if (other is! VariantPickerTheme) {
      return this;
    }
    return VariantPickerTheme(
      selectedChipColor: Color.lerp(selectedChipColor, other.selectedChipColor, t),
      unselectedChipColor: Color.lerp(unselectedChipColor, other.unselectedChipColor, t),
      selectedChipTextStyle: TextStyle.lerp(selectedChipTextStyle, other.selectedChipTextStyle, t),
      unselectedChipTextStyle: TextStyle.lerp(unselectedChipTextStyle, other.unselectedChipTextStyle, t),
      selectedChipBorder: BorderSide.lerp(selectedChipBorder ?? BorderSide.none, other.selectedChipBorder ?? BorderSide.none, t),
      unselectedChipBorder: BorderSide.lerp(unselectedChipBorder ?? BorderSide.none, other.unselectedChipBorder ?? BorderSide.none, t),
      groupTitleStyle: TextStyle.lerp(groupTitleStyle, other.groupTitleStyle, t),
    );
  }
}