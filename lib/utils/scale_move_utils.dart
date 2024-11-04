import 'package:flutter_on_class_011/constants/ui_constants.dart';

double scaleLinearFromCenter(double value, double center, [double scale = defaultScalingFactor]) {
  return (value - center) * scale + center;
}
