import 'dart:io';

import 'package:system_audio_level/system_audio_level.dart';

void main(List<String> arguments) {
  SystemAudioLevel.initialize();
  while (true) {
    sleep(const Duration(milliseconds: 100));
    print("${SystemAudioLevel.getAmplitude() / SystemAudioLevel.getVolume()}");
  }
  SystemAudioLevel.dispose();
}
