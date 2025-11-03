import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/audio_player_notifier.dart';

class AudioPlayerWidget extends ConsumerStatefulWidget {
  final String filePath;
  final VoidCallback onDeleted;
  final AudioPlayerNotifier audioNotifier;

  const AudioPlayerWidget({
    super.key,
    required this.filePath,
    required this.onDeleted,
    required this.audioNotifier,
  });

  @override
  ConsumerState<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends ConsumerState<AudioPlayerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.audioNotifier.load(widget.filePath);
    });
  }

  @override
  void dispose() {
    widget.audioNotifier.pause();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final audioState = ref.watch(audioPlayerNotifierProvider);
    final audioNotifier = ref.watch(audioPlayerNotifierProvider.notifier);

    final isPlayingThisAudio =
        audioState.isPlaying && audioState.currentUrl == widget.filePath;
    final duration = audioState.currentUrl == widget.filePath
        ? audioState.duration
        : Duration.zero;
    final position = audioState.currentUrl == widget.filePath
        ? audioState.position
        : Duration.zero;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.tertiary.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: colors.error, size: 30),
            onPressed: widget.onDeleted,
          ),
          IconButton(
            icon: Icon(
              isPlayingThisAudio
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: colors.tertiary,
              size: 30,
            ),
            onPressed: () {
              if (isPlayingThisAudio) {
                audioNotifier.pause();
              } else {
                audioNotifier.play(widget.filePath);
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6.0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12.0,
                    ),
                    trackHeight: 2.0,
                  ),
                  child: Slider(
                    value: position.inMilliseconds.toDouble().clamp(
                      0.0,
                      duration.inMilliseconds.toDouble(),
                    ),
                    max: duration.inMilliseconds > 0
                        ? duration.inMilliseconds.toDouble()
                        : 1.0,
                    onChanged: (value) {
                      audioNotifier.seek(Duration(milliseconds: value.toInt()));
                    },
                    activeColor: colors.tertiary,
                    inactiveColor: colors.tertiary.withOpacity(0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colors.onSurface,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
