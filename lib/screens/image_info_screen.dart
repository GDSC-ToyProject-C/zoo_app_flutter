import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'dart:io';
import './stamp_screen.dart';
import '../custom_widget/custom_dialog.dart';
import '../data/my_locatoin.dart';
import '../size.dart';

class ImageInfoScreen extends StatefulWidget {
  final XFile image;
  ImageInfoScreen({required this.image});

  @override
  _ImageCheckScreenState createState() => _ImageCheckScreenState();
}

class _ImageCheckScreenState extends State<ImageInfoScreen> {
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
    //
    isInZoo = await isUserInZoo();
    isAnimalRight = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          animalName: 'tempname',
          stampPossible: isInZoo,
        );
      },
    );
    if (!isAnimalRight) {
      //go to mainpage
      Navigator.pop(context);
    }
  }

  Future<bool> isUserInZoo() async {
    MyLocation myLct = MyLocation();
    await myLct.getMyCurrentLocation(); //자신의 위치 받아옴

    return await PolygonUtil.containsLocation(
      //지정한 다각형 안에 내가 있으면 true반환
      LatLng(myLct.Latit, myLct.Longit),
      Zoo_Lct,
      true,
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
      body: ImageScreen(),
    );
  }

  Widget ImageScreen() {
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
              //메인 화면 코드 재활용
              FirstStampBackground(context),
              SecondStampBackground(context, SizedBox(), ''),
              ImageShow(widget.image),
            ],
          ),
        ],
      ),
    );
  }

  Widget ImageShow(XFile _image) {
    return Column(
      children: [
        SizedBox(height: 21 * getScaleHeight(context)),
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
}
