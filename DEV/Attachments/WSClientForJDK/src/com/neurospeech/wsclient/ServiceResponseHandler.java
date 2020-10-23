package com.neurospeech.wsclient;

import javax.swing.SwingUtilities;


public class ServiceResponseHandler<T>{
	
	private Exception error;
	private T result;
	
	public ServiceResponseHandler(){

	}
	
	
	public final void onExecuteStart(){
		SwingUtilities.invokeLater(new Runnable(){
			@Override
			public void run() {
				onStart();
			}			
		});
	}
	
	protected void onStart() {
	}


	public final void onExecuteError(Exception e)
	{
		error = e;
		SwingUtilities.invokeLater(new Runnable() {
			
			@Override
			public void run() {
				onBeforeError(error);
				onError(error);				
			}
		});
	}
	
	protected void onBeforeError(Exception ex){
		
	}
	
	protected void onBeforeResult(T _result){
		
	}
	
	protected void onError(Exception ex) {
		
	}

	public final void onExecuteResult(T _result)
	{
		this.result = _result;
		SwingUtilities.invokeLater(new Runnable() {
			
			@Override
			public void run() {
				onBeforeResult(result);
				onResult(result);
			}
		});
	}


	protected void onResult(T result) {
	}
}
