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

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
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
    setState(() {
      _isLoadingCheckIfLoggedIn = true;
    });

    final token = await readTokenStorage('token');

    if (token != null && mounted) {
      ref.read(tokenProvider.notifier).setToken(token);

      final userType = ref.read(isBrigadierProvider);

      if (userType) {
        context.go('/brigadier');
      } else {
        context.go('/user');
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingCheckIfLoggedIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingCheckIfLoggedIn
          ? circularProgress()
          : SafeArea(
              child: Center(
                child: Padding(
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
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: decorationTextForm('Email'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce un email';
                                }
                                // if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                //   return 'Por favor, introduce un email válido';
                                // }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: decorationTextForm('Contraseña'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce una contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            buttonLogin(),
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

  Center circularProgress() {
    return Center(
      child: CircularProgressIndicator(
        color: const Color.fromARGB(255, 0, 0, 0),
        strokeWidth: 3,
      ),
    );
  }

  ElevatedButton buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF003366), // Azul oscuro
        foregroundColor: Colors.white,
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
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration decorationTextForm(String label) {
    return InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.email_outlined),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final router = GoRouter.of(context);
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final String? token = await ApiAuthService().login(email, password);

      if (token == null) {
        _showError('Credenciales incorrectas');
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
        router.go('/brigadier');
      } else {
        router.go('/user');
      }
    } catch (e) {
      _showError('Error de conexión. Intenta nuevamente.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
