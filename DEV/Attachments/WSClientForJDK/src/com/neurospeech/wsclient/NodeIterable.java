package com.neurospeech.wsclient;

import java.util.Iterator;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class NodeIterable implements Iterable<Element> {

	private NodeList nodeList;
	
	public NodeIterable(NodeList list)
	{
		nodeList = list;
	}
	
	@Override
	public Iterator<Element> iterator() {
		// TODO Auto-generated method stub
		return new NodeIterator(nodeList);
	}

}
