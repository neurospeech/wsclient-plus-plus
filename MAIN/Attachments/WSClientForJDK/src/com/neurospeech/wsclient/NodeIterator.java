package com.neurospeech.wsclient;

import java.util.Iterator;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class NodeIterator implements Iterator<Element> {

	private NodeList list;
	private int start = 0;
	private int length = 0;
	
	public NodeIterator(NodeList nodeList)
	{
		list = nodeList;
		length = nodeList.getLength();
	}
	
	@Override
	public boolean hasNext() {
		// TODO Auto-generated method stub
		return start < length;
	}

	@Override
	public Element next() {
		// TODO Auto-generated method stub
		return (Element)list.item(start++);
	}

	@Override
	public void remove() {
		// TODO Auto-generated method stub

	}

}
