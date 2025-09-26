import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/is_brigadier_provider.dart';

class AppBarUser extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarUser({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final colors = Theme.of(context).colorScheme;

    final isBrigadierAsync = ref.watch(isBrigadierProvider);

    return AppBar(
      centerTitle: true,
      backgroundColor: colors.primary,
      title: Text(
        'Reportes Unimayor',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: colors.onPrimary,
        ),
      ),
      actions: [
        isBrigadierAsync.when(
          data: (isBrigadier) {
            if (isBrigadier) {
              return IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: colors.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.person),
                onPressed: () => router.pushReplacement('/brigadier'),
              );
            }
            return const SizedBox.shrink();
          },
          loading: () => const SizedBox.shrink(),
          error: (err, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
