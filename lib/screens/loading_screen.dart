//로딩 page
//위치정보, 데이터 가져오기

import 'package:flutter/material.dart';
import 'package:zoo_app/screens/stamp_screen.dart';
import 'package:zoo_app/size.dart';
import '../data/get_stamp.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late AnimationController _controller; //progress bar를 위한 _controller
  Map _stampMap = {};
  @override
  void initState() {
    //gps좌표 받아오기(사진찍을때만 필요한가...)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {
          // progress bar가 다 찼고, 유저의 스탬프를 받아왔다면 다음화면으로
          if (_controller.isCompleted & _stampMap.isNotEmpty) {
            print('loading complt');
            print('data: ${_stampMap}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => stampScreen(stampData: _stampMap)),
              (route) => false,
            );
          }
        });
      });

    LoadingData(); //get user stamp data
    _controller.forward(); //start progressbar
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      backgroundColor: const Color(0xfff3c766),
      body: LoadingPage(_controller),
    );
  }

  Future<void> LoadingData() async {
    //get user stamp data
    try {
      _stampMap = await getStamp();
      await Future.delayed(Duration(seconds: 5));
      print(_controller.isCompleted);
      print(_stampMap.isEmpty);
    } catch (err) {
      print('error: from get user stamp data, retry get data');
    }
  }

  Widget LoadingPage(AnimationController _controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 133 * getScaleHeight(context)),
          //로딩 화면에 네모와 사진을 스택으로
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 200 * getScaleWidth(context),
                height: 200 * getScaleHeight(context),
                decoration: BoxDecoration(
                  color: const Color(0xfff8a442),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x66000000),
                      offset: Offset(0, 3),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
              ),
              Image.asset(
                'images/giraffe.png',
                width: 150 * getScaleWidth(context),
                height: 150 * getScaleHeight(context),
              ),
            ],
          ),
          SizedBox(height: 10 * getScaleHeight(context)),

          //앱 이름
          Text(
            'Zoo App',
            style: TextStyle(
              color: Color(0xfffefffb),
              fontWeight: FontWeight.w400,
              fontFamily: 'NotoSans',
              fontStyle: FontStyle.normal,
              fontSize: 30.0,
            ),
          ),
          SizedBox(height: 258 * getScaleHeight(context)),

          //컨테이너와 progressbar를 겹쳐서 그림자 표시하고 둥글게 만듦
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 31 * getScaleHeight(context),
                width: 160 * getScaleWidth(context),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: const Color(0x66000000),
                    offset: Offset(0, 3),
                    blurRadius: 6.0,
                  )
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: _controller.value,
                    color: const Color(0xfff8a442),
                  ),
                ),
              ),
              Text(
                '로딩중입니다.',
                style: const TextStyle(
                  color: const Color(0xfffefffb),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}