package edu.rice.compass.bigpack;

import java.io.*;
import edu.rice.compass.comm.*;

public interface PackerHost {
	
	public void sendPack(UnicastPack pack) throws IOException;
	
	public int getID();
	
	public BigPack buildPack(short type);
	
	public void packerDone(short type);
	
	public void unpackerDone(BigPack msg);
	
}