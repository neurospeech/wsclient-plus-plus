package com.neurospeech.wsclient;


import java.io.*;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import org.w3c.dom.*;

public class SoapWebService extends HttpWebService {
	
	public static String globalBaseUrl = null;
	
	public static void setGlobalBaseUrl(String gurl){
		globalBaseUrl = gurl;
	}
	
	private String _baseUrl = null;
	public String getBaseUrl(){
		return _baseUrl;
	}
	public void setBaseUrl(String b){
		_baseUrl = b;
	}
	
	
	
	private String _url = null;
	public String getUrl()
	{
		return _url;
	}
	public void setUrl(String url)
	{
		_url = url;
	}
	
	protected void executeAsync(Runnable r){
		Thread th = new Thread(r);
		th.start();
	}
	
	protected String getNamespaces(){
		return "";
	}
	
	protected void appendNamespaces(Element e){
		e.setAttribute("", "");
	}
	
	public void setSecurity(WSSecurity security) {
		_Security = security;
	}
	public WSSecurity getSecurity() {
		return _Security;
	}

	private WSSecurity _Security;
	
	protected SoapRequest buildSoapRequest(String action) throws Exception
	{
		SoapRequest req = new SoapRequest();
		req.soapAction = action;
		
		String nslist = getNamespaces();
		
		if(_Security!=null){
			//nslist += "xmlns:a=\"http://www.w3.org/2005/08/addressing\" \r\n";
			//nslist += "xmlns:u=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" \r\n" ;
			//nslist += "xmlns:o=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" \r\n" ;
		}
		
		String soapDoc  = "<?xml version='1.0' encoding='utf-8'?>" +
						"<soap:Envelope "+ nslist + "><soap:Header/><soap:Body/></soap:Envelope>";
		Document doc = XmlDocumentBuilder.parseDocument(soapDoc);
		req.document = doc;
		req.root = doc.getDocumentElement();
		appendNamespaces(req.root);
		req.isSoapActionRequired= this.IsSoapActionRequired();
		req.header = WSHelper.getElementNS(req.root, getSoapEnvelopeNS(), "Header");
		
		if(_Security!=null){
			
			
			Element root = req.root;
			
			root.setAttribute("xmlns:a", "http://www.w3.org/2005/08/addressing");
			root.setAttribute("xmlns:u", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd");
			root.setAttribute("xmlns:o", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd");
			
			//Date d = new Date();
			
			
			
			WSHelper ws = new WSHelper(req.document);
			Element sec = ws.createElement("o:Security");
			req.header.appendChild(sec);
			
			ws.addChild(sec, "soap:mustUnderstand", "1", true);
			
//			Calendar c = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
//			Date d = c.getTime();
//			Element time = ws.createElement("u:Timestamp");
//			sec.appendChild(time);
//			
//			ws.addChild(time, "u:Id", "_0", true);
//			
//			ws.addChild(time, "u:Created", WSDateParser.toString(d) , false);
//			d = new Date(d.getTime() + 5000);
//			ws.addChild(time, "u:Expires", WSDateParser.toString(d) , false);
			
			Element token = ws.createElement("o:UsernameToken");
			sec.appendChild(token);
			
			ws.addChild(token, "u:Id", "the-uuid", true);
			ws.addChild(token, "o:Username", _Security.getUsername(), false);
			ws.addChild(token, "o:Password", _Security.getPassword(), false);
			
			ws.addChild(token, "o:Type", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText", true);
			
		}
		
		return req;
	}
	
	protected boolean IsSoapActionRequired() {
		return true;
	}
	
	
	protected String getServiceUrl(){
		if(_baseUrl!=null && _baseUrl.length()>0){
			return _baseUrl + _url;
		}
		if(globalBaseUrl!=null && globalBaseUrl.length()>0)
		{
			return globalBaseUrl + _url;
		}
		return _url;
	}
	
	protected SoapResponse getSoapResponse(SoapRequest request) throws Exception
	{
		request.serviceUrl = getServiceUrl();
		request.userAgent = getUserAgent();
		
		// build body...
		Element e = WSHelper.getElementNS(request.root, getSoapEnvelopeNS(), "Body");
		e.appendChild(request.method);
		
		/*if(request.header!=null){
			e = WSHelper.getElementNS(request.root, getSoapEnvelopeNS(), "Header");
			e.appendChild(request.header);
		}*/
		
		SoapResponse rs = postXML(request);
		
		// search for fault first...
		Element fault = WSHelper.getElementNS(rs.document, getSoapEnvelopeNS(), "Fault");
		if(fault!=null)	{
			String code = WSHelper.getString(fault, "faultcode", false);
			String text = WSHelper.getString(fault, "faultstring", false);
			SoapFaultException fe = new SoapFaultException(code, text, request.rawHttpRequest);
			throw fe;
		}
		
		rs.header = WSHelper.getElementNS(rs.document,getSoapEnvelopeNS(), "Header");
		rs.body = WSHelper.getElementNS(rs.document,getSoapEnvelopeNS(), "Body");
		return rs;
	}
	
	protected String getContentType(String action) {
		return "text/xml; charset=utf-8";
	}
	
	protected String getSoapEnvelopeNS(){
		return "http://schemas.xmlsoap.org/soap/envelope/";
	}
	
	SoapResponse postXML(SoapRequest request) throws Exception{
		
		SoapResponse sr = new SoapResponse();
		
		try{
			String text = WSHelper.getString(request.document);
			InputStream stream = postWS(request, text);
		
			
			java.io.ByteArrayOutputStream bos = new ByteArrayOutputStream();
			
			byte[] buff = new byte[5120];
			do{
				int count = stream.read(buff, 0, 5120);
				if(count<=0)
					break;
				bos.write(buff,0,count);
				
			}while(true);
			
			sr.httpResponse = new String(bos.toByteArray());
			
			ByteArrayInputStream bin = new ByteArrayInputStream(bos.toByteArray());
			
			try{
				bos.close();
			}catch(Exception ex){
				ex.printStackTrace();
			}
			Document d = XmlDocumentBuilder.parseDocument(bin);
			
			
			
			d.normalize();
			sr.document = d.getDocumentElement();
			
			
			try{
				stream.close();
			}catch (Exception ex){
				ex.printStackTrace();
			}
		}catch(Exception ex)
		{
			throw new SoapFaultException("Server Error", ex.toString(), sr.httpResponse);
		}
		return sr;
	}
	

}
