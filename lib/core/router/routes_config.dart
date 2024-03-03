import 'package:go_router/go_router.dart';

import '../../features/auth_page/presentation/pages/auth_page.dart';
import '../../features/auth_page/presentation/pages/register_page.dart';
import '../../features/auth_page/presentation/pages/reset_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/user_detail_page/presentation/pages/user_profile.dart';

class RoutesConfig {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String reset = '/reset';
  static const String userProfile = '/user-profile';

  static GoRouter appRouter =
      GoRouter(initialLocation: login, routes: <GoRoute>[
    GoRoute(
      path: home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: login,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: reset,
      builder: (context, state) => const ResetPage(),
    ),
    GoRoute(
      path: userProfile,
      builder: (context, state) => const UserProfilePage(),
    ),
  ]);

  // static GoRouter createAppRouter({required String initialLocationRoute}) {
  //   return GoRouter(
  //     initialLocation: initialLocationRoute,
  //     routes: [
  //       GoRoute(
  //         path: home,
  //         builder: (context, state) => const HomePage(),
  //       ),
  //       GoRoute(
  //         path: login,
  //         builder: (context, state) => const AuthPage(),
  //       ),
  //       GoRoute(
  //         path: register,
  //         builder: (context, state) => const RegisterPage(),
  //       ),
  //     ],
  //   );
  // }
}
