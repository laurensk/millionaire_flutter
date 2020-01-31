import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundUtils {

  static AudioPlayer advancedPlayer;

  static void playSound(String sound) async {
    advancedPlayer = await AudioCache().play(sound);
  }


}

class Sounds {
  static String audiencePhone = "sounds/audiencePhone.mp3";
  static String correct = "sounds/correct.mp3";
  static String fiftyFifty = "sounds/fiftyFifty.mp3";
  static String incorrect = "sounds/incorrect.mp3";
  static String question = "sounds/question.mp3";
  static String result = "sounds/result.mp3";
  static String appstart = "sounds/wwm_appstart.mp3";
}