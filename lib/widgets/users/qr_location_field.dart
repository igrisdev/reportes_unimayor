import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/location_providers.dart';

class QrLocationField extends ConsumerWidget {
  final String idLocationQrScanner;
  final bool isManualMode;
  final String? formSelectedHeadquarter;
  final String? formSelectedBuilding;
  final String? formSelectedLocation;
  final String? formUbicacionTextOpcional;
  final ValueChanged<String> onQrScanned;

  const QrLocationField({
    super.key,
    required this.idLocationQrScanner,
    required this.isManualMode,
    this.formSelectedHeadquarter,
    this.formSelectedBuilding,
    this.formSelectedLocation,
    this.formUbicacionTextOpcional,
    required this.onQrScanned,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final AsyncValue<Map<String, dynamic>>? locationByIdAsync =
        (idLocationQrScanner.isNotEmpty)
        ? ref.watch(
            locationByIdProvider(int.tryParse(idLocationQrScanner) ?? -1),
          )
        : null;

    return FormField<String>(
      initialValue: idLocationQrScanner,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final hasQr = idLocationQrScanner.isNotEmpty;

        final hasManualLocationComplete =
            isManualMode &&
            formSelectedHeadquarter != null &&
            formSelectedBuilding != null &&
            formSelectedLocation != null;

        final hasOptionalText =
            formUbicacionTextOpcional != null &&
            formUbicacionTextOpcional!.trim().isNotEmpty;

        final hasValidLocation =
            hasQr || hasManualLocationComplete || hasOptionalText;

        if (hasValidLocation) {
          return null;
        }

        return 'Selecciona ubicación por QR, completa la selección manual, o escribe en Ubicación Opcional.';
      },
      builder: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.value != idLocationQrScanner) {
            state.didChange(idLocationQrScanner);
          }
        });

        final bool isScanned = (idLocationQrScanner.isNotEmpty);

        String titleText;
        if (!isScanned) {
          titleText = 'QR Más Cercano';
        } else {
          final idInt = int.tryParse(idLocationQrScanner);
          if (idInt == null || locationByIdAsync == null) {
            titleText = 'Ubicación Escaneada';
          } else {
            titleText = locationByIdAsync.when(
              data: (map) {
                final sede = (map['sede'] as String?) ?? '';
                final lugar = (map['lugar'] as String?) ?? '';
                if (sede.isNotEmpty && lugar.isNotEmpty) {
                  return '$sede, $lugar';
                } else if (sede.isNotEmpty) {
                  return sede;
                } else if (lugar.isNotEmpty) {
                  return lugar;
                } else {
                  return 'Ubicación Escaneada';
                }
              },
              loading: () => 'Cargando ubicación...',
              error: (err, st) => 'Ubicación (error al cargar)',
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final String? result = await context.push<String>(
                  '/user/create-report/qr-scanner',
                );

                if (result != null && result.isNotEmpty) {
                  onQrScanned(result);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isScanned
                      ? colors.tertiary.withValues(alpha: 0.1)
                      : colors.primary,
                  border: Border.all(
                    color: isScanned ? colors.tertiary : colors.onSurface,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleText,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: isScanned
                                  ? colors.tertiary
                                  : colors.onTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Presionar para escanear la ubicación',
                            style: GoogleFonts.poppins(
                              color: colors.onTertiary.withValues(alpha: 0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isScanned ? Icons.check_circle : Icons.qr_code_scanner,
                      size: 80,
                      color: isScanned ? colors.tertiary : colors.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  state.errorText!,
                  style: GoogleFonts.poppins(
                    color: colors.error,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
