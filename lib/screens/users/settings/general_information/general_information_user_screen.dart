import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:reportes_unimayor/providers/settings_provider.dart';

class GeneralInformationUserScreen extends ConsumerWidget {
  const GeneralInformationUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final datosAsync = ref.watch(personalDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Información General',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/user/settings/general_information/edit');
        },
        label: Text('Editar', style: GoogleFonts.poppins(fontSize: 20, color: colors.onPrimary, fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.edit_note, color: Colors.white, size: 30,),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: datosAsync.when(
        data: (datos) {
          final numeroTelefonico = datos['numeroTelefonico'] as String?;
          final cedula = datos['cedula'] as String?;
          final codigoInstitucional = datos['codigoInstitucional'] as String?;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(
                  title: 'Datos de contacto',
                  color: colors.primary,
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _InfoBlock(
                      icon: Icons.phone_android,
                      title: 'Número telefónico',
                      value: numeroTelefonico,
                      colors: colors,
                    ),
                  ),
                ),

                _sectionHeader(title: 'Identificación', color: colors.primary),
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _InfoBlock(
                      icon: Icons.badge,
                      title: 'Cédula',
                      value: cedula,
                      colors: colors,
                    ),
                  ),
                ),

                _sectionHeader(title: 'Institucional', color: colors.primary),
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _InfoBlock(
                      icon: Icons.account_balance,
                      title: 'Código institucional',
                      value: codigoInstitucional,
                      colors: colors,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Para editar cualquiera de estos campos, presiona el botón “Editar” en la esquina inferior derecha.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error al cargar los datos: ${err.toString()}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader({required String title, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final ColorScheme colors;

  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (value != null && value!.isNotEmpty)
          Text(
            value!,
            style: GoogleFonts.poppins(fontSize: 16, color: colors.onSurface),
          )
        else
          Text(
            'No tiene registrado este campo.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: colors.onSurface,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
