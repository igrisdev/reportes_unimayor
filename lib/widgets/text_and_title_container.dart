import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
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
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Future<void> _reproducirAudio() async {
    if (audioPlayer.playing) {
      await audioPlayer.stop();
    }

    try {
      final localPath = await ref.read(
        getRecordProvider(widget.description).future,
      );

      await audioPlayer.setUrl(localPath);
      audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      // print('Error reproduciendo audio: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

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
      return GestureDetector(
        onTap: () {
          if (isPlaying) {
            audioPlayer.pause();
            setState(() {
              isPlaying = false;
            });
          } else {
            _reproducirAudio();
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: widget.isImportant ? const EdgeInsets.all(10) : null,
          child: descriptionRecord(),
        ),
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

  Row descriptionRecord() {
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
