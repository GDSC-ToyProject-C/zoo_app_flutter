import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void initFirebase() async {
  print(await Firebase.initializeApp());
}

Future<List> getStamp() async {
  //db에서 스탬프 등등 가져오기
  List _stampList = [];
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
