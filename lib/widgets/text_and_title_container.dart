import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/audio_player_notifier.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';

class TextAndTitleContainer extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final bool isImportant;

  const TextAndTitleContainer({
    super.key,
    this.title = '',
    required this.description,
    this.isImportant = true,
  });

  @override
  ConsumerState<TextAndTitleContainer> createState() =>
      _TextAndTitleContainerState();
}

class _TextAndTitleContainerState extends ConsumerState<TextAndTitleContainer> {
  @override
  Widget build(BuildContext context) {
    Color colorBackground = Colors.transparent;

    if (widget.isImportant) {
      colorBackground = const Color.fromARGB(41, 252, 6, 6);
    }

    if (widget.isImportant && widget.title == 'Nota Brigadista') {
      colorBackground = const Color.fromARGB(255, 223, 222, 222);
    }

    if (widget.title == 'Audio') {
      final audioState = ref.watch(audioPlayerNotifierProvider);
      final audioUrlAsync = ref.watch(getRecordProvider(widget.description));

      return audioUrlAsync.when(
        data: (url) {
          final isPlaying =
              audioState.isPlaying && audioState.currentUrl == url;

          return GestureDetector(
            onTap: () async {
              final audioNotifier = ref.read(
                audioPlayerNotifierProvider.notifier,
              );

              if (isPlaying) {
                await audioNotifier.pause();
              } else {
                await audioNotifier.play(url);
              }
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: widget.isImportant ? const EdgeInsets.all(10) : null,
              child: descriptionRecord(isPlaying),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Text('Error cargando audio'),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: widget.isImportant ? const EdgeInsets.all(10) : null,
      child: descriptionText(),
    );
  }

  Row descriptionRecord(bool isPlaying) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Presiona para escuchar',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 40),
      ],
    );
  }

  Column descriptionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Text(
          widget.description,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
