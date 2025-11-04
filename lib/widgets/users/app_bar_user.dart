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
    final colors = Theme.of(context).colorScheme;

    final isBrigadierAsync = ref.watch(isBrigadierProvider);

    return AppBar(
      centerTitle: true,
      backgroundColor: colors.secondary,
      title: Text(
        'REPORTADOR',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: colors.onSecondary,
        ),
      ),
      actions: [
        isBrigadierAsync.when(
          data: (isBrigadier) {
            if (isBrigadier) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: () => context.go('/brigadier'),
                  icon: const Icon(Icons.person, size: 20),
                  label: Text(
                    'Cambiar',
                    style: GoogleFonts.poppins(fontSize: 11, color: colors.onPrimary, fontWeight: FontWeight.w700),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onPrimary,
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
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
