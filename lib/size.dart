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

final List<String> animal_list = [
  '개',
  '말',
  '코끼리',
  '나비',
  '닭',
  '고양이',
  '소',
  '양',
  '거미',
  '다람쥐'
];
final Map<String, int> get_animal_idx = {
  'dog': 0,
  'horse': 1,
  'elephant': 2,
  'butterfly': 3,
  'chicken': 4,
  'cat': 5,
  'cow': 6,
  'sheep': 7,
  'spider': 8,
  'squirrel': 9
};
final int MAX_ANIMAL = animal_list.length;

final LatLng Zoo1 = LatLng(36.766793, 126.930935);
final LatLng Zoo2 = LatLng(36.766699, 126.933846);
final LatLng Zoo3 = LatLng(36.768690, 126.935727);
final LatLng Zoo4 = LatLng(36.770735, 126.934868);
final LatLng Zoo5 = LatLng(36.773107, 126.933452);
final LatLng Zoo6 = LatLng(36.768621, 126.926908);
final List<LatLng> Zoo_Lct = [Zoo1, Zoo2, Zoo3, Zoo4, Zoo5, Zoo6];
