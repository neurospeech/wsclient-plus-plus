package nsl
{
	import mx.utils.ObjectProxy;
	import flash.events.Event;
	import mx.rpc.soap.types.*;
	public class ResultEvent_LicenseService_DeactivateLicense extends Event
	{
		public static var Result_DeactivateLicense:String = 'Result_DeactivateLicense';
		
		public var result:WSResultOfString;
		
		
		public function ResultEvent_LicenseService_DeactivateLicense(r:WSResultOfString)
		{
			super(Result_DeactivateLicense,false,false);
			result = r;
		}
		
	}
}
