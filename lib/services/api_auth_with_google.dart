import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reportes_unimayor/providers/auth_notifier_provider.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

final apiAuthWithGoogleProvider = Provider((ref) => ApiAuthWithGoogle(ref));

class ApiAuthWithGoogle extends BaseDioService {
  final Ref _ref;
  ApiAuthWithGoogle(this._ref) : super(_ref);

  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();

      if (googleSignInAccount == null) {
        return null;
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

        _ref.read(authNotifierProvider.notifier).login();

        return response.data['token'];
      } else {
        return null;
      }
    } on FirebaseAuthException {
      return null;
    }
  }

  googleSingOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}
