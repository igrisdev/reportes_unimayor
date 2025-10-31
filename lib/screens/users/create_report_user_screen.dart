import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:reportes_unimayor/providers/id_location_qr_scanner.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/providers/location_providers.dart';
import 'package:reportes_unimayor/models/location_tree.dart';
import 'package:path/path.dart' as p;
import 'package:reportes_unimayor/utils/show_message.dart';
import 'package:reportes_unimayor/widgets/general/confirm_dialog.dart';

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

  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;
  bool _isRecording = false;

  bool _isManualMode = false;

  List<String> _buildings = [];
  List<LocationEntry> _locationsList = [];

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
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

    if (_isRecording) {
      return false;
    }

    final hasValidLocation =
        hasQrLocation ||
        (hasManualLocation && _isManualMode) ||
        hasOptionalText;

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

  @override
  Widget build(BuildContext context) {
    final idLocationQrScanner = ref.watch(idLocationQrScannerProvider);
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
            showMessage(
              context,
              'Error cargando ubicaciones',
              Theme.of(context).colorScheme.error,
            );
          }
        });
      }
    });

    final bool isReadyToSend = _calculateIsReady(idLocationQrScanner);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionHeader(title: 'Ubicación *'),
                const SizedBox(height: 10),
                qrFormField(idLocationQrScanner),
                const SizedBox(height: 12),
                buttonManualMode(colors),
                if (_isManualMode) const SizedBox(height: 10),
                if (_isManualMode) manualLocationSelector(locationsAsync),
                if (_isManualMode) const SizedBox(height: 20),
                if (_isManualMode) ubicacionTextOpcionalField(),
                const SizedBox(height: 14),
                sectionHeader(title: '¿Tú eres el herido? *'),
                const SizedBox(height: 10),
                paraMiToggleButtons(),
                const SizedBox(height: 14),
                sectionHeader(title: 'Descripción *'),
                const SizedBox(height: 10),
                descriptionField(),
                const SizedBox(height: 40),
                buttonSubmitReport(isReadyToSend),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: buttonSubmitReport(isReadyToSend),
    );
  }

  Widget qrFormField(String idLocationQrScanner) {
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
            _isManualMode &&
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
              onTap: () => context.push('/user/create-report/qr-scanner'),
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

  Widget ubicacionTextOpcionalField() {
    final colors = Theme.of(context).colorScheme;

    return TextFormField(
      initialValue: formUbicacionTextOpcional,
      onChanged: (value) {
        setState(() {
          formUbicacionTextOpcional = value;
        });
      },
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
            color: colors.onSurface.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),

        labelText: 'Ultima forma de mandar la ubicación',
        labelStyle: GoogleFonts.poppins(
          color: colors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),

        hintText: "Ejemplo: Bicentenario, Piso 2, Salon 202",
        hintStyle: GoogleFonts.poppins(fontSize: 15),
      ),
    );
  }

  Widget paraMiToggleButtons() {
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

  Widget descriptionField() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: formDescription,
          minLines: 3,
          maxLines: 7,
          onChanged: (value) {
            setState(() {
              formDescription = value;
            });
          },
          style: GoogleFonts.poppins(fontSize: 20),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final hasDescription = value != null && value.trim().isNotEmpty;
            final hasAudio = _recordingPath != null;
            if (!hasDescription && !hasAudio) {
              return 'Se requiere descripción o un audio.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Descripción del reporte",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            suffixIcon: IconButton(
              iconSize: 40,
              color: _isRecording
                  ? colors.error
                  : _recordingPath == null
                  ? colors.onSurface
                  : colors.tertiary,
              icon: Icon(_isRecording ? Icons.stop_circle_outlined : Icons.mic),
              onPressed: _toggleRecording,
            ),
          ),
        ),
        const SizedBox(height: 8),
        (_recordingPath != null && !_isRecording)
            ? Text(
                'Audio grabado. ¡Listo para enviar!',
                style: GoogleFonts.poppins(
                  color: colors.tertiary,
                  fontSize: 18,
                ),
              )
            : Text(
                _isRecording
                    ? 'Grabando..., click para parar'
                    : 'Un toque para grabar',
                style: GoogleFonts.poppins(
                  color: colors.onSurface,
                  fontSize: 18,
                ),
              ),
      ],
    );
  }

  TextButton buttonManualMode(ColorScheme colors) {
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
      // decoration: BoxDecoration(
      //                   color: isScanned
      //                       ? colors.tertiary.withValues(alpha: 0.1)
      //                       : colors.primary,
      //                   border: Border.all(
      //                     color: isScanned ? colors.tertiary : colors.onSurface,
      //                   ),
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
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

  Widget sectionHeader({required String title}) {
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

  Widget manualLocationSelector(AsyncValue<List<Headquarters>> locationsAsync) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: locationsAsync.when(
        loading: () {
          return SizedBox(
            height: 180,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(
                    'Cargando ubicaciones...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (err, stack) {
          return SizedBox(
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
                    onPressed: () {
                      ref.invalidate(locationsTreeProvider);
                    },
                    child: Text('Reintentar', style: GoogleFonts.poppins()),
                  ),
                ],
              ),
            ),
          );
        },
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
                  final isQrEmpty = ref
                      .read(idLocationQrScannerProvider)
                      .isEmpty;

                  final hasOptionalText =
                      formUbicacionTextOpcional != null &&
                      formUbicacionTextOpcional!.trim().isNotEmpty;

                  if (hasOptionalText) {
                    return null;
                  }

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
                  final isQrEmpty = ref
                      .read(idLocationQrScannerProvider)
                      .isEmpty;

                  final hasOptionalText =
                      formUbicacionTextOpcional != null &&
                      formUbicacionTextOpcional!.trim().isNotEmpty;

                  if (hasOptionalText) {
                    return null;
                  }

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
                  final isQrEmpty = ref
                      .read(idLocationQrScannerProvider)
                      .isEmpty;

                  final hasOptionalText =
                      formUbicacionTextOpcional != null &&
                      formUbicacionTextOpcional!.trim().isNotEmpty;

                  if (hasOptionalText) {
                    return null;
                  }

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

  Future<void> _toggleRecording() async {
    FocusScope.of(context).unfocus();

    if (_isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
    } else {
      if (await _audioRecorder.hasPermission()) {
        final appDocumentsDir = await getApplicationDocumentsDirectory();
        final filePath = p.join(appDocumentsDir.path, 'audio_report.m4a');

        await _audioRecorder.start(const RecordConfig(), path: filePath);

        setState(() {
          _isRecording = true;
          _recordingPath = null;
        });
      } else {
        showMessage(
          context,
          'Se necesita permiso para usar el micrófono.',
          Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  Widget buttonSubmitReport(bool isReady) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          disabledBackgroundColor: _isRecording
              ? Colors.grey.withValues(alpha: 0.5)
              : colors.primary,
        ),
        onPressed: (_isRecording)
            ? null
            : () {
                final valid = _formKey.currentState!.validate();

                if (!valid) {
                  FocusScope.of(context).unfocus();
                  return;
                }

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
          _isRecording ? Icons.cancel : Icons.send,
          color: colors.onSecondary,
          size: 24,
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    final idLocationFromQr = ref.read(idLocationQrScannerProvider);

    final locationToSend = idLocationFromQr.isNotEmpty
        ? idLocationFromQr
        : formSelectedLocation;

    if (formParaMi == null ||
        (formDescription == null && _recordingPath == null)) {
      if (mounted) {
        showMessage(
          context,
          'Faltan datos de Contenido o Destino.',
          Theme.of(context).colorScheme.error,
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
        ref
            .read(idLocationQrScannerProvider.notifier)
            .removeIdLocationQrScanner();
        context.pop();
      } else {
        if (mounted) {
          showMessage(
            context,
            'No se pudo enviar el reporte. Intente de nuevo.',
            Theme.of(context).colorScheme.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          'Error:${e.toString().split(':').last}',
          Theme.of(context).colorScheme.error,
        );
      }
    }
  }
}
