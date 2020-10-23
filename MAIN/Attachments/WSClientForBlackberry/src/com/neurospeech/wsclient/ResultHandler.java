package com.neurospeech.wsclient;

import net.rim.device.api.ui.UiApplication;


public class ResultHandler {
	private Exception error;
	
	void onExecuteStart()
	{
		UiApplication.getUiApplication().invokeLater(
			new Runnable()
			{
				public void run()
				{
					onStart();
				}
			}
		);
	}
	void onExecuteError(Exception e)
	{
		error = e;
		UiApplication.getUiApplication().invokeLater(
			new Runnable()
			{
				public void run()
				{
					onBeforeError(error);
					onError(error);
				}
			}
		);
	}
	protected Object __result;
	void onExecuteResult(Object result)
	{
		__result = result;
		net.rim.device.api.ui.UiApplication.getUiApplication().invokeLater(
			new Runnable()
			{
				public void run()
				{
					onBeforeResult();
					onServiceResult();
				}
			}
		);
	}
	
	protected void onServiceResult(){}
	
	protected void onStart(){}
	
	protected void onBeforeError(Exception ex){}
	
	protected void onBeforeResult(){}
	
	protected void onError(Exception ex) {}
	
	
}
