package com.neurospeech.wsclient;

import javax.swing.SwingUtilities;




public class ResultHandler {
	private Exception error;
	
	
	public ResultHandler(){
		
	}
	
	void onExecuteStart()
	{
		SwingUtilities.invokeLater(
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
		SwingUtilities.invokeLater(
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
		SwingUtilities.invokeLater(
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
