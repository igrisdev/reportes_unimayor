import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/services/api_auth_with_google.dart';
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
      final String? tokenGoogle = await ref
          .read(apiAuthWithGoogleProvider)
          .signInWithGoogle();

      if (tokenGoogle == null && mounted) {
        showMessage(
          context,
          'Credenciales incorrectas',
          Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      showMessage(
        context,
        'Solo puedes acceder a la aplicación con una cuenta de correo unimayor',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Scaffold(
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
                        color: colorScheme.onSurface, // 👈 título
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inicia sesión para continuar',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color:
                            textTheme.bodyMedium?.color ??
                            colorScheme.onSurfaceVariant, // 👈 subtítulo
                      ),
                    ),
                    const SizedBox(height: 40),

                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          colorScheme.primary,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          colorScheme.onPrimary,
                        ),
                        minimumSize: WidgetStateProperty.all(
                          const Size(200, 60),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      onPressed: login,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/logo_google.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Correo Unimayor',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón Invitado
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          colorScheme.secondary,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          colorScheme.onSecondary,
                        ),
                        minimumSize: WidgetStateProperty.all(
                          const Size(200, 60),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      onPressed: () {
                        context.go('/auth/login-how-guest');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Como Invitado',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (_isLoading)
          Container(
            color: colorScheme.surface.withValues(alpha: 0.5),
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: colorScheme.onSurface),
          ),
      ],
    );
  }
}
