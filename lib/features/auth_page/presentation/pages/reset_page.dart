import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes_config.dart';
import '../cubit/auth_page_cubit.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // void errorMessage(String text) {
  //   SnackBar snackBar = SnackBar(
  //     content: Text(text),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   GetIt.I<AuthPageCubit>().stream.listen((state) {
  //     state.maybeWhen(
  //         error: (e) {
  //           errorMessage(e);
  //         },
  //         orElse: () {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<AuthPageCubit>(),
      child: BlocListener<AuthPageCubit, AuthPageState>(
        listener: (context, state) {
          state.maybeWhen(
              error: (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              },
              success: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Email reset password telah dikirim')),
                );
                context.go(RoutesConfig.login);
              },
              orElse: () {});
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Reset Password'),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Masukkan email yang terdaftar',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AuthPageCubit, AuthPageState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () {
                              GetIt.I<AuthPageCubit>().resetPassword(
                                email: emailController.text,
                              );

                              context.go(RoutesConfig.reset);
                            },
                            child: Text(
                              state.maybeWhen(
                                  loading: () => 'Loading',
                                  orElse: () => 'Reset'),
                            ));
                      },
                    ),
                  ],
                ))),
      ),
    );
  }
}
