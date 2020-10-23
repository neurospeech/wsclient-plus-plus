package nsl
{
	import mx.utils.ObjectProxy;
	import flash.events.Event;
	import mx.rpc.soap.types.*;
	public class ResultEvent_LicenseService_RequestTrialLicense extends Event
	{
		public static var Result_RequestTrialLicense:String = 'Result_RequestTrialLicense';
		
		public var result:WSResultOfString;
		
		
		public function ResultEvent_LicenseService_RequestTrialLicense(r:WSResultOfString)
		{
			super(Result_RequestTrialLicense,false,false);
			result = r;
		}
		
	}
}
