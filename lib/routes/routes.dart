import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/screens/auth/auth_screen.dart';
import 'package:reportes_unimayor/screens/users/main_user_screen.dart';
import 'package:reportes_unimayor/screens/users/view_report_user_screen.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => AuthScreen()),
    GoRoute(path: '/user', builder: (context, state) => MainUserScreen()),
    GoRoute(
      path: '/report',
      builder: (context, state) => ViewReportUserScreen(),
    ),
  ],
);
