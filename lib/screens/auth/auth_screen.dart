import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/is_brigadier_provider.dart';
import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_auth_with_google.dart';
import 'package:reportes_unimayor/services/api_token_device_service.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';
import 'package:reportes_unimayor/utils/show_message.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLoading = false;

  Future<void> login() async {
    setState(() => _isLoading = true);

    try {
      final String? token = await ApiAuthWithGoogle().signInWithGoogle();

      if (token == null) {
        if (!mounted) return;
        showMessage(context, 'Credenciales incorrectas', Colors.red.shade700);
        return;
      }

      await writeTokenStorage('token', token);

      String? deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken != null) {
        await ApiTokenDeviceService().setTokenDevice(deviceToken, token);
      }

      ref.read(tokenProvider.notifier).setToken(token);

      final userType = ref.read(isBrigadierProvider);

      if (!mounted) return;

      if (userType) {
        context.go('/brigadier');
      } else {
        context.go('/user');
      }
    } catch (e) {
      showMessage(
        context,
        'Error de conexión. Intenta nuevamente.',
        Colors.red.shade700,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/icons/logo_unimayor.png', height: 100),
                const SizedBox(height: 20),
                Text(
                  'Bienvenido',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para continuar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 40),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          minimumSize: WidgetStateProperty.all(
                            const Size(200, 60),
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        onPressed: login,
                        child: Text(
                          'Correo Unimayor',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                const SizedBox(height: 20),

                // Botón de invitado
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.grey),
                    minimumSize: WidgetStateProperty.all(const Size(200, 60)),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.go('/auth/login-how-guest');
                  },
                  child: Text(
                    'Como Invitado',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
