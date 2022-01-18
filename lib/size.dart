import 'package:flutter/material.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

double getScaleWidth(BuildContext context) {
  const designGuidWidth = 412;
  final width = MediaQuery.of(context).size.width / designGuidWidth;
  return width;
}

double getScaleHeight(BuildContext context) {
  const designGuidHeight = 778;
  final height = MediaQuery.of(context).size.height / designGuidHeight;
  return height;
}

var temp = List<String>.filled(12, 0.toString(), growable: true);
final List<String> animal_list = ['giraffe', '???', 'lion']..addAll(temp);
final int MAX_ANIMAL = animal_list.length;

final LatLng Zoo1 = LatLng(36.766793, 126.930935);
final LatLng Zoo2 = LatLng(36.766699, 126.933846);
final LatLng Zoo3 = LatLng(36.768690, 126.935727);
final LatLng Zoo4 = LatLng(36.770735, 126.934868);
final LatLng Zoo5 = LatLng(36.773107, 126.933452);
final LatLng Zoo6 = LatLng(36.768621, 126.926908);
final List<LatLng> Zoo_Lct = [Zoo1, Zoo2, Zoo3, Zoo4, Zoo5, Zoo6];
