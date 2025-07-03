import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/services/api_auth_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('assets/icons/logo_unimayor.png', width: 100),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduzca un email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Contraseña',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduzca una contraseña';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            final router = GoRouter.of(context);

                            setState(() => _isLoading = true);

                            try {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;

                              final String? token = await ApiAuthService()
                                  .login(email, password);

                              if (token == null) {
                                _showError('Credenciales incorrectas');
                                return;
                              }

                              ref.read(tokenProvider.notifier).setToken(token);

                              final userType = await ApiAuthService().userType(
                                token,
                              );

                              if (userType) {
                                router.go('/brigadier');
                              } else {
                                router.go('/user');
                              }
                            } catch (e) {
                              _showError('Error, Intenta nuevamente.');
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                    child: Text('Iniciar sesión'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
