// import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes_config.dart';
import '../cubit/auth_page_cubit.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = false;
  bool _isRemembered = false;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    _obscureText = false;
    _loadRememberMe();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _loadRememberMe() {
    var rememberMeData = box.read('rememberme');
    if (rememberMeData != null) {
      emailController.text = rememberMeData['email'];
      passwordController.text = rememberMeData['password'];
      _isRemembered = true;
    } else {
      _isRemembered = false;
      emailController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<AuthPageCubit>(),
      child: BlocListener<AuthPageCubit, AuthPageState>(
        listener: (context, state) {
          state.maybeWhen(
              error: (e) {
                if (e == 'Email belum terverifikasi') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                            'Email belum terverifikasi, kirim ulang email verifikasi?'),
                        content: ElevatedButton(
                          onPressed: () {
                            GetIt.I<AuthPageCubit>()
                                .sendVerificationEmail(context);

                            context.go(RoutesConfig.login);
                          },
                          child: const Text('OK'),
                        ),
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              success: () => context.go(RoutesConfig.home),
              orElse: () {});
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login page'),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isRemembered,
                                onChanged: (value) {
                                  setState(() {
                                    _isRemembered = value!;
                                  });
                                },
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              context.go(RoutesConfig.reset);
                            },
                            child: const Text('Forgot password?'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<AuthPageCubit, AuthPageState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              GetIt.I<AuthPageCubit>().login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  isRemember: _isRemembered);

                              if (_isRemembered) {
                                box.write('rememberme', {
                                  'email': emailController.text,
                                  'password': passwordController.text
                                });
                              } else {
                                box.remove('rememberme');
                              }
                            },
                            child: Text(state.maybeWhen(
                                loading: () => '..Loading',
                                orElse: () => 'Login')),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          child: const Text('Register'),
                          onPressed: () {
                            context.go(RoutesConfig.register);
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
