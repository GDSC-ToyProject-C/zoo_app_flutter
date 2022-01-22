import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void initFirebase() async {
  print(await Firebase.initializeApp());
}

Future<String> getAnimalLink(String animal) async {
  String _link;
  final _collectionRef = FirebaseFirestore.instance
      .collection('my_zoo')
      .doc('lnnGoBhrzBTfEYxgShJb');
  var _docSnapshot = await _collectionRef.get();
  _link = _docSnapshot['links'][animal];
  print('link: ${_link}');
  return _link;
}

Future<List> getStamp() async {
  //db에서 스탬프 등등 가져오기
  List _stampList = [];
  final _collectionRef = FirebaseFirestore.instance
      .collection('my_zoo')
      .doc('vf8v4L6SXYiD3sULETNY');
  var _docSnapshot = await _collectionRef.get();
  _stampList = _docSnapshot['stamp'];
  print("stamp list: ${_stampList}");
  return _stampList;
}

Future addStamp(String animal) async {
  final _collectionRef = FirebaseFirestore.instance
      .collection('my_zoo')
      .doc('vf8v4L6SXYiD3sULETNY');
  _collectionRef.update({
    'stamp': FieldValue.arrayUnion([animal])
  });
}
