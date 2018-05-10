import javax.sound.midi.*;

class PianoSynthJava{
  
  MidiChannel c;
  Synthesizer synth = null;
  MidiChannel[] channels;
    
  public PianoSynthJava(){
    try{
      synth = MidiSystem.getSynthesizer();
      synth.open();
    }catch (MidiUnavailableException e) {
      e.printStackTrace();
    }
    channels = synth.getChannels();
    try{
      Thread.sleep(1000);
    }catch(InterruptedException e){
    }
    
    c = channels[0];
    
    c.programChange(0,0);
  }
  
  public void noteOn(int n, int v){
    c.noteOn(n,v);
  }
  
  public void noteOff(int n){
    c.noteOff(n);
  }
}
