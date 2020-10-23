package com.neuro.service
{
	import flash.events.IEventDispatcher;
	
	public class Soap12WebService extends SoapWebService
	{
		public function Soap12WebService(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected override function getSoapEnvelopeNS():String
		{
			return "http://www.w3.org/2003/05/soap-envelope";
		}
		
		protected override function getContentType(action:String):String
		{
			if(action!=null)
				return "application/soap+xml; charset=utf-8; action=\""+ action +"\"";
			return "application/soap+xml; charset=utf-8";
		}
		
		protected override function  IsSoapActionRequired():Boolean
		{
			return false;
		}
	}
}