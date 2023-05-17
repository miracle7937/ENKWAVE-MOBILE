import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

class MusicService {
  AudioPlayer audioPlayer = AudioPlayer();

  void playAudioOnce() async {
    try {
      audioPlayer
          .setSource(AssetSource("play_sound/transfer_alert.mp3"))
          .then((value) {
        audioPlayer.play(AssetSource('play_sound/transfer_alert.mp3'));
      });
      audioPlayer.onPlayerComplete.first.then((_) {
        stopAudio();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void stopAudio() async {
    await audioPlayer.stop();
  }
}
