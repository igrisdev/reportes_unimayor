import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'package:reportes_unimayor/models/location_tree.dart';
import 'package:reportes_unimayor/providers/audio_player_notifier.dart';
import 'package:reportes_unimayor/providers/location_providers.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/general/confirm_dialog.dart';
import 'package:reportes_unimayor/widgets/general/show_message_snack_bar_.dart';
import 'package:reportes_unimayor/widgets/users/audio_player_widget.dart';
import 'package:reportes_unimayor/widgets/users/audio_recorder_widget.dart';

class CreateReportUserScreen extends ConsumerStatefulWidget {
  const CreateReportUserScreen({super.key});

  @override
  ConsumerState createState() => _CreateReportUserScreenState();
}

class _CreateReportUserScreenState
    extends ConsumerState<CreateReportUserScreen> {
  final _formKey = GlobalKey<FormState>();

  String? formSelectedHeadquarter;
  String? formSelectedBuilding;
  String? formSelectedLocation;
  String? formDescription;
  String? formUbicacionTextOpcional;
  bool? formParaMi;

  String _idLocationQrScanner = '';

  String? _recordingPath;
  bool _isRecordingMode = false;

  bool _isManualMode = false;
  List<String> _buildings = [];
  List<LocationEntry> _locationsList = [];

  @override
  void dispose() {
    super.dispose();
  }

  void _removeIdLocationQrScanner() {
    setState(() {
      _idLocationQrScanner = '';
      _isManualMode = false;
    });
  }

  Future<void> _startRecordingMode() async {
    FocusScope.of(context).unfocus();

    final recorder = AudioRecorder();
    if (await recorder.hasPermission()) {
      setState(() {
        _recordingPath = null;
        _isRecordingMode = true;
      });
    } else {
      if (mounted) {
        showMessageSnackBar(
          context,
          message: 'Se necesita permiso para usar el micrófono',
          type: SnackBarType.error,
        );
      }
    }
    recorder.dispose();
  }

  bool _calculateIsReady(String idLocationFromQr) {
    final hasManualLocation =
        formSelectedHeadquarter != null &&
        formSelectedBuilding != null &&
        formSelectedLocation != null;

    final hasQrLocation = idLocationFromQr.isNotEmpty;

    final hasOptionalText =
        formUbicacionTextOpcional != null &&
        formUbicacionTextOpcional!.trim().isNotEmpty;

    final hasDescription =
        formDescription != null && formDescription!.trim().isNotEmpty;

    final hasAudio = _recordingPath != null;

    final hasContent = hasDescription || hasAudio;

    if (_isRecordingMode) {
      return false;
    }

    final hasValidLocation =
        hasQrLocation ||
        ((hasManualLocation && _isManualMode) || hasOptionalText);

    final ready = hasValidLocation && hasContent && formParaMi != null;

    return ready;
  }

  void _updateBuildingsForHeadquarter(
    String? headquarter,
    List<Headquarters> locationTree,
  ) {
    if (headquarter == null) {
      _buildings = [];
      _locationsList = [];
      return;
    }
    final h = locationTree.firstWhere(
      (t) => t.sede == headquarter,
      orElse: () => Headquarters(sede: headquarter, edificios: []),
    );
    _buildings = h.edificios.map((e) => e.nombre).toList();
    _locationsList = [];
  }

  void _updateLocationsForBuilding(
    String headquarter,
    String? building,
    List<Headquarters> locationTree,
  ) {
    if (building == null) {
      _locationsList = [];
      return;
    }
    final h = locationTree.firstWhere(
      (t) => t.sede == headquarter,
      orElse: () => Headquarters(sede: headquarter, edificios: []),
    );
    final b = h.edificios.firstWhere(
      (e) => e.nombre == building,
      orElse: () => Building(nombre: building, ubicaciones: []),
    );
    _locationsList = b.ubicaciones;
  }

  Future<void> _submitReport() async {
    final idLocationFromQr = _idLocationQrScanner;

    final locationToSend = idLocationFromQr.isNotEmpty
        ? idLocationFromQr
        : formSelectedLocation;

    if (formParaMi == null ||
        (formDescription == null && _recordingPath == null)) {
      if (mounted) {
        showMessageSnackBar(
          context,
          message: 'Faltan datos de Contenido o Destino',
          type: SnackBarType.error,
        );
      }
      return;
    }

    try {
      final response = await ref.read(
        createReportProvider(
          locationToSend,
          formDescription,
          _recordingPath,
          formParaMi!,
          formUbicacionTextOpcional,
        ).future,
      );

      if (response && mounted) {
        _removeIdLocationQrScanner();
        context.pop();
      } else {
        if (mounted) {
          showMessageSnackBar(
            context,
            message: 'No se pudo enviar el reporte',
            type: SnackBarType.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showMessageSnackBar(
          context,
          message: 'Error de conexión con el servidor',
          type: SnackBarType.error,
        );
      }
    }
  }

  Widget _buildSectionHeader({required String title}) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildQrLocationField() {
    final colors = Theme.of(context).colorScheme;
    final isScanned = _idLocationQrScanner.isNotEmpty;

    final locationByIdAsync = isScanned
        ? ref.watch(
            locationByIdProvider(int.tryParse(_idLocationQrScanner) ?? -1),
          )
        : null;

    return FormField<String>(
      initialValue: _idLocationQrScanner,
      validator: (value) {
        final hasQr = _idLocationQrScanner.isNotEmpty;
        final hasManualLocationComplete =
            _isManualMode &&
            formSelectedHeadquarter != null &&
            formSelectedBuilding != null &&
            formSelectedLocation != null;
        final hasOptionalText =
            formUbicacionTextOpcional != null &&
            formUbicacionTextOpcional!.trim().isNotEmpty;

        if (hasQr || hasManualLocationComplete || hasOptionalText) {
          return null;
        }
        return 'Debes proporcionar una ubicación (QR, manual o texto).';
      },
      builder: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.value != _idLocationQrScanner) {
            state.didChange(_idLocationQrScanner);
          }
        });

        return Column(
          children: [
            isScanned
                ? _buildScannedLocationCard(colors, locationByIdAsync!)
                : _buildScanPrompt(colors),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  state.errorText!,
                  style: GoogleFonts.poppins(
                    color: colors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildScannedLocationCard(
    ColorScheme colors,
    AsyncValue<Map<String, dynamic>> locationAsync,
  ) {
    return Card(
      key: const ValueKey('scanned_card'),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: colors.tertiary, width: 1.5),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on, color: colors.tertiary, size: 40),
            title: locationAsync.when(
              data: (map) {
                final lugar = (map['lugar'] as String?) ?? 'Lugar Desconocido';
                return Text(
                  lugar,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.tertiary,
                  ),
                );
              },
              loading: () => Text(
                'Cargando...',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              error: (err, st) => Text(
                'Error al cargar',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: locationAsync.when(
              data: (map) {
                final sede = (map['sede'] as String?) ?? 'Sede no especificada';
                final edificio = (map['edificio'] as String?) ?? '';
                final piso = (map['piso'] as String?) ?? '';

                // Construimos el subtítulo dinámicamente
                final details = [
                  sede,
                  if (edificio.isNotEmpty) 'Edificio $edificio',
                  if (piso.isNotEmpty) 'Piso $piso',
                ];

                return Text(
                  details.join(' - '),
                  style: GoogleFonts.poppins(color: colors.onSurfaceVariant),
                );
              },
              loading: () => const Text('...'),
              error: (err, st) => null,
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton.icon(
              onPressed: _removeIdLocationQrScanner,
              icon: Icon(Icons.delete_forever, size: 20),
              label: Text('Limpiar Ubicación Escaneada'),
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanPrompt(ColorScheme colors) {
    return GestureDetector(
      key: const ValueKey('scan_prompt'),
      onTap: () async {
        final String? result = await context.push<String>(
          '/user/create-report/qr-scanner',
        );
        if (result != null && result.isNotEmpty) {
          setState(() {
            _idLocationQrScanner = result;
            _isManualMode = false;
            formSelectedHeadquarter = null;
            formSelectedBuilding = null;
            formSelectedLocation = null;
            formUbicacionTextOpcional = null;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: colors.primary,
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
                    'QR Más Cercano',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: colors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Presionar para escanear la ubicación',
                    style: GoogleFonts.poppins(
                      color: colors.onPrimary.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.qr_code_scanner, size: 80, color: colors.onPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalLocationField() {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      initialValue: formUbicacionTextOpcional,
      onChanged: (value) {
        setState(() {
          formUbicacionTextOpcional = value;
        });
      },
      minLines: 2,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.poppins(fontSize: 20),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        hintText: "Ejemplo: Bicentenario, Piso 2, Salon 202",
        hintStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: colors.onSurface.withValues(alpha: 0.4),
        ),
        label: Text(
          'Usar solo si no se puede escanear o seleccionar manualmente la ubicación',
          style: GoogleFonts.poppins(
            color: colors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildParaMiToggleButtons() {
    final colors = Theme.of(context).colorScheme;
    return FormField<bool>(
      initialValue: formParaMi,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (formParaMi == null) {
          return 'Selecciona una opción';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ToggleButtons(
                isSelected: [formParaMi == true, formParaMi == false],
                onPressed: (index) {
                  setState(() {
                    formParaMi = index == 0;
                    state.didChange(formParaMi);
                  });
                },
                borderRadius: BorderRadius.circular(10),
                constraints: const BoxConstraints.tightFor(
                  height: 60,
                  width: 160,
                ),
                fillColor: colors.primary,
                selectedColor: colors.onPrimary,
                color: colors.onSurface,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Si, Soy yo',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Otro Persona',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  state.errorText!,
                  style: GoogleFonts.poppins(
                    color: colors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAudioPlayer() {
    if (_recordingPath == null) {
      return const SizedBox.shrink();
    }

    final audioNotifier = ref.read(audioPlayerNotifierProvider.notifier);

    return AudioPlayerWidget(
      key: ValueKey(_recordingPath!),
      filePath: _recordingPath!,
      audioNotifier: audioNotifier,
      onDeleted: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return ConfirmDialog(
              title: "Confirmar eliminación del audio",
              message: "¿Estás seguro de que quieres eliminar esta grabación?",
              confirmText: "Eliminar",
              cancelText: "Cancelar",
              onConfirm: () async {
                setState(() {
                  _recordingPath = null;
                });
              },
            );
          },
        );
      },
    );
  }

  Widget _buildContentSection() {
    final colors = Theme.of(context).colorScheme;

    if (_isRecordingMode) {
      return AudioRecorderWidget(
        onStop: (path) {
          setState(() {
            _recordingPath = path;
            _isRecordingMode = false;
          });
        },
        onCancel: () {
          setState(() {
            _recordingPath = null;
            _isRecordingMode = false;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                initialValue: formDescription,
                minLines: 2,
                maxLines: 7,
                onChanged: (value) {
                  setState(() {
                    formDescription = value;
                  });
                },
                style: GoogleFonts.poppins(fontSize: 20),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  final hasDescription =
                      value != null && value.trim().isNotEmpty;
                  final hasAudio = _recordingPath != null;
                  if (!hasDescription && !hasAudio) {
                    return 'Se requiere descripción o un audio.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Ejemplo: Se desmayo una persona",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: 'recorder',
              onPressed: _startRecordingMode,
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              tooltip: 'Grabar un audio',
              elevation: 0,
              child: const Icon(Icons.mic),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_recordingPath != null) _buildAudioPlayer(),
      ],
    );
  }

  TextButton _buildManualModeButton(ColorScheme colors) {
    return TextButton(
      onPressed: () {
        final nextMode = !_isManualMode;
        setState(() {
          _isManualMode = nextMode;
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: colors.onTertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Seleccionar de forma manual',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.onSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            _isManualMode
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            size: 30,
            color: colors.onSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildManualLocationSelector(
    AsyncValue<List<Headquarters>> locationsAsync,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: locationsAsync.when(
        loading: () => const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => SizedBox(
          height: 180,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error de carga. Intenta de nuevo.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(locationsTreeProvider),
                  child: Text('Reintentar', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ),
        ),
        data: (locationTree) {
          final _headquarters = locationTree.map((t) => t.sede).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: formSelectedHeadquarter,
                decoration: InputDecoration(
                  labelText: 'Seleccionar Sede',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                  errorStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                items: _headquarters
                    .map(
                      (headquarter) => DropdownMenuItem(
                        value: headquarter,
                        child: Text(
                          headquarter,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    formSelectedHeadquarter = value;
                    formSelectedBuilding = null;
                    formSelectedLocation = null;
                    _updateBuildingsForHeadquarter(value, locationTree);
                  });
                },
                validator: (value) {
                  final isQrEmpty = _idLocationQrScanner.isEmpty;
                  final hasOptionalText =
                      formUbicacionTextOpcional != null &&
                      formUbicacionTextOpcional!.trim().isNotEmpty;

                  if (hasOptionalText) return null;

                  if (_isManualMode &&
                      isQrEmpty &&
                      (value == null || value.isEmpty)) {
                    return 'Selecciona una sede';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: formSelectedBuilding,
                decoration: InputDecoration(
                  labelText: 'Seleccionar Edificio',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                  errorStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                items: _buildings
                    .map(
                      (build) => DropdownMenuItem(
                        value: build,
                        child: Text(
                          build.startsWith(RegExp(r'\d'))
                              ? 'Edificio $build'
                              : build,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    formSelectedBuilding = value;
                    formSelectedLocation = null;
                    if (formSelectedHeadquarter != null) {
                      _updateLocationsForBuilding(
                        formSelectedHeadquarter!,
                        value,
                        locationTree,
                      );
                    } else {
                      _locationsList = [];
                    }
                  });
                },
                validator: (value) {
                  final isQrEmpty = _idLocationQrScanner.isEmpty;
                  final hasOptionalText =
                      formUbicacionTextOpcional != null &&
                      formUbicacionTextOpcional!.trim().isNotEmpty;

                  if (hasOptionalText) return null;

                  if (_isManualMode &&
                      isQrEmpty &&
                      (value == null || value.isEmpty)) {
                    return 'Selecciona un edificio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: formSelectedLocation,
                decoration: InputDecoration(
                  labelText: 'Seleccionar Salón',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                  errorStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                items: _locationsList
                    .map(
                      (location) => DropdownMenuItem(
                        value: location.idUbicacion.toString(),
                        child: Text(
                          '${location.lugar.isNotEmpty ? location.lugar : location.descripcion}${location.piso.isNotEmpty ? ' · Piso ${location.piso}' : ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => formSelectedLocation = value);
                },
                validator: (value) {
                  final isQrEmpty = _idLocationQrScanner.isEmpty;
                  final hasOptionalText =
                      formUbicacionTextOpcional != null &&
                      formUbicacionTextOpcional!.trim().isNotEmpty;

                  if (hasOptionalText) return null;

                  if (_isManualMode &&
                      isQrEmpty &&
                      (value == null || value.isEmpty)) {
                    return 'Selecciona un salón para completar la ubicación manual.';
                  }
                  return null;
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton(bool isReady) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 90,
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          disabledBackgroundColor: _isRecordingMode
              ? Colors.grey.withAlpha(128)
              : colors.primary,
        ),
        onPressed: (_isRecordingMode)
            ? null
            : () {
                final valid = _formKey.currentState!.validate();

                if (!valid) {
                  FocusScope.of(context).unfocus();
                  return;
                }
                if (_calculateIsReady(_idLocationQrScanner)) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return ConfirmDialog(
                        title: "Confirmar envío",
                        message: "¿Estás seguro de enviar este reporte?",
                        confirmText: "Enviar",
                        cancelText: "Cancelar",
                        onConfirm: () async {
                          await _submitReport();
                        },
                      );
                    },
                  );
                }
              },
        label: Text(
          'Enviar Reporte',
          style: GoogleFonts.poppins(
            color: colors.onSecondary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          _isRecordingMode ? Icons.cancel : Icons.send,
          color: colors.onSecondary,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(locationsTreeProvider);
    final colors = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<List<Headquarters>>>(locationsTreeProvider, (
      previous,
      next,
    ) {
      final bool isError = next is AsyncError;
      final bool wasError = previous is AsyncError;

      if (isError && !wasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showMessageSnackBar(
              context,
              message: 'Error al cargar ubicaciones',
              type: SnackBarType.error,
            );
          }
        });
      }
    });

    final bool isReadyToSend = _calculateIsReady(_idLocationQrScanner);

    final bool isManualSelectionComplete =
        formSelectedHeadquarter != null &&
        formSelectedBuilding != null &&
        formSelectedLocation != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Reporte',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: colors.onSurface,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(title: 'Ubicación *'),
                      const SizedBox(height: 10),
                      if (!_isManualMode) ...[
                        _buildQrLocationField(),
                        const SizedBox(height: 12),
                      ],
                      if (_idLocationQrScanner.isEmpty) ...[
                        _buildManualModeButton(colors),
                        if (_isManualMode) ...[
                          const SizedBox(height: 10),
                          _buildManualLocationSelector(locationsAsync),
                          const SizedBox(height: 20),

                          if (!isManualSelectionComplete)
                            _buildOptionalLocationField(),
                        ],
                      ],
                      const SizedBox(height: 14),
                      _buildSectionHeader(title: '¿Tú eres el herido? *'),
                      const SizedBox(height: 10),
                      _buildParaMiToggleButtons(),
                      const SizedBox(height: 14),
                      _buildSectionHeader(title: 'Descripción *'),
                      const SizedBox(height: 10),
                      _buildContentSection(),
                      const SizedBox(height: 40),
                      _buildSubmitButton(isReadyToSend),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
