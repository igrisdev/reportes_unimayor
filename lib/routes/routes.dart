import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/providers/auth_notifier_provider.dart';
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
import 'package:reportes_unimayor/screens/users/settings/emergency_contacts/emergency_contacts_user_screen.dart';
import 'package:reportes_unimayor/screens/users/settings/emergency_contacts/form_emergency_contacts_user_screen.dart';
import 'package:reportes_unimayor/screens/users/settings/general_information/form_general_information_user_screen.dart';
import 'package:reportes_unimayor/screens/users/settings/general_information/general_information_user_screen.dart';
import 'package:reportes_unimayor/screens/users/settings/medical_information/form_medical_information_user_screen.dart';
import 'package:reportes_unimayor/screens/users/settings/medical_information/medical_information_user_screen.dart';
import 'package:reportes_unimayor/screens/users/view_report_user_screen.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';
import 'package:reportes_unimayor/widgets/users/qr_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
            path: 'settings/general_information',
            builder: (context, state) => const GeneralInformationUserScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    const FormGeneralInformationUserScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'settings/medical_information',
            builder: (context, state) => const MedicalInformationUserScreen(),
            routes: [
              GoRoute(
                path: 'create_and_edit',
                builder: (context, state) =>
                    const FormMedicalInformationUserScreen(),
              ),
              GoRoute(
                path: 'create_and_edit/:conditionId',
                builder: (context, state) => FormMedicalInformationUserScreen(
                  conditionId: state.pathParameters['conditionId'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'settings/emergency_contacts',
            builder: (context, state) => const EmergencyContactsUserScreen(),
            routes: [
              GoRoute(
                path: 'create_and_edit',
                builder: (context, state) =>
                    const FormEmergencyContactsUserScreen(),
              ),
              GoRoute(
                path: 'create_and_edit/:contactId',
                builder: (context, state) => FormEmergencyContactsUserScreen(
                  contactId: state.pathParameters['contactId'],
                ),
              ),
            ],
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
            builder: (context, state) => ViewReportProcessBrigadierScreen(
              id: state.pathParameters['id']!,
            ),
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
    redirect: (context, state) {
      final currentStatus = authState.status;
      final isBrigadier = authState.isBrigadier;
      final location = state.matchedLocation;

      if (currentStatus == AuthStatus.checking) {
        return '/splash';
      }

      if (currentStatus == AuthStatus.unauthenticated) {
        if (location.startsWith('/auth')) {
          return null;
        } else {
          return '/auth';
        }
      }

      if (currentStatus == AuthStatus.authenticated) {
        if (location.startsWith('/auth') || location == '/splash') {
          if (isBrigadier == null) {
            return '/auth';
          }
          return isBrigadier ? '/brigadier' : '/user';
        }
      }

      return null;
    },
  );
});
