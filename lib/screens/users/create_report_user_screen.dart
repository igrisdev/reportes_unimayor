import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:reportes_unimayor/providers/id_location_qr_scanner.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/widgets/app_bar_user.dart';
import 'package:path/path.dart' as p;
import 'package:reportes_unimayor/utils/show_message.dart';

class CreateReportUserScreen extends ConsumerStatefulWidget {
  const CreateReportUserScreen({super.key});

  @override
  ConsumerState createState() => _CreateReportUserScreenState();
}

class _CreateReportUserScreenState
    extends ConsumerState<CreateReportUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _headquarters = ['Bicentenario'];
  final List<String> _buildings = ['1'];
  final List<Map<String, String>> _locations = [
    {'idLocation': '1', 'location': 'Salón 202'},
  ];

  String? _selectedHeadquarter;
  String? _selectedBuilding;
  String? _selectedLocation;
  String? _description;

  String _locationInputMode = 'Qr'; // 'Qr' o 'Seleccionar'
  String _descriptionInputMode = 'Audio'; // 'Audio' o 'Escribir'

  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;
  bool _isRecording = false;

  bool _isSending = false;
  bool _isManualMode = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_locationInputMode == 'Qr' &&
        ref.read(idLocationQrScannerProvider).isEmpty) {
      showMessage(
        context,
        'Por favor, escanee un código QR para la ubicación.',
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    if (_descriptionInputMode == 'Audio' && _recordingPath == null) {
      showMessage(
        context,
        'Por favor, grabe un audio para la descripción.',
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    setState(() => _isSending = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(strokeWidth: 3),
              const SizedBox(width: 20),
              Text(
                'Enviando reporte...',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final idLocationFromQr = ref.read(idLocationQrScannerProvider);
      final locationToSend = idLocationFromQr.isNotEmpty
          ? idLocationFromQr
          : _selectedLocation;

      bool? response;

      if (_descriptionInputMode == 'Audio') {
        response = await ref.read(
          createReportRecordProvider(locationToSend!, _recordingPath!).future,
        );
      } else {
        response = await ref.read(
          createReportWriteProvider(locationToSend!, _description!).future,
        );
      }

      if (mounted) Navigator.of(context).pop();

      if (response == true && mounted) {
        ref
            .read(idLocationQrScannerProvider.notifier)
            .removeIdLocationQrScanner();
        context.go('/user');
      } else {
        showMessage(
          context,
          'No se pudo enviar el reporte. Intente de nuevo.',
          Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      showMessage(
        context,
        'Ocurrió un error: ${e.toString()}',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final idLocationQrScanner = ref.watch(idLocationQrScannerProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppBarUser(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader(title: 'Ubicación*'),
              const SizedBox(height: 10),
              qrScannerButton(idLocationQrScanner),
              const SizedBox(height: 12),
              buttonManualMode(colors),
              if (_isManualMode) const SizedBox(height: 10),
              if (_isManualMode) manualLocationSelector(),
              const SizedBox(height: 14),
              sectionHeader(title: 'Descripción*'),
              const SizedBox(height: 10),
              descriptionField(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          minLines: 2,
          maxLines: 7,
          onChanged: (value) => _description = value,
          decoration: InputDecoration(
            hintText: "Descripción del reporte",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.mic, color: Colors.black, size: 30),
              onPressed: () {},
            ),
          ),
          validator: (value) {
            if (_descriptionInputMode == 'Escribir' &&
                (value == null || value.trim().isEmpty)) {
              return 'Por favor escriba una descripción';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAudioRecorder() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 60,
                color: _isRecording
                    ? colors.error
                    : _recordingPath == null
                    ? colors.onSurface
                    : colors.tertiary,
                icon: Icon(
                  _isRecording ? Icons.stop_circle_outlined : Icons.mic,
                ),
                onPressed: _toggleRecording,
              ),
              const SizedBox(height: 8),
              (_recordingPath != null && !_isRecording)
                  ? Text(
                      'Audio grabado. ¡Listo para enviar!',
                      style: TextStyle(color: colors.tertiary),
                    )
                  : Text(
                      _isRecording ? 'Grabando...' : 'Presione para grabar',
                      style: TextStyle(color: colors.onSurface),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  TextButton buttonManualMode(ColorScheme colors) {
    return TextButton(
      onPressed: () {
        setState(() => _isManualMode = !_isManualMode);
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
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700),
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
          DropdownButtonFormField<String>(
            initialValue: _selectedHeadquarter,
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
            onChanged: (value) => setState(() => _selectedHeadquarter = value),
            validator: (value) {
              if (_locationInputMode == 'Seleccionar' && value == null) {
                return 'Seleccione una sede';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _selectedBuilding,
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
                      build,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedBuilding = value),
            validator: (value) {
              if (_locationInputMode == 'Seleccionar' && value == null) {
                return 'Seleccione un edificio';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _selectedLocation,
            decoration: InputDecoration(
              labelText: 'Seleccionar Salón',
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
            items: _locations
                .map(
                  (location) => DropdownMenuItem(
                    value: location['idLocation'],
                    child: Text(
                      location['location']!,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedLocation = value),
            validator: (value) {
              if (_locationInputMode == 'Seleccionar' && value == null) {
                return 'Seleccione un salón';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget qrScannerButton(String idLocationQrScanner) {
    final colors = Theme.of(context).colorScheme;
    final bool isScanned = idLocationQrScanner.isNotEmpty;

    return GestureDetector(
      onTap: () => context.push('/user/create-report/qr-scanner'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                    isScanned ? 'Ubicación Escaneada' : 'QR MAS CERCANO',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: isScanned ? colors.tertiary : colors.onSurface,
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
    );
  }

  Future<void> _toggleRecording() async {
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

  Widget _buildSubmitButton() {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 80,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: colors.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _isRecording || _isSending ? null : _submitReport,
          label: Text(
            'Enviar Reporte',
            style: GoogleFonts.poppins(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(Icons.send, color: colors.onSurface, size: 24),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String text,
    String value,
    String groupValue,
    VoidCallback onPressed,
  ) {
    final colors = Theme.of(context).colorScheme;
    final bool isSelected = groupValue == value;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? colors.primary.withValues(alpha: 0.1)
            : colors.surface,
        foregroundColor: isSelected ? colors.primary : colors.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? colors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
