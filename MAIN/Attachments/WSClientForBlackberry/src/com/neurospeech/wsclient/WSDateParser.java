package com.neurospeech.wsclient;

import java.util.Calendar;
import java.util.Date;
import java.util.Vector;

import net.rim.device.api.i18n.SimpleDateFormat;

public class WSDateParser {
	
	public static Date parse(String val){
		
		//yyyy-MM-dd'T'HH:mm:ss'Z'
		
		// remove z...
		if(val.endsWith("z") || val.endsWith("Z"))
			val = val.substring(0,val.length()-1);
		
		if(val.equalsIgnoreCase("0001-01-01T00:00:00"))
			return null;
		
		String[] tokens = split(val,'T');
		
		String datePart = tokens[0];
		String timePart = tokens[1];
		
		String[] dateParts = split(datePart,'-');
		String[] timeParts = split(timePart,':');
		
		int year = Integer.parseInt(dateParts[0]);
		int month = Integer.parseInt(dateParts[1]);
		int day = Integer.parseInt(dateParts[2]);
		
		int hour = Integer.parseInt(timeParts[0]);
		int min = Integer.parseInt(timeParts[1]);

        String millParts[] = split(timeParts[2], '.');
        
        int sec = Integer.parseInt(millParts[0]);
        
        int mill = 0;
        
        if(millParts.length == 2)
            mill = Integer.parseInt(millParts[1]);
        
        Calendar cl = Calendar.getInstance();
        cl.set(Calendar.YEAR, year);
        // java considers 0 as January
        cl.set(Calendar.MONTH, month-1);
        cl.set(Calendar.DAY_OF_MONTH,day);
        cl.set(Calendar.HOUR_OF_DAY, hour);
        cl.set(Calendar.MINUTE, min);
        cl.set(Calendar.SECOND,sec);
        cl.set(Calendar.MILLISECOND, mill);
		
		return cl.getTime();
	}
	
	public static final String[] split(final String data, final char splitChar){
		return split(data,splitChar,false);
	}
	public static final String[] split(final String data, final char splitChar, final boolean allowEmpty)
    {
        Vector v = new Vector();

        int indexStart = 0;
        int indexEnd = data.indexOf(splitChar);
        if (indexEnd != -1)
        {
            while (indexEnd != -1)
            {
                String s = data.substring(indexStart, indexEnd);
                if (allowEmpty || s.length() > 0)
                {
                    v.addElement(s);
                }
                indexStart = indexEnd + 1;
                indexEnd = data.indexOf(splitChar, indexStart);
            }

            if (indexStart != data.length())
            {
                // Add the rest of the string
                String s = data.substring(indexStart);
                if (allowEmpty || s.length() > 0)
                {
                    v.addElement(s);
                }
            }
        }
        else
        {
            if (allowEmpty || data.length() > 0)
            {
                v.addElement(data);
            }
        }

        String[] result = new String[v.size()];
        v.copyInto(result);
        return result;
	}
	
	public static String toString(Date val){
		
		if(val==null)
			return "0001-01-01T00:00:00";
		
		Calendar c = Calendar.getInstance();
		c.setTime(val);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
		return sdf.format(c);
		/*return 
			String.format("%1d4-%2d2-%3d2T%4d2:%5d2:%6d2Z", 
					c.get(Calendar.YEAR),
					c.get(Calendar.YEAR),
					c.get(Calendar.YEAR),
					c.get(Calendar.YEAR),
					c.get(Calendar.YEAR),
					c.get(Calendar.YEAR));*/
	}
	
	
}
