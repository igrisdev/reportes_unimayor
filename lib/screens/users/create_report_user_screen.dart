import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:reportes_unimayor/providers/id_location_qr_scanner.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';
import 'package:reportes_unimayor/themes/light.theme.dart';
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

  final List<String> _headquarters = ['Bicentenario', 'Encarnación'];
  final List<String> _buildings = ['Edificio 1'];
  final List<Map<String, String>> _locations = [
    {'idLocation': '1', 'location': 'Salón 101'},
    {'idLocation': '2', 'location': 'Salón 202'},
    {'idLocation': '3', 'location': 'Salón 302'},
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
        Colors.red.shade700,
      );
      return;
    }

    // 3. VALIDACIÓN PERSONALIZADA: Verificar si se grabó un audio
    if (_descriptionInputMode == 'Audio' && _recordingPath == null) {
      showMessage(
        context,
        'Por favor, grabe un audio para la descripción.',
        Colors.red.shade700,
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      // Asignar la ubicación escaneada si existe
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
        // 'Escribir'
        response = await ref.read(
          createReportWriteProvider(locationToSend!, _description!).future,
        );
      }

      if (response == true && mounted) {
        ref
            .read(idLocationQrScannerProvider.notifier)
            .removeIdLocationQrScanner();
        context.go('/user');
        // showMessage(
        //   context,
        //   'Reporte enviado con éxito.',
        //   Colors.green.shade700,
        // );
      } else {
        showMessage(
          context,
          'No se pudo enviar el reporte. Intente de nuevo.',
          Colors.red.shade700,
        );
      }
    } catch (e) {
      showMessage(
        context,
        'Ocurrió un error: ${e.toString()}',
        Colors.red.shade700,
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

    return Scaffold(
      appBar: const AppBarUser(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECCIÓN DE UBICACIÓN ---
              _buildSectionHeader(
                title: 'Ubicación',
                children: [
                  _buildToggleButton(
                    'Escáner Qr',
                    'Qr',
                    _locationInputMode,
                    () {
                      setState(() => _locationInputMode = 'Qr');
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildToggleButton(
                    'Seleccionar',
                    'Seleccionar',
                    _locationInputMode,
                    () {
                      setState(() => _locationInputMode = 'Seleccionar');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_locationInputMode == 'Seleccionar')
                _buildManualLocationSelector()
              else
                _buildQrScannerButton(idLocationQrScanner),

              const SizedBox(height: 30),

              // --- SECCIÓN DE DESCRIPCIÓN ---
              _buildSectionHeader(
                title: 'Descripción',
                children: [
                  _buildToggleButton(
                    'Audio',
                    'Audio',
                    _descriptionInputMode,
                    () {
                      setState(() => _descriptionInputMode = 'Audio');
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildToggleButton(
                    'Escribir',
                    'Escribir',
                    _descriptionInputMode,
                    () {
                      setState(() => _descriptionInputMode = 'Escribir');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_descriptionInputMode == 'Escribir')
                _buildDescriptionTextField()
              else
                _buildAudioRecorder(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  /// Construye la cabecera de una sección con un título y botones.
  Widget _buildSectionHeader({
    required String title,
    required List<Widget> children,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(children: children),
      ],
    );
  }

  /// Construye los selectores de ubicación manual (Dropdowns).
  Widget _buildManualLocationSelector() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedHeadquarter,
          decoration: const InputDecoration(labelText: 'Seleccionar Sede'),
          items: _headquarters.map((headquarter) {
            return DropdownMenuItem(
              value: headquarter,
              child: Text(headquarter),
            );
          }).toList(),
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
          decoration: const InputDecoration(labelText: 'Seleccionar Edificio'),
          items: _buildings.map((build) {
            return DropdownMenuItem(value: build, child: Text(build));
          }).toList(),
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
          decoration: const InputDecoration(labelText: 'Seleccionar Salón'),
          items: _locations.map((location) {
            return DropdownMenuItem(
              value: location['idLocation'],
              child: Text(location['location']!),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedLocation = value),
          validator: (value) {
            if (_locationInputMode == 'Seleccionar' && value == null) {
              return 'Seleccione un salón';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construye el botón para escanear el código QR.
  Widget _buildQrScannerButton(String idLocationQrScanner) {
    final bool isScanned = idLocationQrScanner.isNotEmpty;
    return GestureDetector(
      onTap: () => context.push('/user/create-report/qr-scanner'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          // MEJORA: Color visual para indicar éxito
          color: isScanned ? Colors.green.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isScanned ? Colors.green : Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isScanned ? 'Ubicación Escaneada' : 'Escanear QR',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isScanned ? Colors.green.shade800 : Colors.black,
                  ),
                ),
                Text(
                  isScanned
                      ? 'ID: $idLocationQrScanner'
                      : 'Presionar para escanear',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            Icon(
              isScanned ? Icons.check_circle : Icons.qr_code_scanner,
              size: 40,
              color: isScanned ? Colors.green.shade700 : Colors.grey.shade800,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el campo de texto para la descripción.
  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 7,
      decoration: const InputDecoration(
        labelText: 'Descripción del reporte',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => _description = value,
      validator: (value) {
        if (_descriptionInputMode == 'Escribir' &&
            (value == null || value.trim().isEmpty)) {
          return 'Por favor escriba una descripción';
        }
        return null;
      },
    );
  }

  /// Construye la UI para grabar audio.
  Widget _buildAudioRecorder() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 60,
                color: _isRecording
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                icon: Icon(
                  _isRecording ? Icons.stop_circle_outlined : Icons.mic,
                ),
                onPressed: _toggleRecording,
              ),
              const SizedBox(height: 8),
              (_recordingPath != null && !_isRecording)
                  ? const Text(
                      'Audio grabado. ¡Listo para enviar!',
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(_isRecording ? 'Grabando...' : 'Presione para grabar'),
            ],
          ),
        ),
      ],
    );
  }

  /// Lógica para iniciar y detener la grabación.
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
          _recordingPath = null; // Limpiar path anterior al empezar a grabar
        });
      } else {
        showMessage(
          context,
          'Se necesita permiso para usar el micrófono.',
          Colors.red.shade700,
        );
      }
    }
  }

  /// Construye el botón de envío principal.
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 80,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightMode.colorScheme.secondary,
            foregroundColor: Colors.white,
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
            _isSending ? 'Enviando...' : 'Enviar Reporte',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: _isSending
              ? Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : const Icon(Icons.send, color: Colors.black, size: 24),
        ),
      ),
    );
  }

  /// Construye un botón de texto para alternar modos.
  Widget _buildToggleButton(
    String text,
    String value,
    String groupValue,
    VoidCallback onPressed,
  ) {
    final bool isSelected = groupValue == value;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        foregroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
