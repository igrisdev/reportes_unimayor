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
    final isBrigadier = ref.watch(isBrigadierProvider);

    return AppBar(
      centerTitle: true,
      title: Text(
        'Reportes UniMayor',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      actions: [
        if (isBrigadier)
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(Icons.person),
            onPressed: () {
              router.go('/brigadier');
            },
          ),
      ],
    );
  }
}
