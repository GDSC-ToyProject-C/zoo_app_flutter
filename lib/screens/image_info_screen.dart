import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import '../custom_widget/custom_dialog.dart';
import '../custom_widget/child_fab.dart';
import '../data/my_locatoin.dart';
import '../data/crawling_data.dart';
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
  late Future _getAnimalInfoOnce;
  @override
  void initState() {
    _getAnimalInfoOnce = getAnimalInfo('');
    checkImage(); //이미지 체크(커스텀 다이얼로그 사용)
    super.initState();
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xfffefffb),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _ImageInfoScreen(),
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

  Widget _ImageInfoScreen() {
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
      duration: Duration(microseconds: 50),
      curve: Curves.bounceIn,
      child: Column(
        children: [
          SizedBox(height: 12 * getScaleHeight(context)),
          Container(
            width: 312 * getScaleWidth(context),
            // height: (showInfo ? double. : double.minPositive) *
            //     getScaleHeight(context),
            constraints: BoxConstraints(minHeight: double.minPositive),
            padding: showInfo
                ? EdgeInsets.all(10 * getScaleWidth(context))
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              border: Border.all(color: const Color(0xff707070), width: 1),
              color: const Color(0xffffffff),
            ),

            child: FutureBuilder(
              future: _getAnimalInfoOnce, //FutureBuilder 메모리 누수 방지
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error from get animal data');
                } else if (snapshot.hasData) {
                  print((snapshot.data as List)[0].length);
                  print((snapshot.data as List)[1].length);
                  print((snapshot.data as List)[0].length +
                      (snapshot.data as List)[1].length);
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: ((snapshot.data as List)[0].length) +
                        (snapshot.data as List)[1].length,
                    itemBuilder: (context, idx) {
                      if (idx >= ((snapshot.data as List)[0].length)) {
                        //상세 설명
                        String desc = (snapshot.data as List)[1]
                                [idx - (snapshot.data as List)[0].length]
                            .join();
                        if (desc.isNotEmpty) {
                          //비어있지 않은 리스트만 출력
                          return Text('\n' + desc);
                        }
                        return SizedBox(); //비어있다면 빈 박스 출력
                      } else {
                        dynamic sumup = (snapshot.data as List)[0][idx];
                        return Text(
                            ('${sumup.keys.join()} : ${sumup.values.join()}'));
                      }
                    },
                  );
                } else {
                  return Center(
                    child: showInfo
                        ? SizedBox(
                            width: 50 * getScaleWidth(context),
                            height: 50 * getScaleHeight(context),
                            child: CircularProgressIndicator(
                              color: Color(0xfff8a442),
                            ))
                        : SizedBox(),
                  );
                }
              },
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
              duration: Duration(milliseconds: 50),
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
