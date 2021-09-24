import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirestoreChanges extends ChangeNotifier {
  Future future = Future(() => null);

}

Future getFromFirestore() async {
  var data = await FirebaseFirestore.instance
      .collection('flutter-caching')
      .get(const GetOptions(source: Source.server));
  var array = data.docs.map((e) {
    return {'name': e['name']};
  }).toList();
  return array;
}
