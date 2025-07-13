import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (state.isPlaying != isPlaying) {
        state = state.copyWith(isPlaying: isPlaying);
      }

      if (processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false);
      }
    });

    ref.onDispose(() {
      _player.dispose();
    });

    return AudioPlayerState();
  }

  Future<void> play(String url) async {
    if (_player.playing && state.currentUrl == url) {
      await pause();
      return;
    }

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
    state = state.copyWith(isPlaying: false, currentUrl: null);
  }
}
