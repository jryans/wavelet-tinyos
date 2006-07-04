/**
 * Simple functions for sending messages to a specific mote.
 * @author Ryan Stinnett
 */
package edu.rice.compass.comm;

import java.io.*;

public class Mote {
	
	protected int id;
	
	public Mote(int mID) {
		id = mID;
	}
	
	public int getID() {
		return id;
	}
	
	public static void sendPack(BroadcastPack pack) throws IOException {
		MoteCom.singleton.sendPack(pack);
	}
	
	public void sendPack(UnicastPack pack) throws IOException {
		MoteCom.singleton.sendPack(pack, id);
	}

}
