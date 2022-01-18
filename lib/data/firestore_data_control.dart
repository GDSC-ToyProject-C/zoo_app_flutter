import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void initFirebase() async {
  await Firebase.initializeApp();
}

Future<List> getStamp() async {
  //db에서 스탬프 등등 가져오기
  List _stampList = [];
  // final collectionRef = await FirebaseFirestore.instance.collection('my_zoo');
  // collectionRef.snapshots().listen((event) {
  //   event.docs.forEach((element) {
  //     // print('data: ${element.data()['stamp']}');
  //     _stampList.addAll(element.data()['stamp']);
  //   });
  // });
  final collectionRef = FirebaseFirestore.instance
      .collection('my_zoo')
      .doc('vf8v4L6SXYiD3sULETNY');
  var docSnapshot = await collectionRef.get();
  _stampList = docSnapshot['stamp'];
  print(_stampList);
  return _stampList;
}

Future addStamp(String animal) async {
  final collectionRef = FirebaseFirestore.instance
      .collection('my_zoo')
      .doc('vf8v4L6SXYiD3sULETNY');
  collectionRef.update({
    'stamp': FieldValue.arrayUnion([animal])
  });
}
