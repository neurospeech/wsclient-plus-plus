package com.neuro.service
{
	import mx.rpc.AsyncToken;
	import mx.rpc.http.mxml.HTTPService;

	public class SoapRequest
	{
		public function SoapRequest()
		{
		}
		
		public var document:XML;
		
		public var root:XML;
		
		public var method:XML;
		
		public var header:XML;
		
		public var methodName:String;
		
		public var soapAction:String;
		
		public var rawHttpRequest:String;
		
		public var token:AsyncToken;
		
		public var client:HTTPService;
	}
}