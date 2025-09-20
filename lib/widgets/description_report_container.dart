import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/audio_player_notifier.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';

class DescriptionReportContainer extends ConsumerWidget {
  final String description;
  final String audio;
  final String title;
  final int idReport;
  final bool isImportant;

  const DescriptionReportContainer({
    super.key,
    this.description = '',
    this.title = '',
    this.audio = '',
    this.idReport = 0,
    this.isImportant = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Color colorBackground = Colors.transparent;

    if (isImportant) {
      colorBackground = scheme.error.withValues(alpha: 0.1);
    }

    if (isImportant && title == 'Nota Brigadista') {
      colorBackground = scheme.primary.withValues(alpha: 0.1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descripción',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

        // 🔹 Bloque de audio
        if (audio.isNotEmpty)
          Consumer(
            builder: (context, ref, _) {
              final audioState = ref.watch(audioPlayerNotifierProvider);
              final audioNotifier = ref.read(
                audioPlayerNotifierProvider.notifier,
              );

              final audioUrlAsync = ref.watch(
                getRecordProvider(idReport, description),
              );

              return audioUrlAsync.when(
                data: (url) {
                  final isPlaying =
                      audioState.isPlaying && audioState.currentUrl == url;

                  final position = audioState.position;
                  final duration = audioState.duration;

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Audio",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            // 🔹 Slider a la izquierda
                            Expanded(
                              child: Column(
                                children: [
                                  Slider(
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    value: position.inSeconds
                                        .clamp(0, duration.inSeconds)
                                        .toDouble(),
                                    activeColor: scheme.primary,
                                    inactiveColor: scheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    onChanged: (value) {
                                      audioNotifier.seek(
                                        Duration(seconds: value.toInt()),
                                      );
                                    },
                                  ),
                                  // tiempos debajo del slider
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(position),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(duration),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // 🔹 Botón de play/pause
                            GestureDetector(
                              onTap: () async {
                                if (isPlaying) {
                                  await audioNotifier.pause();
                                } else {
                                  await audioNotifier.play(url);
                                }
                              },
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: scheme.primary,
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Text(
                  'Error cargando audio',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.error,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  /// 🔹 Formato mm:ss
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
