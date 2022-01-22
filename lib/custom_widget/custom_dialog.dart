import 'package:flutter/material.dart';
import '../data/firestore_data_control.dart';
import '../size.dart';

class CustomDialog extends StatefulWidget {
  final String animal;
  final bool stampPossible;
  CustomDialog({
    required this.animal,
    required this.stampPossible,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      child: DialogBox(),
    );
  }

  Widget DialogBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 250 * getScaleWidth(context),
        height: 134 * getScaleHeight(context),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x1a000000),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
          color: const Color(0xffffffff),
        ),
        //다이얼로그 내용
        child: widget.animal == 'recog_fail' ? recogFail() : checkAnimal(),
      ),
    );
  }

  Column recogFail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          //텍스트 컨테이너
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "인식할 수 없는 동물입니다.",
              style: const TextStyle(
                color: const Color(0xff343435),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSans",
                fontStyle: FontStyle.normal,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        //버튼 컨테이너
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                    100 * getScaleWidth(context), 40 * getScaleHeight(context)),
                primary: Color(0xffeea300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Text(
                "메인으로 돌아가기",
                style: const TextStyle(
                  color: const Color(0xff343435),
                  fontWeight: FontWeight.w600,
                  fontFamily: "NotoSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        )
      ],
    );
  }

  Column checkAnimal() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          //텍스트 컨테이너
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "사진 속 동물이",
              style: const TextStyle(
                color: const Color(0xff343435),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSans",
                fontStyle: FontStyle.normal,
                fontSize: 10.0,
              ),
            ),
            Text(
              animal_list[get_animal_idx[
                  widget.animal]!], //이부분은 나중에 엠엘 돌리고 난 후 이미지에 맞는 이름으로 변경
              style: const TextStyle(
                color: const Color(0xff343435),
                fontWeight: FontWeight.w600,
                fontFamily: "NotoSans",
                fontStyle: FontStyle.normal,
                fontSize: 15.0,
              ),
            ),
            Text(
              "이(가) 맞나요?",
              style: const TextStyle(
                color: const Color(0xff343435),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSans",
                fontStyle: FontStyle.normal,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
        widget.stampPossible
            ? SizedBox(height: 17 * getScaleHeight(context))
            : Text(
                "(동물원 안에 있지 않아 스탬프를 획득하실 수 없습니다)",
                style: const TextStyle(
                  color: const Color(0xff343435),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 9.0,
                ),
              ),

        //버튼 컨테이너
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                    100 * getScaleWidth(context), 40 * getScaleHeight(context)),
                primary: Color(0xffeea300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Text(
                "네",
                style: const TextStyle(
                  color: const Color(0xff343435),
                  fontWeight: FontWeight.w600,
                  fontFamily: "NotoSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
              ),
              onPressed: () async {
                //go to info page
                if (widget.stampPossible) {
                  //동물원 안에 있다면 DB에 스탬프 등록
                  await addStamp(widget.animal)
                      .whenComplete(() => Navigator.pop(context, true));
                } else {
                  //아니라면 등록하지않음
                  Navigator.pop(context, true);
                }
              },
            ),
            SizedBox(width: 10 * getScaleWidth(context)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                    100 * getScaleWidth(context), 40 * getScaleHeight(context)),
                primary: Color(0xfff3c766),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Text(
                "아니요",
                style: const TextStyle(
                  color: const Color(0xff343435),
                  fontWeight: FontWeight.w600,
                  fontFamily: "NotoSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.left,
              ),
              onPressed: () {
                //go to main
                Navigator.pop(context, false);
              },
            ),
          ],
        )
      ],
    );
  }
}
