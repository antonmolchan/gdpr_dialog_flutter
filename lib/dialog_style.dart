
import 'dart:ui';


/// Class that contains information to customize the style of the dialog
class GdprDialogStyle {
  final Color? backgroundColor;
  final int? dialogBorderRadius;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;
  final Color? linkColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final int? buttonBorderRadius;
  final int? buttonBorderSize;
  final Color? buttonBorderColor;

  GdprDialogStyle({
    this.backgroundColor,
    this.dialogBorderRadius,
    this.primaryTextColor,
    this.secondaryTextColor,
    this.linkColor,
    this.buttonColor,
    this.buttonTextColor,
    this.buttonBorderRadius,
    this.buttonBorderSize,
    this.buttonBorderColor
  });

  String? get backgroundColorHex => _toHex(backgroundColor);

  String? get primaryTextColorHex => _toHex(primaryTextColor);

  String? get secondaryTextColorHex => _toHex(secondaryTextColor);

  String? get linkColorHex => _toHex(linkColor);

  String? get buttonColorHex => _toHex(buttonColor);

  String? get buttonTextColorHex => _toHex(buttonTextColor);

  String? get buttonBorderColorHex => _toHex(buttonBorderColor);

  ///Convert a color to hexadecimal
  String? _toHex(Color? color) {
    if(color == null) return null;
    return '#'
        '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';
  }
}