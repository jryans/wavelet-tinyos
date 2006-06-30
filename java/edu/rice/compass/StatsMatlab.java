/**
 * MATLAB uses this class to import stats data.
 */
package edu.rice.compass;

import java.io.*;

import com.thoughtworks.xstream.XStream;

public class StatsMatlab {

	private static XStream xs = new XStream();
	
	private StatsMatlab() {}

	public static Object[][] loadStats(String subdir) {
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\" + subdir;
		File dir = new File(path);
		if (dir.exists()) {
			File[] files = dir.listFiles(XmlFilter.filter);
			Object[][] results = new Object[files.length][2];
			for (int i = 0; i < files.length; i++) {
				results[i][0] = files[i].getName();
				try {
					FileInputStream fs = new FileInputStream(files[i]);
					results[i][1] = xs.fromXML(fs);
					fs.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return results;
		}
		return null;
	}
}

class XmlFilter implements FilenameFilter {
	
	public static XmlFilter filter = new XmlFilter();
	
	private XmlFilter() {}

	public boolean accept(File file, String name) {
		if (name.endsWith(".xml"))
			return true;
		return false;
	}
	
}