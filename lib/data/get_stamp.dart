import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map> getStamp() async {
  //db에서 스탬프 등등 가져오기
  // List tempStamp = ['giraffe', 'lion']; //임시 정보
  Map _stampMap = {};
  await Firebase.initializeApp();
  FirebaseFirestore.instance.collection('my_zoo').snapshots().listen((event) {
    event.docs.forEach((element) {
      // print('data: ${element.data()['stamp']}');
      _stampMap.addAll(element.data()['stamp']);
    });
  });
  return _stampMap;
}
