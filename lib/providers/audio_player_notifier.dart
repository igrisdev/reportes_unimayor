// 1. Importa las anotaciones y el part file
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'audio_player_notifier.g.dart';

class AudioPlayerState {
  final bool isPlaying;
  final String? currentUrl;

  AudioPlayerState({this.isPlaying = false, this.currentUrl});

  AudioPlayerState copyWith({bool? isPlaying, String? currentUrl}) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentUrl: currentUrl ?? this.currentUrl,
    );
  }
}

@riverpod
class AudioPlayerNotifier extends _$AudioPlayerNotifier {
  late AudioPlayer _player;

  @override
  AudioPlayerState build() {
    _player = AudioPlayer();

    _player.playerStateStream.listen((playerState) {
      if (state.isPlaying &&
          playerState.processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false, currentUrl: null);
      }
    });

    ref.onDispose(() {
      _player.dispose();
    });

    return AudioPlayerState();
  }

  Future<void> play(String url) async {
    if (state.currentUrl == url && _player.playing) {
      await pause();
      return;
    }

    state = state.copyWith(isPlaying: true, currentUrl: url);
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      state = state.copyWith(isPlaying: false, currentUrl: null);
      print("Error playing audio: $e");
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
}
