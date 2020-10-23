package com.neurospeech.wsclient;

public class ServiceRequest implements Runnable {
	
	private ResultHandler handler = null;
	
	public ServiceRequest(ResultHandler h){
		handler = h;
	}
	
	protected Object __result;

	public final void run() {
		// TODO Auto-generated method stub
		try{
			handler.onExecuteStart();
			executeRequest();
			handler.onExecuteResult(__result);
		}catch(Exception ex){
			handler.onExecuteError(ex);
		}
	}
	
	public void executeAsync(){
		Thread th = new Thread(this);
		th.start();
	}
	
	protected void executeRequest() throws Exception{
	}

}
