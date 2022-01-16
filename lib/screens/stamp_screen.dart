import 'package:flutter/material.dart';
import 'package:zoo_app/custom_widget/child_fab.dart';
import '../custom_widget/expandable_fab.dart';
import 'package:zoo_app/size.dart';

class stampScreen extends StatefulWidget {
  final dynamic stampData;
  stampScreen({required this.stampData});

  @override
  State<stampScreen> createState() => _stampScreenState();
}

class _stampScreenState extends State<stampScreen> {
  @override
  void initState() {
    //그리드뷰 만들때 참고
    for (String animal in animal_list) {
      try {
        print(widget.stampData[animal]);
      } catch (err) {
        print(animal);
      }
    }
    print(widget.stampData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3c766),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Zoo App',
          style: const TextStyle(
            color: const Color(0xfffefffb),
            fontWeight: FontWeight.w400,
            fontFamily: 'NotoSans',
            fontStyle: FontStyle.normal,
            fontSize: 30.0,
          ),
        ),
        backgroundColor: Color(0xfff8a442),
      ),
      body: stampPage(),
      floatingActionButton: ParentActionButton(
        distance: 70.0,
        children: [
          //카메라 버튼
          ChildActionButton(
            onpressed: () {
              //go to camera
            },
            icon: Icon(Icons.camera_alt_outlined),
          ),

          //갤러리 버튼
          ChildActionButton(
            onpressed: () {
              //go to album
            },
            icon: Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
    );
  }

  Widget stampPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30 * getScaleHeight(context),
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              //갈색 배경(제일 아래)
              FirstStampBackground(),

              //베이지 배경 컨테이너(공백, 베이지 배경)
              SecondStampBackground(),

              //그리드뷰(스크롤가능)
            ],
          ),
          //스탬프 개수 count
          ViewStampCount(),
        ],
      ),
    );
  }

  Widget ViewStampCount() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.fromLTRB(
          32 * getScaleWidth(context), 22 * getScaleHeight(context), 0, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 224 * getScaleWidth(context),
            height: 60 * getScaleHeight(context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(39)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xcc000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
                color: const Color(0xff383839)),
          ),
          Container(
            width: 210 * getScaleWidth(context),
            height: 44 * getScaleHeight(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xcc000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
              color: const Color(0xffefece8),
            ),
          ),
          Text(
            "획득한 스탬프 ${widget.stampData.length} / ${MAX_ANIMAL}",
            style: const TextStyle(
              color: const Color(0xff343435),
              fontWeight: FontWeight.w400,
              fontFamily: "NotoSans",
              fontStyle: FontStyle.normal,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Column SecondStampBackground() {
    return Column(
      children: [
        Column(
          children: [
            //두 배경 사이 위쪽 공백
            SizedBox(
              height: 8 * getScaleHeight(context),
            ),

            //베이지 배경
            Container(
              margin: EdgeInsets.only(bottom: 8 * getScaleHeight(context)),
              width: 338 * getScaleWidth(context),
              height: 440 * getScaleHeight(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                color: const Color(0xffd6d2cb),
              ),
            ),
            // 동물스탬프
            Text(
              "동물스탬프",
              style: const TextStyle(
                color: const Color(0xfffefffb),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSans",
                fontStyle: FontStyle.normal,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container FirstStampBackground() {
    return Container(
      width: 350 * getScaleWidth(context),
      height: 500 * getScaleHeight(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        border: Border.all(color: const Color(0xff707070), width: 1),
        boxShadow: [
          BoxShadow(
              color: const Color(0xcc000000),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 0)
        ],
        color: const Color(0xffa69988),
      ),
    );
  }
}
