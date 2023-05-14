class AudioLoadingTask implements Runnable {
  @Override
  public void run() {
    soundtrack = new SoundFile(p, "./data/soundtrack.mp3");
    soundtrack.amp(0.3); // Set volume to 0 to prevent audio from playing immediately
    soundtrack.loop(); // Start loading the audio file asynchronously
  }
}
