import 'dart:ui';

Size applyAspectRatio(Rect src, double aspectRatio) {
  double width = src.longestSide;
  double height;

  // If the width is infinite infer the height from the width.
  if (width.isFinite) {
    height = width / aspectRatio;
  } else {
    height = src.height;
    width = height * aspectRatio;
  }

  if (width > src.width) {
    width = src.width;
    height = width / aspectRatio;
  }

  if (height > src.height) {
    height = src.height;
    width = height * aspectRatio;
  }

  return Size(width, height);
}
