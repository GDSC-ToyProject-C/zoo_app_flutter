import 'package:flutter/material.dart';
import '../size.dart';

class StampTile extends StatelessWidget {
  final String animalName;
  StampTile({required this.animalName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        //타일 백그라운드
        Container(
          width: 120 * getScaleWidth(context),
          height: 134 * getScaleHeight(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(19)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x1a000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 0)
            ],
            color: const Color(0xfff3c766),
          ),
        ),

        //타일 이미지, 텍스트
        Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 9, 0, 5),
              width: 100 * getScaleWidth(context),
              height: 100 * getScaleHeight(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(19)),
                color: const Color(0xfff8a442),
              ),
              child: Image.asset(
                animalName == 'null'
                    ? 'images/stamp2.png'
                    : 'images/${animalName}.png',
                scale: 7.3 * getScaleWidth(context),
              ),
            ),
            Text(
              animalName == 'null' ? '???' : animalName,
              style: const TextStyle(
                color: const Color(0xff66491e),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSans",
                fontStyle: FontStyle.normal,
                fontSize: 10.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}
