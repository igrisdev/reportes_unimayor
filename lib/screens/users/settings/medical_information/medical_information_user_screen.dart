import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/settings_provider.dart';

class MedicalInformationUserScreen extends ConsumerWidget {
  const MedicalInformationUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final listAsync = ref.watch(medicalConditionsListProvider);

    ref.listen<AsyncValue<void>>(deleteMedicalConditionProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Condición médica eliminada correctamente'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${err.toString()}'),
              backgroundColor: colors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Condiciones Médicas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      body: listAsync.when(
        data: (conditions) {
          if (conditions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 80,
                    color: colors.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No tienes condiciones médicas registradas.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '¡Agrega la primera!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: conditions.length,
            itemBuilder: (context, index) {
              final cond = conditions[index];
              return _ConditionListItem(condition: cond, colors: colors);
            },
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: colors.primary)),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error al cargar condiciones: ${err.toString()}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: colors.error),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.go('/user/settings/medical_information/create_and_edit'),
        label: Text(
          'Nueva Condición',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.onPrimary,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: colors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

class _ConditionListItem extends ConsumerWidget {
  final MedicalCondition condition;
  final ColorScheme colors;

  const _ConditionListItem({
    super.key,
    required this.condition,
    required this.colors,
  });

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final deleteState = ref.watch(deleteMedicalConditionProvider);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: colors.error),
              const SizedBox(width: 10),
              Text(
                'Confirmar Eliminación',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            '¿Eliminar condición "${condition.nombre}"?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: colors.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: deleteState.isLoading
                  ? null
                  : () async {
                      await ref
                          .read(deleteMedicalConditionProvider.notifier)
                          .deleteCondition(condition.id);
                    },
              child: deleteState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Eliminar',
                      style: GoogleFonts.poppins(color: colors.onError),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        condition.nombre,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Diagnóstico: ${condition.fechaDiagnostico.toLocal().toString().split(' ').first}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_note, color: colors.secondary),
                      onPressed: () {
                        context.go(
                          '/user/settings/medical_information/create_and_edit/${condition.id}',
                        );
                      },
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: colors.error),
                      onPressed: () => _confirmDelete(context, ref),
                      tooltip: 'Eliminar',
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16),
            Text(
              condition.descripcion,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: colors.onSurface.withOpacity(0.9),
              ),
            ),
            if (condition.mensaje != null && condition.mensaje!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                condition.mensaje!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: colors.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
