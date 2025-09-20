import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_notifier.g.dart';

class AudioPlayerState {
  final bool isPlaying;
  final String? currentUrl;
  final Duration? position;
  final Duration? duration;

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

    // 🔹 Estado de reproducción
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (state.isPlaying != isPlaying) {
        state = state.copyWith(isPlaying: isPlaying);
      }

      if (processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false);
      }
    });

    // 🔹 Escuchar posición
    _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    // 🔹 Escuchar duración
    _player.durationStream.listen((dur) {
      if (dur != null) {
        state = state.copyWith(duration: dur);
      }
    });

    ref.onDispose(() {
      _player.dispose();
    });

    return AudioPlayerState();
  }

  /// 🔹 Nuevo método para cargar metadatos (duración) sin reproducir
  Future<void> load(String url) async {
    try {
      if (state.currentUrl != url) {
        final duration = await _player.setUrl(url);
        state = state.copyWith(
          currentUrl: url,
          duration: duration ?? Duration.zero,
        );
      }
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> play(String url) async {
    try {
      if (state.currentUrl != url) {
        final duration = await _player.setUrl(url);
        state = state.copyWith(
          currentUrl: url,
          duration: duration ?? Duration.zero,
        );
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
    state = state.copyWith(isPlaying: false);
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(isPlaying: false, currentUrl: null);
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
}
