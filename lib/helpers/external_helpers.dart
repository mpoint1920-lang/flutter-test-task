// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'package:todo_test_task/common/common.dart';

class ExternalHelpers {
  static final AudioPlayer _player = AudioPlayer();

  static const Map<SoundType, String> _soundAssets = {
    SoundType.archive: 'archived.mp3',
    SoundType.notify: 'notification_sound.mp3',
    SoundType.completed: 'completed.mp3',
  };

  static Future<void> playSound(SoundType type) async {
    final asset = _soundAssets[type];
    if (asset != null) {
      await _player.play(AssetSource(asset), volume: 5);
    }
  }
}
