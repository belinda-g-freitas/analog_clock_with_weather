enum WindowSizeEnum {
  size1x(394, 294.0, "Mobile Portrait"),
  size2x(494, 394, "Mobile Landscape"),
  size3x(594, 494, "Tablet Portrait");
  // tabletLandscape(874, 607, "Tablet Landscape"),
  // desktop(1440, 900, "Desktop");

  const WindowSizeEnum(this.width, this.height, this.description);
  final double width;
  final double height;
  final String description;
}
