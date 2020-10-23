package com.neurospeech.wsclient;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import net.rim.device.api.xml.parsers.DocumentBuilder;
import net.rim.device.api.xml.parsers.DocumentBuilderFactory;

public class XmlDocumentBuilder {

	public static Document createDocument() throws Exception
	{
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		dbf.setIgnoringComments(true);
		dbf.setIgnoringElementContentWhitespace(true);
		dbf.setCoalescing(true);
		
		Document doc = dbf.newDocumentBuilder().newDocument();
		doc.normalize();
		return doc;
	}
	
	public static Document parseDocument(String doc) throws Exception
	{
		ByteArrayInputStream sr = new ByteArrayInputStream(doc.getBytes());
		return parseDocument(sr);
	}

	public static Document parseDocument(InputStream sr) throws Exception {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		dbf.setIgnoringComments(true);
		dbf.setIgnoringElementContentWhitespace(true);
		dbf.setCoalescing(true);
		//dbf.setValidating(false);
		DocumentBuilder db = dbf.newDocumentBuilder();
		db.setAllowUndefinedNamespaces(true);
		Document xdoc = db.parse(new InputSource(sr));
		xdoc.normalize();
		return xdoc;
	}
	
	public static Element createElement(Document doc, String name){
		int i = name.indexOf(':');
		if(i==-1)
			return doc.createElement(name);
		String prefix = name.substring(0,i);
		name =  name.substring(i+1);
		Element e = doc.createElement(name);
		e.setPrefix(prefix);
		return e;
	}
	
}
