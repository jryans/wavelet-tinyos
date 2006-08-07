package edu.rice.compass.map;

import java.awt.*;
import java.io.*;

public interface IMoteNetwork {
	
	public void loadNetwork(File netConfig);
	
	public void loadStats(File statsDir);
	
	public void mapClicked(Point pt);

}
