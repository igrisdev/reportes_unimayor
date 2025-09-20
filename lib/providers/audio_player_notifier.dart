import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Estado del reproductor
class AudioPlayerState {
  final bool isPlaying;
  final String? currentUrl;
  final Duration position;
  final Duration duration;

  AudioPlayerState({
    this.isPlaying = false,
    this.currentUrl,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    String? currentUrl,
    Duration? position,
    Duration? duration,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentUrl: currentUrl ?? this.currentUrl,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

/// Notifier del reproductor
class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _player;

  AudioPlayerNotifier() : _player = AudioPlayer(), super(AudioPlayerState()) {
    // 🔹 Escucha la posición
    _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    // 🔹 Escucha la duración (siempre actualiza aunque sea null → Duration.zero)
    _player.durationStream.listen((dur) {
      state = state.copyWith(duration: dur ?? Duration.zero);
    });

    // 🔹 Escucha el estado de reproducción
    _player.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final processing = playerState.processingState;

      if (processing == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }

      state = state.copyWith(isPlaying: playing);
    });
  }

  /// Cargar audio (con duración inicial)
  Future<void> load(String url) async {
    try {
      if (state.currentUrl != url) {
        await _player.setUrl(url);

        // 🔹 Inicializa con la duración actual si está disponible
        final dur = _player.duration ?? Duration.zero;

        state = state.copyWith(
          currentUrl: url,
          duration: dur,
          position: Duration.zero,
        );
      }
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  /// Reproducir
  Future<void> play(String url) async {
    if (state.currentUrl != url) {
      await load(url);
    }
    await _player.play();
  }

  /// Pausar
  Future<void> pause() async {
    await _player.pause();
  }

  /// Mover a una posición
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Liberar recursos
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

/// Provider global
final audioPlayerNotifierProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
      (ref) => AudioPlayerNotifier(),
    );
