import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportes_unimayor/providers/audio_player_notifier.dart';
import 'package:reportes_unimayor/providers/report_providers.dart';

class TextAndTitleContainer extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final int idReport;
  final bool isImportant;

  const TextAndTitleContainer({
    super.key,
    this.title = '',
    required this.description,
    this.idReport = 0,
    this.isImportant = true,
  });

  @override
  ConsumerState<TextAndTitleContainer> createState() =>
      _TextAndTitleContainerState();
}

class _TextAndTitleContainerState extends ConsumerState<TextAndTitleContainer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // 🎨 Colores base del contenedor
    Color colorBackground = Colors.transparent;

    if (widget.isImportant) {
      colorBackground = scheme.error.withOpacity(0.15); // fondo de error suave
    }

    if (widget.isImportant && widget.title == 'Nota Brigadista') {
      colorBackground = scheme.surface; // fondo alternativo (neutral)
    }

    // 🎵 Caso especial: Audio
    if (widget.title == 'Audio') {
      final audioState = ref.watch(audioPlayerNotifierProvider);
      final audioUrlAsync = ref.watch(
        getRecordProvider(widget.idReport, widget.description),
      );

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
              child: descriptionRecord(isPlaying, scheme),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Text(
          'Error cargando audio',
          style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
        ),
      );
    }

    // 📝 Texto normal
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: widget.isImportant ? const EdgeInsets.all(10) : null,
      child: descriptionText(scheme),
    );
  }

  Row descriptionRecord(bool isPlaying, ColorScheme scheme) {
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
                  color: scheme.onSurface, // título
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Presiona para escuchar',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurfaceVariant, // subtítulo
                ),
              ),
            ],
          ),
        ),
        Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          size: 40,
          color: scheme.primary, // ícono según tema
        ),
      ],
    );
  }

  Column descriptionText(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface, // texto principal
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.description,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: scheme.onSurfaceVariant, // texto secundario
          ),
        ),
      ],
    );
  }
}
