import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/is_brigadier_provider.dart';
import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:reportes_unimayor/services/api_token_device_service.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';
import 'package:reportes_unimayor/utils/show_message.dart';

class AuthLoginHowGuest extends ConsumerStatefulWidget {
  const AuthLoginHowGuest({super.key});

  @override
  ConsumerState<AuthLoginHowGuest> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthLoginHowGuest> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoadingCheckIfLoggedIn = true;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    setState(() => _isLoadingCheckIfLoggedIn = true);

    final token = await readStorage('token');

    if (token != null && mounted) {
      ref.read(tokenProvider.notifier).setToken(token);
      final userType = await ref.read(isBrigadierProvider.future);

      if (userType) {
        context.go('/brigadier');
      } else {
        context.go('/user');
      }
    } else {
      if (mounted) {
        setState(() => _isLoadingCheckIfLoggedIn = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: _isLoadingCheckIfLoggedIn
          ? circularProgress(colorScheme)
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/icons/logo_unimayor.png',
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Bienvenido',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicia sesión para continuar',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: decorationTextForm(
                                'Email',
                                Icons.email_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce un email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: decorationTextForm(
                                'Contraseña',
                                Icons.lock_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce una contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            buttonLogin(colorScheme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Center circularProgress(ColorScheme colorScheme) {
    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
        strokeWidth: 3,
      ),
    );
  }

  ElevatedButton buttonLogin(ColorScheme colorScheme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      onPressed: _isLoading ? null : _login,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Iniciar sesión', style: GoogleFonts.poppins(fontSize: 16)),
          if (_isLoading) const SizedBox(width: 20),
          if (_isLoading)
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: colorScheme.onPrimary,
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration decorationTextForm(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final String? token = await ApiAuthService().login(email, password);

      if (token == null) {
        if (!mounted) return;
        showMessage(
          context,
          'Credenciales incorrectas',
          Theme.of(context).colorScheme.error,
        );
        return;
      }

      await writeStorage('token', token);

      String? deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken != null) {
        await ApiTokenDeviceService().setTokenDevice(deviceToken);
      }

      ref.read(tokenProvider.notifier).setToken(token);
      final userType = await ref.read(isBrigadierProvider.future);

      if (!mounted) return;

      if (userType) {
        context.go('/brigadier');
      } else {
        context.go('/user');
      }
    } catch (e) {
      if (!mounted) return;
      showMessage(
        context,
        'Error de conexión. Intenta nuevamente.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
