import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import '../custom_widget/custom_dialog.dart';
import '../custom_widget/child_fab.dart';
import '../data/my_locatoin.dart';
import '../size.dart';

class ImageInfoScreen extends StatefulWidget {
  final XFile image;
  final List stampList;
  ImageInfoScreen({required this.image, required this.stampList});

  @override
  _ImageCheckScreenState createState() => _ImageCheckScreenState();
}

class _ImageCheckScreenState extends State<ImageInfoScreen> {
  bool showInfo = false;
  late String animalName;
  @override
  void initState() {
    super.initState();
    checkImage(); //이미지 체크(커스텀 다이얼로그 사용)
  }

  Future<void> checkImage() async {
    bool isAnimalRight;
    bool isInZoo;
    //ML 코드 여기에
    //
    animalName = 'tempname';
    ////
    isInZoo = await isUserInZoo();
    isAnimalRight = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          animalName: animalName,
          stampPossible: isInZoo,
        );
      },
    );
    if (!isAnimalRight) {
      //go to mainpage
      Navigator.pop(context);
    }

    setState(() {
      showInfo = true;
    });

    showToast(animalName, widget.stampList.contains(animalName) ? true : false);
  }

  Future<bool> isUserInZoo() async {
    MyLocation myLct = MyLocation();
    await myLct.getMyCurrentLocation(); //자신의 위치 받아옴

    return await PolygonUtil.containsLocation(
      //지정한 다각형 안에 내가 있으면 true반환
      LatLng(myLct.Latit, myLct.Longit),
      Zoo_Lct,
      false,
    );
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
      body: _InfoScreen(),
      floatingActionButton: ChildActionButton(
        icon: Icon(
          Icons.house_outlined,
          semanticLabel: 'big',
        ),
        onpressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _InfoScreen() {
    //이미지 표시 전 배경
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
              _FirstInfoBackground(),
              _SecondInfoBackground(),
              Column(
                children: [
                  SizedBox(height: 21 * getScaleHeight(context)),
                  Container(
                    width: 312 * getScaleWidth(context),
                    height: 511 * getScaleWidth(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            ImageShow(widget.image),
                            InfoShow(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget InfoShow() {
    return AnimatedContainer(
      duration: Duration(microseconds: 300),
      curve: Curves.bounceIn,
      child: Column(
        children: [
          SizedBox(height: 12 * getScaleHeight(context)),
          Container(
            width: 312 * getScaleWidth(context),
            height: (showInfo ? 300 : 1) * getScaleHeight(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              border: Border.all(color: const Color(0xff707070), width: 1),
              color: const Color(0xffffffff),
            ),
          ),
        ],
      ),
    );
  }

  Widget ImageShow(XFile _image) {
    return Column(
      children: [
        Container(
          width: 312 * getScaleWidth(context),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0x33000000),
                offset: Offset(0, 3),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Image.file(
            File(_image.path),
            fit: BoxFit.contain,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _SecondInfoBackground() {
    return Column(
      children: [
        Column(
          children: [
            //두 배경 사이 위쪽 공백
            SizedBox(
              height: 8 * getScaleHeight(context),
            ),

            //베이지 배경
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              margin: EdgeInsets.only(bottom: 8 * getScaleHeight(context)),
              width: 338 * getScaleWidth(context),
              height: (showInfo ? 521 : 440) * getScaleHeight(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                color: const Color(0xffd6d2cb),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _FirstInfoBackground() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      width: 350 * getScaleWidth(context),
      height: (showInfo ? 563 : 500) * getScaleHeight(context),
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

  void showToast(String message, bool exist) {
    Fluttertoast.showToast(
      msg: exist
          ? "${message}은(는) 이미 등록되어있습니다."
          : "${message}이(가) 스탬프에 등록되었습니다.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xfff59a3b),
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }
}
