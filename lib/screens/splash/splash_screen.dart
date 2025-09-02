import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/providers/is_brigadier_provider.dart';
import 'package:reportes_unimayor/providers/token_provider.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await readTokenStorage('token');

    if (!mounted) return;

    if (token != null) {
      ref.read(tokenProvider.notifier).setToken(token);

      final isBrigadier = ref.read(isBrigadierProvider);

      if (isBrigadier) {
        context.go('/brigadier');
      } else {
        context.go('/user');
      }
    } else {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      ),
    );
  }
}
