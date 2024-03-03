import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket/core/router/routes_config.dart';
import 'package:intl/intl.dart';

import '../cubit/user_page_cubit.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool obsText = true;
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    obsText = true;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<UserPageCubit>(),
      child: BlocListener<UserPageCubit, UserPageState>(
        listener: (context, state) {
          state.maybeWhen(
              success: (user, passUpdate) {
                if (passUpdate == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hi, $user is Already updated')));
                } else {
                  context.go(RoutesConfig.login);
                }
              },
              imagePicked: (image) {
                if (image != null) {
                  setState(() {
                    selectedImage = image;
                  });
                }
              },
              error: (message) => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message))),
              orElse: () {});
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('User Profile'),
            centerTitle: true,
          ),
          body: FutureBuilder<Map<String, dynamic>?>(
            future: GetIt.I<UserPageCubit>().getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null) {
                return const Center(child: Text('Tidak ada data user'));
              } else {
                emailController.text = snapshot.data!['email'];
                nameController.text = snapshot.data!['name'];
                phoneController.text = snapshot.data!['phone'];
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GestureDetector(
                          onTap: () {
                            GetIt.I<UserPageCubit>().pickImage();
                          },
                          child: snapshot.data!['profile'] != null
                              ? selectedImage != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          FileImage(File(selectedImage!.path)))
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(snapshot
                                              .data!['profile'] ??
                                          'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                                    )
                              : selectedImage != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          FileImage(File(selectedImage!.path)))
                                  : const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'User Name',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: nameController,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      readOnly: true,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StatefulBuilder(builder: (context, setStateBx) {
                      return TextField(
                        controller: passwordController,
                        autocorrect: false,
                        obscureText: obsText,
                        decoration: InputDecoration(
                            labelText: 'New Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setStateBx(() {
                                    obsText = !obsText;
                                  });
                                },
                                icon: Icon(obsText == true
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined))),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Created At: '),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat.yMMMMd()
                        .add_jms()
                        .format(DateTime.parse(snapshot.data!['createdAt']))),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<UserPageCubit, UserPageState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (nameController.text != snapshot.data!['name'] ||
                                phoneController.text !=
                                    snapshot.data!['phone'] ||
                                passwordController.text.isNotEmpty ||
                                selectedImage != null) {
                              GetIt.I<UserPageCubit>().updateUserData(
                                  nameController.text,
                                  phoneController.text,
                                  passwordController.text,
                                  selectedImage);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('No data changed')),
                              );
                            }
                          },
                          child: Text(state.maybeWhen(
                              loading: () => 'UPDATING...',
                              orElse: () => 'UPDATE PROFILE')),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go(RoutesConfig.home);
                      },
                      child: const Text('Back to Home Page'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
