package nsl
{
	
	import com.neuro.service.*;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import com.neuro.utils.NSArrayCollection;
	
	[Event(name='Result_RequestTrialLicense', type='ResultEvent_LicenseService_RequestTrialLicense')]
	[Event(name='Result_ActivateLicense', type='ResultEvent_LicenseService_ActivateLicense')]
	[Event(name='Result_DeactivateLicense', type='ResultEvent_LicenseService_DeactivateLicense')]
	[Event(name='Result_Subscribe', type='ResultEvent_LicenseService_Subscribe')]
	[Event(name='Result_Ping', type='ResultEvent_LicenseService_Ping')]
	public class LicenseService extends NSWebService
	{
		
		public function LicenseService()
		{
			this.url = '/Service/LicenseService.asmx';
		}
		
		public function RequestTrialLicense(
			emailAddress:String
			,editionUID:String
			,subscribe:Boolean
		):AsyncToken
		{
			var req:XML = <RequestTrialLicense xmlns='http://tempuri.org/' />;
			if(emailAddress!=null){
				WSHelper.addChild(req,"emailAddress", emailAddress.toString(),false);
			}
			
			if(editionUID!=null){
				WSHelper.addChild(req,"editionUID", editionUID.toString(),false);
			}
			
			WSHelper.addChild(req,"subscribe", subscribe.toString(),false);
			
			var at:AsyncToken = callMethod('RequestTrialLicense','http://tempuri.org/RequestTrialLicense', req.toXMLString());
			at.addEventListener(ResultEvent.RESULT,onRequestTrialLicense_Result, false, 10 , true);
			return at;
		}
		
		private function onRequestTrialLicense_Result(re:ResultEvent):void
		{
			var r:XML = new XML(re.result.childNodes[0].childNodes[0].childNodes[0]);
			var result:WSResultOfString = WSResultOfString.loadFrom(r);
			var revent:ResultEvent_LicenseService_RequestTrialLicense = new ResultEvent_LicenseService_RequestTrialLicense(result);
			LastResult_RequestTrialLicense = result;
			re.token.removeEventListener(ResultEvent.RESULT,onRequestTrialLicense_Result);
			re.preventDefault();
			re.stopImmediatePropagation();re.stopPropagation();
			re.token.dispatchEvent(ResultEvent.createEvent(result,re.token,re.message));
			callLater(dispatchEvent, [revent]);
		}
		
		public function RequestTrialLicense_send():AsyncToken
		{
			return this.RequestTrialLicense(
				Request_RequestTrialLicense.emailAddress
				, Request_RequestTrialLicense.editionUID
				, Request_RequestTrialLicense.subscribe
			);
		}
		public function ActivateLicense(
			emailAddress:String
			,editionUID:String
			,licenseCode:String
			,computerName:String
		):AsyncToken
		{
			var req:XML = <ActivateLicense xmlns='http://tempuri.org/' />;
			if(emailAddress!=null){
				WSHelper.addChild(req,"emailAddress", emailAddress.toString(),false);
			}
			
			if(editionUID!=null){
				WSHelper.addChild(req,"editionUID", editionUID.toString(),false);
			}
			
			if(licenseCode!=null){
				WSHelper.addChild(req,"licenseCode", licenseCode.toString(),false);
			}
			
			if(computerName!=null){
				WSHelper.addChild(req,"computerName", computerName.toString(),false);
			}
			
			var at:AsyncToken = callMethod('ActivateLicense','http://tempuri.org/ActivateLicense', req.toXMLString());
			at.addEventListener(ResultEvent.RESULT,onActivateLicense_Result, false, 10 , true);
			return at;
		}
		
		private function onActivateLicense_Result(re:ResultEvent):void
		{
			var r:XML = new XML(re.result.childNodes[0].childNodes[0].childNodes[0]);
			var result:WSResultOfString = WSResultOfString.loadFrom(r);
			var revent:ResultEvent_LicenseService_ActivateLicense = new ResultEvent_LicenseService_ActivateLicense(result);
			LastResult_ActivateLicense = result;
			re.token.removeEventListener(ResultEvent.RESULT,onActivateLicense_Result);
			re.preventDefault();
			re.stopImmediatePropagation();re.stopPropagation();
			re.token.dispatchEvent(ResultEvent.createEvent(result,re.token,re.message));
			callLater(dispatchEvent, [revent]);
		}
		
		public function ActivateLicense_send():AsyncToken
		{
			return this.ActivateLicense(
				Request_ActivateLicense.emailAddress
				, Request_ActivateLicense.editionUID
				, Request_ActivateLicense.licenseCode
				, Request_ActivateLicense.computerName
			);
		}
		public function DeactivateLicense(
			emailAddress:String
			,editionUID:String
			,licenseCode:String
			,computerName:String
		):AsyncToken
		{
			var req:XML = <DeactivateLicense xmlns='http://tempuri.org/' />;
			if(emailAddress!=null){
				WSHelper.addChild(req,"emailAddress", emailAddress.toString(),false);
			}
			
			if(editionUID!=null){
				WSHelper.addChild(req,"editionUID", editionUID.toString(),false);
			}
			
			if(licenseCode!=null){
				WSHelper.addChild(req,"licenseCode", licenseCode.toString(),false);
			}
			
			if(computerName!=null){
				WSHelper.addChild(req,"computerName", computerName.toString(),false);
			}
			
			var at:AsyncToken = callMethod('DeactivateLicense','http://tempuri.org/DeactivateLicense', req.toXMLString());
			at.addEventListener(ResultEvent.RESULT,onDeactivateLicense_Result, false, 10 , true);
			return at;
		}
		
		private function onDeactivateLicense_Result(re:ResultEvent):void
		{
			var r:XML = new XML(re.result.childNodes[0].childNodes[0].childNodes[0]);
			var result:WSResultOfString = WSResultOfString.loadFrom(r);
			var revent:ResultEvent_LicenseService_DeactivateLicense = new ResultEvent_LicenseService_DeactivateLicense(result);
			LastResult_DeactivateLicense = result;
			re.token.removeEventListener(ResultEvent.RESULT,onDeactivateLicense_Result);
			re.preventDefault();
			re.stopImmediatePropagation();re.stopPropagation();
			re.token.dispatchEvent(ResultEvent.createEvent(result,re.token,re.message));
			callLater(dispatchEvent, [revent]);
		}
		
		public function DeactivateLicense_send():AsyncToken
		{
			return this.DeactivateLicense(
				Request_DeactivateLicense.emailAddress
				, Request_DeactivateLicense.editionUID
				, Request_DeactivateLicense.licenseCode
				, Request_DeactivateLicense.computerName
			);
		}
		public function Subscribe(
			emailAddress:String
			,editionUID:String
		):AsyncToken
		{
			var req:XML = <Subscribe xmlns='http://tempuri.org/' />;
			if(emailAddress!=null){
				WSHelper.addChild(req,"emailAddress", emailAddress.toString(),false);
			}
			
			if(editionUID!=null){
				WSHelper.addChild(req,"editionUID", editionUID.toString(),false);
			}
			
			var at:AsyncToken = callMethod('Subscribe','http://tempuri.org/Subscribe', req.toXMLString());
			at.addEventListener(ResultEvent.RESULT,onSubscribe_Result, false, 10 , true);
			return at;
		}
		
		private function onSubscribe_Result(re:ResultEvent):void
		{
			var r:XML = new XML(re.result.childNodes[0].childNodes[0].childNodes[0]);
			var result:WSResultOfString = WSResultOfString.loadFrom(r);
			var revent:ResultEvent_LicenseService_Subscribe = new ResultEvent_LicenseService_Subscribe(result);
			LastResult_Subscribe = result;
			re.token.removeEventListener(ResultEvent.RESULT,onSubscribe_Result);
			re.preventDefault();
			re.stopImmediatePropagation();re.stopPropagation();
			re.token.dispatchEvent(ResultEvent.createEvent(result,re.token,re.message));
			callLater(dispatchEvent, [revent]);
		}
		
		public function Subscribe_send():AsyncToken
		{
			return this.Subscribe(
				Request_Subscribe.emailAddress
				, Request_Subscribe.editionUID
			);
		}
		public function Ping(
		):AsyncToken
		{
			var req:XML = <Ping xmlns='http://tempuri.org/' />;
			var at:AsyncToken = callMethod('Ping','http://tempuri.org/Ping', req.toXMLString());
			at.addEventListener(ResultEvent.RESULT,onPing_Result, false, 10 , true);
			return at;
		}
		
		private function onPing_Result(re:ResultEvent):void
		{
			var r:XML = new XML(re.result.childNodes[0].childNodes[0].childNodes[0]);
			var revent:ResultEvent_LicenseService_Ping = new ResultEvent_LicenseService_Ping();
			re.token.removeEventListener(ResultEvent.RESULT,onPing_Result);
			re.preventDefault();
			re.stopImmediatePropagation();re.stopPropagation();
			re.token.dispatchEvent(ResultEvent.createEvent(null,re.token,re.message));
			callLater(dispatchEvent, [revent]);
		}
		
		public function Ping_send():AsyncToken
		{
			return this.Ping(
			);
		}
		[Bindable('Result_RequestTrialLicense')]
		public var LastResult_RequestTrialLicense:WSResultOfString;
		[Bindable('Result_ActivateLicense')]
		public var LastResult_ActivateLicense:WSResultOfString;
		[Bindable('Result_DeactivateLicense')]
		public var LastResult_DeactivateLicense:WSResultOfString;
		[Bindable('Result_Subscribe')]
		public var LastResult_Subscribe:WSResultOfString;
		
		[Bindable]
		public var Request_RequestTrialLicense:Request_LicenseService_RequestTrialLicense;
		[Bindable]
		public var Request_ActivateLicense:Request_LicenseService_ActivateLicense;
		[Bindable]
		public var Request_DeactivateLicense:Request_LicenseService_DeactivateLicense;
		[Bindable]
		public var Request_Subscribe:Request_LicenseService_Subscribe;
		
	}
	
}
