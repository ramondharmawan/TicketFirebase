import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'user_page_state.dart';
part 'user_page_cubit.freezed.dart';

@singleton
class UserPageCubit extends Cubit<UserPageState> {
  UserPageCubit() : super(const UserPageState.initial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  XFile? imagex;

  Future<void> logout() async {
    emit(const UserPageState.loading());
    try {
      // final user = _auth.currentUser;
      await _auth.signOut();
      // emit(UserPageState.success(user!));
    } catch (e) {
      emit(UserPageState.error(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userUid = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>?> userData =
          await _firestore.collection('users').doc(userUid).get();

      return userData.data();
      // final userDetail = User.fromJson(userData.data()!);
      // emit(UserPageState.success(userDetail));
    } catch (e) {
      emit(UserPageState.error(e.toString()));
    }
    return null;
  }

  Future<void> updateUserData(
      String name, String phone, String? password, XFile? imageProfile) async {
    emit(const UserPageState.loading());
    try {
      final userUid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(userUid).update({
        'name': name,
        'phone': phone,
      });

      if (password!.isNotEmpty) {
        await _auth.currentUser!.updatePassword(password);
        await _auth.signOut();
      }

      // await storage.ref(userUid).putFile(
      //     imagex != null ? File(imagex!.path) : File('assets/images/user.png'));

      if (imageProfile != null) {
        String ext = imageProfile.name.split('.').last;

        await storage
            .ref(userUid)
            .child('profile.$ext')
            .putFile(File(imageProfile.path));

        String url =
            await storage.ref(userUid).child('profile.$ext').getDownloadURL();

        await _firestore.collection('users').doc(userUid).update({
          'profile': url,
        });
      } // final path = imagex != null ? imagex!.path : 'assets/images/user.png';

      emit(UserPageState.success(name, password.isNotEmpty ? true : false));
    } catch (e) {
      emit(UserPageState.error(e.toString()));
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() async* {
    final userUid = _auth.currentUser!.uid;
    // _firestore.collection('users').doc(userUid).snapshots().listen((event) {
    //   emit(UserPageState.success(event.data()!['name'], false));
    // });
    yield* _firestore.collection('users').doc(userUid).snapshots();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagex = image;
      emit(UserPageState.imagePicked(imagex)); // Emit new state with image
    }
  }

  Future<void> deleteProfile() async {
    try {
      final userUid = _auth.currentUser!.uid;
      await storage.ref(userUid).delete();
      await _firestore.collection('users').doc(userUid).update({
        // 'profile': null,  // in case of using null
        'profile': FieldValue.delete(), // in case to delete the field
      });
      emit(const UserPageState.imagePicked(null));
    } catch (e) {
      emit(UserPageState.error(e.toString()));
    }
  }
}
