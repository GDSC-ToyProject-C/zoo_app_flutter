import 'package:flutter/material.dart';

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
