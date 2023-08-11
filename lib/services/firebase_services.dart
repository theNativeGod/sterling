import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  Dio dio = Dio();
  var response;
  var storage = FirebaseStorage.instance;
  var firestore = FirebaseFirestore.instance;

  uploadImageToStorage(userId, image) async {
    print('here');
    String uniqueImageName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('user_images');
    Reference referenceImageToUpload =
        referenceDirImages.child(uniqueImageName);
    print('image');
    print(image);
    try {
      await referenceImageToUpload.putFile(File(image!.path));
      var imageUrl = await referenceImageToUpload.getDownloadURL();
      return await uploadImageToCloud(userId, imageUrl);
    } catch (e) {
      print(e);
    }
  }

  uploadImageToCloud(userId, imageUrl) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var docRef = await firestore.collection('users').doc(userId.toString());
      await docRef.set({
        'imageUrl': imageUrl,
      });
      return imageUrl;
    } catch (e) {
      print(e);
    }
  }

  getImageFromCloud(userId) async {
    try {
      FirebaseFirestore firestore = await FirebaseFirestore.instance;
      DocumentSnapshot response =
          await firestore.collection('users').doc(userId.toString()).get();
      print('getImageFromCloud');
      var data = response.data();
      print('image response');
      print(data);
      var url = '';
      if (data != null) {
        url = response.get('imageUrl');
      }

      return url;
    } catch (e) {
      print(e);
    }
  }
}
