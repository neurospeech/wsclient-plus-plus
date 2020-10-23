package com.neurospeech.wsclient;

import java.io.*;
import java.net.*;
import java.util.*;


public class HttpWebService {
	
//	private int _socketTimeout = 0;
//	public void setSocketTimeout(int socketTimeout) {
//		this._socketTimeout = socketTimeout;
//	}
//
//	public int getSocketTimeout() {
//		return _socketTimeout;
//	}
//
//	private int _connectionTimeout = 0;
//	public void setConnectionTimeout(int connectionTimeout) {
//		this._connectionTimeout = connectionTimeout;
//	}
//
//	public int getConnectionTimeout() {
//		return _connectionTimeout;
//	}
//	
	
	
	@SuppressWarnings("rawtypes")
	private Hashtable _httpHeaders = null;
	
	
	@SuppressWarnings("rawtypes")
	public void setHttpHeaders(Hashtable httpHeaders) {
		this._httpHeaders = httpHeaders;
	}

	@SuppressWarnings("rawtypes")
	public Hashtable getHttpHeaders() {
		return _httpHeaders;
	}
	
	
	protected HttpURLConnection getHttpClient(String url) throws Exception{
		URL u = new URL(url);
		return (HttpURLConnection)u.openConnection();
	}
	
	public void setIgnoreCertificateErrors(boolean ignoreCertificateErrors) {
		this.ignoreCertificateErrors = ignoreCertificateErrors;
	}

	public boolean getIgnoreCertificateErrors() {
		return ignoreCertificateErrors;
	}

	private boolean ignoreCertificateErrors = false;
	
	
	@SuppressWarnings("rawtypes")
	protected void setHeaders(SoapRequest request, Hashtable headers)
	{
		
	}

	protected String getUserAgent(){
		return "Profile/MIDP-2.0 Configuration/CLDC-1.0";
	}	
	
	protected String getContentType(String action)
	{
		return "";
	}
	
	protected InputStream postWS(SoapRequest request, String xml) throws Exception{

		String url = request.serviceUrl;
		String contentType = getContentType(request.soapAction);
		String userAgent = request.userAgent;
		
		HttpURLConnection client = getHttpClient(url);

		client.setRequestMethod("POST");
		client.addRequestProperty("Content-Type", contentType);
		client.setDoOutput(true);
		request.rawHttpRequest = url + "\r\n";
		request.rawHttpRequest += "Content-Type: " + contentType + "\r\n";
		
		if(userAgent!=null){
			request.rawHttpRequest += "User-Agent:" + userAgent + "\r\n";
			client.addRequestProperty("User-Agent", userAgent);
		}
		
		if(request.isSoapActionRequired){
			client.addRequestProperty("SOAPAction", request.soapAction);
			request.rawHttpRequest += "SOAPAction: " + request.soapAction + "\r\n";
		}
		
		request.rawHttpRequest += "\r\n";
		request.rawHttpRequest += xml;
		
		Hashtable headers = new Hashtable();
		
		setHeaders(request, headers);
		
		Enumeration en = headers.keys();
		while(en.hasMoreElements()){
			String key = (String)en.nextElement();
			client.setRequestProperty(key, (String)headers.get(key));
		}
		
		if(this._httpHeaders!=null){
			 Enumeration enKey = _httpHeaders.keys();
			 while(enKey.hasMoreElements()){
				 String k = (String)enKey.nextElement();
				 String v = (String)_httpHeaders.get(k);
				 if(v!=null){
					 client.setRequestProperty(k,v);
				 }
			 }
		}
		
		
		OutputStream out = client.getOutputStream();
		out.write(xml.getBytes());
		out.flush();
		out.close();
		
		int code = client.getResponseCode();
		if(code != 200){
			InputStream ins = client.getErrorStream();
			byte[] buff = new byte[5120];
			String text = "";
			try{
			do{
				int count = ins.read(buff);
				if(count==0)
					break;
				text += new String(buff,0,count);
			}while(true);
			}catch(Exception ex){
				
			}
			throw new IOException("HTTP response code: " + code + "\r\n" + text);
		}
		
		InputStream stream = client.getInputStream();
		return stream;
		
	}
	

}
