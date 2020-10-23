package com.neuro.service
{
	//import com.neuro.command.WSCommand;
	import com.neuro.utils.NSArrayCollection;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.sampler.getSetterInvocationCount;
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	import mx.core.IMXMLObject;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;
	
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	
	public class SoapWebService extends EventDispatcher implements IMXMLObject
	{
		public function SoapWebService(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected var ID:String = "";
		
		public static var globalBaseUrl:String = null;
		
		public var baseUrl:String = null;
		
		public function initialized(document:Object, id:String):void
		{
			parentDocument = document;
			parentDocument.addEventListener("creationComplete",onCreationComplete,false,0,true);
			this.ID = id;
			//parentDocument.addEventListener("addedToStage",onCreationComplete,false,0,true);
		}
		
		protected function callLater(method:Function, args:Array = null):void
		{
			//if(parentDocument)
			parentDocument.callLater(method,args);
			//else
			//{
			
			//}
		}
		
		protected function refreshBindings():void
		{
			//parentDocument.executeBindings(true);
		}
		
		[Bindable]
		public var parentDocument:Object = null;
		
		protected function onCreationComplete(e:Event):void
		{
		}
		
		[Bindable]
		protected var url:String = null;
		
		protected function getServiceUrl():String
		{
			var targetUrl:String = url;
			if(baseUrl != null)
				targetUrl = baseUrl + url;
			else if(globalBaseUrl != null)
				targetUrl = globalBaseUrl + url;
			return targetUrl;
		}
		
		protected function getSoapEnvelopeNS():String
		{
			return "http://schemas.xmlsoap.org/soap/envelope/";
		}
		
		protected function getUserAgent():String{
			return null;
		}
		
		protected function getContentType(action:String): String {
			return "text/xml; charset=utf-8";
		}
		
		protected function IsSoapActionRequired():Boolean{
			return true;
		}
		
		protected function getNamespaces():String
		{
			return "";
		}
		
		protected function buildSoapRequest(
			action:String
			):SoapRequest
		{
			
			var req:SoapRequest = new SoapRequest();
			
			req.soapAction = action;
			
			var soapDoc:String = "<?xml version='1.0' encoding='utf-8'?>" +
				"<soap:Envelope "+ getNamespaces() + "><soap:Header/><soap:Body/></soap:Envelope>";

			req.document = new XML(soapDoc);
			
			req.root = req.document;
			
			return req;
		}
		
		public function postWS(request:SoapRequest) : AsyncToken
		{
			
			
			// build body...
			var e:XML = WSHelper.getElementNS(request.root, getSoapEnvelopeNS(), "Body");
			e.appendChild(request.method);
			
			if(request.header!=null){
				e = WSHelper.getElementNS(request.root, getSoapEnvelopeNS(), "Header");
				e.appendChild(request.header);
			}
			
			
			var xml:String = request.document.toXMLString();
			
			var userAgent:String = getUserAgent();
			var contentType:String = getContentType(request.soapAction);
			
			var hc:HTTPService = new HTTPService();
			hc.url = getServiceUrl();
			hc.resultFormat = "text";
			hc.method = "POST";
			
			hc.contentType = contentType;
			request.rawHttpRequest = url + "\r\n";
			request.rawHttpRequest += "Content-Type: " + contentType + "\r\n";
			if(userAgent!=null){
				request.rawHttpRequest += "User-Agent: " + userAgent + "\r\n";
				hc.headers["User-Agent"] = userAgent;
			}
			if(IsSoapActionRequired()){
				hc.headers["SOAPAction"] =request.soapAction;
				request.rawHttpRequest += "SOAPAction: " + request.soapAction + "\r\n";
			}
			
			request.rawHttpRequest += "\r\n";
			request.rawHttpRequest += xml;
			hc.addEventListener(FaultEvent.FAULT, onInternalFault);
			hc.addEventListener(ResultEvent.RESULT, onInternalResult);
			hc.addEventListener(ProgressEvent.PROGRESS, onProgress);
			
			request.client = hc;
			
			var at:AsyncToken = hc.send(xml); 
			sentRequests[at] = request;
			request.token = at;
			return at;
		}
		
		private function removeEventListeners(hc:HTTPService):void
		{
			hc.removeEventListener(FaultEvent.FAULT, onInternalFault);
			hc.removeEventListener(ResultEvent.RESULT, onInternalResult);
			hc.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		private var sentRequests:Dictionary = new Dictionary();
		
		protected function addParameter(root:XML, name:String, value:Object):void
		{
			if(value==null)
				return;
			var e:XML = <node/>;
			e.setName(name);
			var val:String = value.toString();
			if(value is Date){
				val = WSHelper.toDateString(value as Date);
			}
			e.* = val;
			root.appendChild(e);
		}
		
		private function onInternalResult(re:ResultEvent):void
		{
			
			var rs:SoapResponse = new SoapResponse();
			
			var xml:String = re.result.toString();
			
			rs.root = new XML(xml);
			
			// search for fault first...
			var fault:XML = WSHelper.getElementNS(rs.root, getSoapEnvelopeNS(), "Fault");
			if(fault!=null)	{
				var code:String = WSHelper.getString(fault, "faultcode", false);
				var text:String = WSHelper.getString(fault, "faultstring", false);
				onFault(
					FaultEvent.createEvent(
						new Fault(code, text, ""),
						re.token,null));
				return;
			}
			
			rs.header = WSHelper.getElementNS(rs.root,getSoapEnvelopeNS(), "Header");
			rs.body = WSHelper.getElementNS(rs.root,getSoapEnvelopeNS(), "Body");
			//onResult(ResultEvent.createEvent(rs,re.token,null));
			
			// get method...
			var at:AsyncToken = re.token;
			
			var req:SoapRequest = sentRequests[at];
			
			removeEventListeners(req.client);
			
			sentRequests[at] = null;
			
			var responseMethod:String =  "on" + req.methodName + "_Result";
			
			var f:Function = this[responseMethod] as Function;
			
			
			var retVal:Object =  f.call(this, req, rs);
			
			// twice...
			
			// set last result...
			if(retVal.hasOwnProperty("result"))
				this["LastResult_" + req.methodName] = retVal.result;
			
			onResult(ResultEvent.createEvent(retVal.result,at.token,null), at);
			
			onResult(retVal.re, at);
			
		}
		
		protected function onResult(re:Event, at:AsyncToken):void
		{
			this.dispatchEvent(re);
			at.dispatchEvent(re);
		}
		
		private function onInternalFault(fe:FaultEvent):void
		{
			var req:SoapRequest = sentRequests[fe.token];
			removeEventListeners(req.client);
			sentRequests[fe.token] = null;
			onFault(fe);
			fe.token.dispatchEvent(fe);
		}
		
		protected function onFault(fe:FaultEvent):void
		{
			this.dispatchEvent(fe);
		}
		
		private function onProgress(pe:ProgressEvent):void
		{
			this.dispatchEvent(pe);
		}
		
		
	}
}