class AudioLoader implements Runnable {
    PApplet p;
    String filepath;
    SoundFile soundtrack;

  AudioLoader(PApplet p, String filepath) {
    this.p = p;
    this.filepath = filepath;
  }


  public void run() {
    soundtrack = new SoundFile(p, filepath);
    soundtrack.amp(0.3); // Set volume to 0 to prevent audio from playing immediately
    soundtrack.loop(); // Start loading the audio file asynchronously
  }
}
