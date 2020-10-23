package com.neurospeech.wsclient;

import java.util.Vector;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class WSNodeList extends Vector implements NodeList
{

	public int getLength() {
		return this.size();
	}

	public Node item(int index) {
		return (Node)this.elementAt(index);
	}
	
}
