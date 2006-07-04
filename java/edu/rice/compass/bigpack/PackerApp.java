package edu.rice.compass.bigpack;

public interface PackerApp {
	
  public BigPack buildPack(int mote);
  
  public void packerDone(int mote);
	
	public void unpackerDone(BigPack msg, int mote);

}
