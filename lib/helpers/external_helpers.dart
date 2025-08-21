import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

enum SoundType { archive, notify, completed }

class ExternalHelpers {
  static final AudioPlayer _player = AudioPlayer();

  /// Map enum to asset path
  static const Map<SoundType, String> _soundAssets = {
    SoundType.archive: 'archived.mp3',
    SoundType.notify: 'notification_sound.mp3',
    SoundType.completed: 'completed.mp3',
  };

  /// Play sound by type
  static Future<void> playSound(SoundType type) async {
    final asset = _soundAssets[type];
    if (asset != null) {
      await _player.play(AssetSource(asset));
    }
  }
}
