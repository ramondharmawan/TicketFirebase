import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ticket/core/router/routes_config.dart';

part 'auth_page_cubit.freezed.dart';
part 'auth_page_state.dart';

@singleton
class AuthPageCubit extends Cubit<AuthPageState> {
  AuthPageCubit() : super(const AuthPageState.initial());

  final box = GetStorage();

  Future<void> login(
      {required String email,
      required String password,
      required bool isRemember}) async {
    emit(const AuthPageState.loading());
    await Future.delayed(const Duration(seconds: 2));

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user!.emailVerified == true) {
        if (box.read('rememberme') != null) {
          await box.remove('rememberme');
          print('remove rememberme');
        }
        if (isRemember == true) {
          await box.write('rememberme', {'email': email, 'password': password});
          print('write rememberme');
          emit(const AuthPageState.success());
        } else {
          await box.remove('rememberme');
          print('remove rememberme');
          emit(const AuthPageState.success());
        }
        print('success is running');
      } else {
        await box.remove('rememberme');
        emit(const AuthPageState.error('Email belum terverifikasi'));
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      emit(AuthPageState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(const AuthPageState.initial());
    } catch (e) {
      emit(AuthPageState.error(e.toString()));
    }
    // await FirebaseAuth.instance.signOut();
    // emit(const AuthPageState.initial());
    // RoutesConfig.login;
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name,
      String? phone}) async {
    emit(const AuthPageState.loading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('this is Register $credential');
      credential.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'email': email,
        // 'name': email.split('@').first,
        'name': name,
        'phone': phone,
        'role': 'user',
        // 'createdAt': FieldValue.serverTimestamp(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      emit(const AuthPageState.success());
    } on FirebaseAuthException catch (e) {
      emit(AuthPageState.error(e.toString()));
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      emit(AuthPageState.error(e.toString()));
    }
  }

  Future<void> sendVerificationEmail(context) async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      const snackBar = SnackBar(
        content: Text('Email verifikasi telah dikirim'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      RoutesConfig.login;
    } catch (e) {
      emit(AuthPageState.error(e.toString()));
    }
  }

  Future<void> resetPassword({required String email}) async {
    void errorMessage(String e) {
      emit(AuthPageState.error(e));
    }

    emit(const AuthPageState.loading());
    if (email.isNotEmpty) {
      try {
        print('send reset email');

        // final checkEmail = await FirebaseAuth.instance
        //     .fetchSignInMethodsForEmail(email)
        //     .then((value) {
        //   if (value.isEmpty) {
        //     errorMessage('Email tidak terdaftar');
        //   }
        // });

        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        emit(const AuthPageState.success());
      } on FirebaseAuthException catch (e) {
        print('send reset email failed');

        if (e.code == 'user-not-found') {
          errorMessage('Email tidak terdaftar');
        }
      } catch (e) {
        print('tidak dapat reset');
        errorMessage('tidak dapat reset email, coba lagi nanti');
      }
    } else {
      print('email kosong');
      errorMessage('Email tidak boleh kosong');
    }
  }
}
