// widgets/_description_audio_field.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:reportes_unimayor/utils/show_message.dart';

// Tipo de función para notificar al padre sobre los cambios de estado de grabación
typedef RecordingStateCallback = void Function(bool isRecording, String? path);

class DescriptionAudioField extends StatefulWidget {
  final String? initialDescription;
  final bool isRecording;
  final String? recordingPath;
  final ValueChanged<String> onDescriptionChanged;
  final RecordingStateCallback onRecordingStateChanged;

  const DescriptionAudioField({
    super.key,
    this.initialDescription,
    required this.isRecording,
    this.recordingPath,
    required this.onDescriptionChanged,
    required this.onRecordingStateChanged,
  });

  @override
  State<DescriptionAudioField> createState() => _DescriptionAudioFieldState();
}

class _DescriptionAudioFieldState extends State<DescriptionAudioField> {
  // El AudioRecorder se maneja internamente en este widget
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    FocusScope.of(context).unfocus();

    if (widget.isRecording) {
      final path = await _audioRecorder.stop();
      // Notifica al padre el fin de la grabación
      widget.onRecordingStateChanged(false, path);
    } else {
      if (await _audioRecorder.hasPermission()) {
        final appDocumentsDir = await getApplicationDocumentsDirectory();
        // Usar un nombre de archivo único o temporal
        final filePath = p.join(appDocumentsDir.path, 'audio_report_${DateTime.now().millisecondsSinceEpoch}.m4a');

        await _audioRecorder.start(const RecordConfig(), path: filePath);

        // Notifica al padre el inicio de la grabación
        widget.onRecordingStateChanged(true, null);
      } else {
        if (mounted) {
          showMessage(
            context,
            'Se necesita permiso para usar el micrófono.',
            Theme.of(context).colorScheme.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: widget.initialDescription,
          minLines: 3,
          maxLines: 7,
          onChanged: widget.onDescriptionChanged, // Llama al callback del padre
          style: GoogleFonts.poppins(fontSize: 20),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final hasDescription = value != null && value.trim().isNotEmpty;
            final hasAudio = widget.recordingPath != null;
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
              color: widget.isRecording
                  ? colors.error
                  : widget.recordingPath == null
                      ? colors.onSurface
                      : colors.tertiary,
              icon: Icon(widget.isRecording ? Icons.stop_circle_outlined : Icons.mic),
              onPressed: _toggleRecording,
            ),
          ),
        ),
        const SizedBox(height: 8),
        (widget.recordingPath != null && !widget.isRecording)
            ? Text(
                'Audio grabado. ¡Listo para enviar!',
                style: GoogleFonts.poppins(
                  color: colors.tertiary,
                  fontSize: 18,
                ),
              )
            : Text(
                widget.isRecording
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
}