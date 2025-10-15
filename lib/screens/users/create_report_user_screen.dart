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

  List<Headquarters> _locationTree = [];
  List<String> _headquarters = [];
  List<String> _buildings = [];
  List<LocationEntry> _locationsList = [];

  bool _locationsLoaded = false;

  String? formSelectedHeadquarter;
  String? formSelectedBuilding;
  String? formSelectedLocation;
  String? formDescription;

  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;
  bool _isRecording = false;

  bool _isManualMode = false;
  bool _isReadyToSend = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  void _checkIfReadyToSend() {
    final idLocationFromQr = ref.read(idLocationQrScannerProvider);

    final hasManualLocation =
        formSelectedHeadquarter != null &&
        formSelectedBuilding != null &&
        formSelectedLocation != null;

    final hasQrLocation = idLocationFromQr.isNotEmpty;

    final hasDescription =
        formDescription != null && formDescription!.trim().isNotEmpty;

    final hasAudio = _recordingPath != null;

    final hasContent = hasDescription || hasAudio;

    if (_isRecording) {
      setState(() {
        _isReadyToSend = false;
      });
      return;
    }

    final ready = (hasManualLocation || hasQrLocation) && hasContent;

    setState(() {
      _isReadyToSend = ready;
    });
  }

  void _updateBuildingsForHeadquarter(String? headquarter) {
    if (headquarter == null) {
      _buildings = [];
      _locationsList = [];
      return;
    }
    final h = _locationTree.firstWhere(
      (t) => t.sede == headquarter,
      orElse: () => Headquarters(sede: headquarter, edificios: []),
    );
    _buildings = h.edificios.map((e) => e.nombre).toList();
    _locationsList = [];
  }

  void _updateLocationsForBuilding(String headquarter, String? building) {
    if (building == null) {
      _locationsList = [];
      return;
    }
    final h = _locationTree.firstWhere(
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
    final colors = Theme.of(context).colorScheme;

    final locationsAsync = ref.watch(locationsTreeProvider);

    locationsAsync.when(
      data: (tree) {
        if (!_locationsLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _locationTree = tree;
              _headquarters = tree.map((t) => t.sede).toList();
              _locationsLoaded = true;
            });
          });
        }
      },
      loading: () {
        // opcional: podrías indicar carga en la UI si deseas
      },
      error: (err, stack) {
        // Mostrar mensaje simple una vez si ocurre un error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showMessage(
            context,
            'Error cargando ubicaciones',
            Theme.of(context).colorScheme.error,
          );
        });
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfReadyToSend();
    });

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
      body: Form(
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
              if (_isManualMode) manualLocationSelector(),
              const SizedBox(height: 14),
              sectionHeader(title: 'Descripción *'),
              const SizedBox(height: 10),
              descriptionField(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buttonSubmitReport(),
    );
  }

  Widget qrFormField(String idLocationQrScanner) {
    final colors = Theme.of(context).colorScheme;

    return FormField<String>(
      initialValue: idLocationQrScanner,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!_isManualMode && (value == null || value.isEmpty)) {
          return 'Selecciona ubicación por QR o completa manualmente';
        }
        return null;
      },
      builder: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.value != idLocationQrScanner) {
            state.didChange(idLocationQrScanner);
          }
        });

        final bool isScanned = (idLocationQrScanner.isNotEmpty);

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
                      : colors.secondary,
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
                            isScanned
                                ? 'Ubicación Escaneada'
                                : 'QR MAS CERCANO',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: isScanned
                                  ? colors.tertiary
                                  : colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isScanned
                                ? 'ID: $idLocationQrScanner'
                                : 'Presionar para escanear la ubicación',
                            style: GoogleFonts.poppins(
                              color: colors.onSurface,
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
                      color: isScanned ? colors.tertiary : colors.onSurface,
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
                  style: TextStyle(color: colors.error, fontSize: 13),
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
            formDescription = value;
            _checkIfReadyToSend();
          },
          style: GoogleFonts.poppins(fontSize: 20),
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
        setState(() => _isManualMode = !_isManualMode);
        _checkIfReadyToSend();
      },
      style: TextButton.styleFrom(
        backgroundColor: colors.primary,
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
              color: colors.onTertiary,
            ),
          ),
          const SizedBox(width: 10),
          if (!_isManualMode)
            Icon(
              Icons.keyboard_arrow_up_sharp,
              size: 30,
              color: colors.onTertiary,
            )
          else
            Icon(
              Icons.keyboard_arrow_down_sharp,
              size: 30,
              color: colors.onTertiary,
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
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
      ],
    );
  }

  Widget manualLocationSelector() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SEDE
          DropdownButtonFormField<String>(
            value: formSelectedHeadquarter,
            decoration: InputDecoration(
              labelText: 'Seleccionar Sede',
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.primary,
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
                _updateBuildingsForHeadquarter(value);
              });
              _checkIfReadyToSend();
            },
            validator: (value) {
              if (_isManualMode && (value == null || value.isEmpty)) {
                return 'Selecciona una sede';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // EDIFICIO
          DropdownButtonFormField<String>(
            value: formSelectedBuilding,
            decoration: InputDecoration(
              labelText: 'Seleccionar Edificio',
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
            items: _buildings
                .map(
                  (build) => DropdownMenuItem(
                    value: build,
                    child: Text(
                      // Mostrar con prefijo "Edificio " si es numérico o dejar como está
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
                  _updateLocationsForBuilding(formSelectedHeadquarter!, value);
                } else {
                  _locationsList = [];
                }
              });
              _checkIfReadyToSend();
            },
            validator: (value) {
              if (_isManualMode && (value == null || value.isEmpty)) {
                return 'Selecciona un edificio';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // SALÓN (ubicación)
          DropdownButtonFormField<String>(
            value: formSelectedLocation,
            decoration: InputDecoration(
              labelText: 'Seleccionar Salón',
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.primary,
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
              _checkIfReadyToSend();
            },
            validator: (value) {
              if (_isManualMode && (value == null || value.isEmpty)) {
                return 'Selecciona un salón';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
      _checkIfReadyToSend();
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

  Widget buttonSubmitReport() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 80,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _isRecording
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
              color: colors.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.send, color: colors.onSurface, size: 24),
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    try {
      final idLocationFromQr = ref.read(idLocationQrScannerProvider);
      final locationToSend = idLocationFromQr.isNotEmpty
          ? idLocationFromQr
          : formSelectedLocation;

      bool response = await ref.read(
        createReportProvider(
          locationToSend!,
          formDescription,
          _recordingPath,
        ).future,
      );

      if (response == true && mounted) {
        await Future.delayed(const Duration(milliseconds: 100));

        ref
            .read(idLocationQrScannerProvider.notifier)
            .removeIdLocationQrScanner();

        if (mounted) {
          context.pushReplacement('/user');
        }
      } else {
        showMessage(
          context,
          'No se pudo enviar el reporte. Intente de nuevo.',
          Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      showMessage(
        context,
        'Error:${e.toString().split(':').last}',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        _checkIfReadyToSend();
      }
    }
  }
}
