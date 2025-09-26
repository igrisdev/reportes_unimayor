import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/screens/auth/auth_login_how_guest.dart';
import 'package:reportes_unimayor/screens/auth/auth_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/history_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/main_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/search_person_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/view_report_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/brigadier/view_report_process_brigadier_screen.dart';
import 'package:reportes_unimayor/screens/splash/splash_screen.dart';
import 'package:reportes_unimayor/screens/users/create_report_user_screen.dart';
import 'package:reportes_unimayor/screens/users/history_user_screen.dart';
import 'package:reportes_unimayor/screens/users/main_user_screen.dart';
import 'package:reportes_unimayor/screens/users/view_report_user_screen.dart';
import 'package:reportes_unimayor/widgets/users/qr_scanner.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
      routes: [
        GoRoute(
          path: 'login-how-guest',
          builder: (context, state) => const AuthLoginHowGuest(),
        ),
      ],
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => const MainUserScreen(),
      routes: [
        GoRoute(
          path: 'report/:id',
          builder: (context, state) =>
              ViewReportUserScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => const HistoryUserScreen(),
        ),
        GoRoute(
          path: 'create-report',
          builder: (context, state) => const CreateReportUserScreen(),
          routes: [
            GoRoute(
              path: 'qr-scanner',
              builder: (context, state) => const QrScanner(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/brigadier',
      builder: (context, state) => const MainBrigadierScreen(),
      routes: [
        GoRoute(
          path: 'report-process/:id',
          builder: (context, state) =>
              ViewReportProcessBrigadierScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: 'report/:id',
          builder: (context, state) =>
              ViewReportBrigadierScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => const HistoryBrigadierScreen(),
        ),
        GoRoute(
          path: 'search-person',
          builder: (context, state) => const SearchPerson(),
        ),
      ],
    ),
  ],
);
