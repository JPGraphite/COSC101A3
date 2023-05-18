/*
  AudioLoader class loads and plays SoundFiles
  It has been implemented so we can asynchronously load in the soundtrack
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
