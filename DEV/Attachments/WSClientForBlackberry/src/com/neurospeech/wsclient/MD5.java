package com.neurospeech.wsclient;

import net.rim.device.api.crypto.MD5Digest;
import net.rim.device.api.i18n.MessageFormat;

public class MD5 {

	public static String doMD5(String text)
	{
		try{
			MD5Digest md5 = new MD5Digest();
			StringBuffer sb = new StringBuffer();
			md5.update(text.getBytes("UTF-8"));
			byte[] bytes = md5.getDigest(true);
			for(int i =0 ; i<bytes.length ;i++)
			{
				byte b = bytes[i];
				sb.append(MessageFormat.format("%02x",new Object[] { new Byte(b) }));
			}
			return sb.toString();
		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return "";
	}
	
}
