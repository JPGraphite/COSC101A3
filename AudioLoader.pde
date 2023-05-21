
/*
    Class: AudioLoader

    loads and plays SoundFiles asynchronously

    Properties:
      - p: The PApplet instance (processing.core.PApplet)
      - filepath: The filepath of the SoundFile (String)
      - audio: The loaded SoundFile (processing.sound.SoundFile)
      - playType: The type of playback ("loop" or "play") (String)
      - amp: The amplification of the audio (float)
    Methods:
      - AudioLoader(p, filepath, amp, playType): Constructor for the AudioLoader class
      - run(): Runs the audio loading and playback
*/

class AudioLoader implements Runnable {
    PApplet p;
    String filepath;
    SoundFile audio;
    String playType;
    float amp;

  AudioLoader(PApplet p, String filepath, float amp, String playType) {
    this.p = p;
    this.filepath = filepath;
    this.amp = amp;
    this.playType = playType;
  }

  /*
    run();
    Runs the audio loading and playback, allowing for sound and playtype attributes
  */
  void run() {
    audio = new SoundFile(p, filepath);
    audio.amp(amp);
    if (playType.equals("loop")) {
      audio.loop();
    } else {
      audio.play();
    }

  }

}
