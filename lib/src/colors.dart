import 'dart:ui';

abstract class WxColors {
  /// Completely invisible.
  static const Color transparent = Color(0x00000000);

  /// Completely opaque black.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/material/Colors.blacks.png)
  ///
  /// See also:
  ///
  ///  * [black87], [black54], [black45], [black38], [black26], [black12], which
  ///    are variants on this color but with different opacities.
  ///  * [white], a solid white color.
  ///  * [transparent], a fully-transparent color.
  static const Color black = Color(0xFF000000);

  /// Completely opaque white.
  ///
  /// This is a good contrasting color for the [ThemeData.primaryColor] in the
  /// dark theme. See [ThemeData.brightness].
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/material/Colors.whites.png)
  ///
  /// See also:
  ///
  ///  * [Typography.white], which uses this color for its text styles.
  ///  * [Theme.of], which allows you to select colors from the current theme
  ///    rather than hard-coding colors in your build methods.
  ///  * [white70, white60, white54, white38, white30, white12, white10], which are variants on this color
  ///    but with different opacities.
  ///  * [black], a solid black color.
  ///  * [transparent], a fully-transparent color.
  static const Color white = Color(0xFFFFFFFF);

  /// Determines whether the given [Color] is [Brightness.light] or
  /// [Brightness.dark].
  ///
  /// This compares the luminosity and opacity of the given color
  /// to a threshold value that matches the material design specification.
  static Brightness? brightnessFor(Color? color) {
    if (color == null) return null;

    // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
    // The spec says to use kThreshold=0.0525, but Material Design appears to bias
    // more towards using light text than WCAG20 recommends. Material Design spec
    // doesn't say what value to use, but 0.15 seemed close to what the Material
    // Design spec shows for its color palette on
    // <https://material.io/go/design-theming#color-color-palette>.
    const kLuminanceThreshold = 0.15;
    const kOpaqueThreshold = 0.6;

    final relativeLuminance = color.computeLuminance();
    final luminance = (relativeLuminance + 0.05) * (relativeLuminance + 0.05);
    final isLight = luminance > kLuminanceThreshold;
    final isOpaque = color.opacity > kOpaqueThreshold;

    return isLight
        ? isOpaque
            ? Brightness.light
            : Brightness.dark
        : isOpaque
            ? Brightness.dark
            : Brightness.light;
  }

  /// Estimate foreground color on surface
  static Color? onSurface(
    Color? surface, [
    Color? onLight = black,
    Color? onDark = white,
  ]) {
    if (surface == null) return null;
    final brightness = brightnessFor(surface);
    return brightness == Brightness.light ? onLight : onDark;
  }

  /// Returns a new color that matches this color
  /// with the alpha channel replaced with
  /// the given opacity (which ranges from 0.0 to 1.0).
  static Color? withOpacity(Color? color, double? opacity) {
    return opacity != null ? color?.withOpacity(opacity) : color;
  }

  /// Returns a new color that matches this color
  /// with the alpha channel replaced
  /// with a (which ranges from 0 to 255).
  static Color? withAlpha(Color? color, int? alpha) {
    return alpha != null ? color?.withAlpha(alpha) : color;
  }

  /// Returns a new color that matches this color
  /// with the alpha channel replaced with the given opacity (which ranges from 0.0 to 1.0),
  /// and/or with the alpha channel replaced with a (which ranges from 0 to 255).
  static Color? withTransparency(
    Color? color, {
    double? opacity,
    int? alpha,
  }) {
    color = WxColors.withOpacity(color, opacity);
    color = WxColors.withAlpha(color, alpha);
    return color;
  }
}
