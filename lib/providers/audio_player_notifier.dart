import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
      (ref) => AudioPlayerNotifier(),
    );

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

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerNotifier() : super(AudioPlayerState()) {
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false);
      }
    });
  }

  Future<void> play(String url) async {
    if (state.currentUrl == url && _player.playing) {
      await pause();
      return;
    }

    await _player.stop();
    await _player.setUrl(url);
    state = state.copyWith(isPlaying: true, currentUrl: url); // 👈 esto primero
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(isPlaying: false, currentUrl: null);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
