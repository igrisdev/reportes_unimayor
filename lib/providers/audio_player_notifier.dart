import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_notifier.g.dart';

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

@riverpod
class AudioPlayerNotifier extends _$AudioPlayerNotifier {
  late AudioPlayer _player;

  @override
  AudioPlayerState build() {
    _player = AudioPlayer();

    // 🔹 Escucha cambios en el estado del reproductor
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (state.isPlaying != isPlaying) {
        state = state.copyWith(isPlaying: isPlaying);
      }

      if (processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false, position: Duration.zero);
      }
    });

    // 🔹 Escucha duración del audio
    _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });

    // 🔹 Escucha posición actual
    _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    ref.onDispose(() {
      _player.dispose();
    });

    return AudioPlayerState();
  }

  Future<void> play(String url) async {
    try {
      if (state.currentUrl != url) {
        await _player.setUrl(url);
        state = state.copyWith(currentUrl: url);
      }

      if (_player.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }

      _player.play();
    } catch (e) {
      print("Error playing audio: $e");
      state = state.copyWith(isPlaying: false, currentUrl: null);
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(
      isPlaying: false,
      currentUrl: null,
      position: Duration.zero,
      duration: Duration.zero,
    );
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
}
