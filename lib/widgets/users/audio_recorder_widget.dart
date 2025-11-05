import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:reportes_unimayor/widgets/general/confirm_dialog.dart';

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color waveColor;

  WaveformPainter({required this.amplitudes, required this.waveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    if (amplitudes.isEmpty) return;

    final middleY = size.height / 2;
    final barWidth = size.width / amplitudes.length;

    const double minDb = -50.0;
    const double maxDb = 0.0;
    const double dbRange = maxDb - minDb;

    for (int i = 0; i < amplitudes.length; i++) {
      final double db = amplitudes[i].clamp(minDb, maxDb);

      final double normalized = (db - minDb) / dbRange;

      final double barHeight =
          (normalized * size.height * 0.9) + (size.height * 0.1);

      final startX = i * barWidth;

      canvas.drawLine(
        Offset(startX, middleY - barHeight / 2),
        Offset(startX, middleY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return true;
  }
}

class AudioRecorderWidget extends StatefulWidget {
  final void Function(String path) onStop;
  final VoidCallback onCancel;

  const AudioRecorderWidget({
    super.key,
    required this.onStop,
    required this.onCancel,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  List<double> _amplitudes = [];

  static const Duration _maxDuration = Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final appDocumentsDir = await getApplicationDocumentsDirectory();

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'audio_report_$timestamp.m4a';
        final filePath = p.join(appDocumentsDir.path, fileName);

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 64000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        if (!mounted) return;
        setState(() {
          _isRecording = true;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          final newDuration = _recordDuration + const Duration(seconds: 1);

          if (newDuration >= _maxDuration) {
            _stopRecording();
          } else {
            if (mounted) {
              setState(() {
                _recordDuration = newDuration;
              });
            }
          }
        });

        _amplitudeSub = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 100))
            .listen((amp) {
              if (mounted) {
                setState(() {
                  _amplitudes.add(amp.current);
                  if (_amplitudes.length > 50) {
                    _amplitudes.removeAt(0);
                  }
                });
              }
            });
      }
    } catch (e) {
      print('Error al iniciar la grabación: $e');
      if (mounted) {
        widget.onCancel();
      }
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();

    if (path != null) {
      if (mounted) widget.onStop(path);
    } else {
      if (mounted) widget.onCancel();
    }

    if (mounted) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _pauseRecording() async {
    _timer?.cancel();
    await _audioRecorder.pause();
    if (mounted) {
      setState(() {
        _isPaused = true;
      });
    }
  }

  Future<void> _resumeRecording() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newDuration = _recordDuration + const Duration(seconds: 1);
      if (newDuration >= _maxDuration) {
        _stopRecording();
      } else {
        if (mounted) {
          setState(() {
            _recordDuration = newDuration;
          });
        }
      }
    });
    await _audioRecorder.resume();
    if (mounted) {
      setState(() {
        _isPaused = false;
      });
    }
  }

  Future<void> _cancelRecording() async {
    await _pauseRecording();

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ConfirmDialog(
          title: "Descartar Grabación",
          message: "¿Estás seguro de que quieres cancelar esta grabación?",
          confirmText: "Descartar",
          cancelText: "Continuar",
          onConfirm: () async {
            await _audioRecorder.stop();
            if (mounted) {
              widget.onCancel();
            }
          },
        );
      },
    ).then((_) {
      if (mounted) {
        _resumeRecording();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final bool isApproachingLimit =
        _maxDuration.inSeconds - _recordDuration.inSeconds <= 10;
    final timerColor = isApproachingLimit ? colors.error : colors.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface.withAlpha(242), // 0.95 opacity
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withAlpha(128)), // 0.5 opacity
      ),
      // --- CAMBIO PRINCIPAL: Row -> Column ---
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '${_formatDuration(_recordDuration)} / ${_formatDuration(_maxDuration)}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: timerColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomPaint(
                  size: const Size(double.infinity, 30),
                  painter: WaveformPainter(
                    amplitudes: _amplitudes,
                    waveColor: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.delete_forever, color: colors.error, size: 30),
                onPressed: _cancelRecording,
              ),
              IconButton(
                icon: Icon(
                  _isPaused ? Icons.mic : Icons.pause,
                  color: colors.primary,
                  size: 35,
                ),
                onPressed: _isPaused ? _resumeRecording : _pauseRecording,
              ),
              FloatingActionButton(
                mini: true,
                elevation: 0,
                backgroundColor: colors.tertiary,
                onPressed: _stopRecording,
                child: const Icon(Icons.check, color: Colors.white, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
