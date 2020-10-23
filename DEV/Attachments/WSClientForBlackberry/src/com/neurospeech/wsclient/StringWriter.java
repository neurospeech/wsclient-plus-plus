package com.neurospeech.wsclient;

public class StringWriter {

	private String text = "";
	
	public void write(String string) {
		// TODO Auto-generated method stub
		text += string;
	}
	
	public String toString(){
		return text;
	}

}
