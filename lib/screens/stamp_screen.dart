import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:zoo_app/custom_widget/child_fab.dart';
import 'package:zoo_app/data/firestore_data_control.dart';
import '../custom_widget/expandable_fab.dart';
import '../size.dart';
import '../custom_widget/stamp_tile.dart';
import './image_info_screen.dart';
import '../data/my_locatoin.dart';

class stampScreen extends StatefulWidget {
  @override
  State<stampScreen> createState() => _stampScreenState();
}

class _stampScreenState extends State<stampScreen> {
  final ImagePicker _picker = ImagePicker();
  late List _stampList;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3c766),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfff8a442),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6 * getScaleHeight(context)),
          child: Container(
            color: Color(0xff66491e),
            height: 6.0 * getScaleHeight(context),
          ),
        ),
      ),
      body: stampPage(),
      floatingActionButton: ParentActionButton(
        distance: 70.0,
        children: [
          //카메라 버튼
          ChildActionButton(
            onpressed: () {
              MyLocation temp = MyLocation();
              temp.getMyCurrentLocation();
              // pickImage(true);
            },
            icon: Icon(Icons.camera_alt_outlined),
          ),

          //갤러리 버튼
          ChildActionButton(
            onpressed: () {
              pickImage(false);
            },
            icon: Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
    );
  }

  void pickImage(bool isCam) async {
    final XFile? _image;
    try {
      _image = await _picker.pickImage(
          source: isCam ? ImageSource.camera : ImageSource.gallery);

      if (_image != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageInfoScreen(image: _image!, stampList: _stampList),
          ),
        );
        setState(() {
          //futureBuilder rebuild
          print('setState : stamp view rebuild');
        });
      }
    } catch (err) {
      print('err: from get Image');
      print(err);
    }
  }

  Widget stampPage() {
    return FutureBuilder(
        future: getStamp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('err');
          }
          print('stemp snap data: ${snapshot.data}');
          if (snapshot.hasData) {
            _stampList = snapshot.data as List;
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30 * getScaleHeight(context),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    //갈색 배경(제일 아래)
                    _FirstStampBackground(),

                    //베이지 배경 컨테이너(공백, 베이지 배경)
                    //그리드 뷰 포함
                    _SecondStampBackground(
                        snapshot.hasData
                            ? _StampGridView(snapshot.data)
                            : Center(child: CircularProgressIndicator()),
                        '동물스탬프')
                  ],
                ),
                //스탬프 개수 count

                _ViewStampCount(snapshot.hasData ? snapshot.data : []),
              ],
            ),
          );
        });
  }

  Widget _ViewStampCount(dynamic stamp) {
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
            "획득한 스탬프 ${stamp.length} / ${MAX_ANIMAL}",
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

  Widget _StampGridView(dynamic stamp) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: MAX_ANIMAL,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 120 *
                getScaleWidth(context) /
                134 *
                getScaleHeight(context), //tile의 비율
            mainAxisSpacing: 25 * getScaleHeight(context), //수평 padding
            crossAxisSpacing: 28 * getScaleWidth(context), //수직 padding
          ),
          itemBuilder: (BuildContext context, int idx) {
            for (dynamic name in stamp) {
              if (idx == get_animal_idx[name]) {
                return StampTile(animalName: name);
              }
            }
            return StampTile(animalName: 'null');
          }),
    );
  }

  Column _SecondStampBackground(Widget widget, String text) {
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
              child: widget,
            ),
            // 동물스탬프
            Text(
              text,
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

  Container _FirstStampBackground() {
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
