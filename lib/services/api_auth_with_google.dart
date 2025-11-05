import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reportes_unimayor/providers/auth_notifier_provider.dart';
import 'package:reportes_unimayor/services/api_token_device_service.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

enum GoogleSignInResult {
  success,
  cancelled,
  wrongDomain,
  networkError,
  apiError,
}

final apiAuthWithGoogleProvider = Provider((ref) => ApiAuthWithGoogle(ref));

class ApiAuthWithGoogle extends BaseDioService {
  final Ref _ref;
  ApiAuthWithGoogle(this._ref) : super(_ref);

  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();

      if (googleSignInAccount == null) {
        return GoogleSignInResult.cancelled;
      }

      if (!googleSignInAccount.email.endsWith('@unimayor.edu.co')) {
        await googleSignIn.signOut();
        return GoogleSignInResult.wrongDomain;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final response = await dio.post(
        '/auth/institucional/login-google',
        data: {'idToken': googleSignInAuthentication.idToken},
      );

      await auth.signInWithCredential(authCredential);
      final bool isLogged = FirebaseAuth.instance.currentUser != null;

      if (response.statusCode == 200 && isLogged) {
        await writeStorage('token', response.data['token']);
        await writeStorage('refresh_token', response.data['refreshToken']);

        await _ref.read(authNotifierProvider.notifier).login();

        await _ref.read(apiTokenDeviceServiceProvider).setTokenDevice();
        return GoogleSignInResult.success;
      } else {
        await googleSignIn.signOut();
        return GoogleSignInResult.apiError;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return GoogleSignInResult.networkError;
      }
      await googleSignIn.signOut();
      return GoogleSignInResult.apiError;
    } catch (e) {
      await googleSignIn.signOut();
      return GoogleSignInResult.apiError;
    }
  }

  Future<void> googleSingOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}
