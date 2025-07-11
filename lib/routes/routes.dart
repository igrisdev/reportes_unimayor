import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/screens/auth/auth_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/history_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/main_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/view_report_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/users/create_report_user_screen.dart';
import 'package:reportes_unimayor/screens/users/history_user_screen.dart';
import 'package:reportes_unimayor/screens/users/main_user_screen.dart';
import 'package:reportes_unimayor/screens/users/view_report_user_screen.dart';
import 'package:reportes_unimayor/widgets/qr_scanner.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => AuthScreen()),
    GoRoute(
      path: '/user',
      builder: (context, state) => MainUserScreen(),
      routes: [
        GoRoute(
          path: '/report/:id',
          builder: (context, state) =>
              ViewReportUserScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => HistoryUserScreen(),
        ),
        GoRoute(
          path: '/create-report',
          builder: (context, state) => CreateReportUserScreen(),
          routes: [
            GoRoute(
              path: '/qr-scanner',
              builder: (context, state) => QrScanner(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/brigadier',
      builder: (context, state) => MainBrigadierScreen(),
      routes: [
        GoRoute(
          path: '/report/:id',
          builder: (context, state) =>
              ViewReportBrigadierScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => HistoryBrigadierScreen(),
        ),
      ],
    ),
  ],
);
