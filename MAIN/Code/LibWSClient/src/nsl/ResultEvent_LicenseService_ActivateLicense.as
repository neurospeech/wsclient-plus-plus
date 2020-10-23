package nsl
{
	import mx.utils.ObjectProxy;
	import flash.events.Event;
	import mx.rpc.soap.types.*;
	public class ResultEvent_LicenseService_ActivateLicense extends Event
	{
		public static var Result_ActivateLicense:String = 'Result_ActivateLicense';
		
		public var result:WSResultOfString;
		
		
		public function ResultEvent_LicenseService_ActivateLicense(r:WSResultOfString)
		{
			super(Result_ActivateLicense,false,false);
			result = r;
		}
		
	}
}
