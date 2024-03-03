import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/router/routes_config.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          //Cek Status authentikasi pengguna
          // String initialRoutes = snapshot.hasData
          //     ? snapshot.data!.emailVerified
          //         ? RoutesConfig.home
          //         : RoutesConfig.login
          //     : RoutesConfig.register;

          // String initialRoutes =
          //     snapshot.hasData && snapshot.data!.emailVerified
          //         ? RoutesConfig.home
          //         : RoutesConfig.login;

          // final appRouter = RoutesConfig.createAppRouter(
          //     initialLocationRoute: RoutesConfig.login);

          return MaterialApp.router(
            routerConfig: RoutesConfig.appRouter,
            // routerConfig: RoutesConfig.createAppRouter(
            //     initialLocationRoute: initialRoutes),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
          );
        });
  }
}
