package nsl
{
	import mx.utils.ObjectProxy;
	import flash.events.Event;
	import mx.rpc.soap.types.*;
	public class ResultEvent_LicenseService_Subscribe extends Event
	{
		public static var Result_Subscribe:String = 'Result_Subscribe';
		
		public var result:WSResultOfString;
		
		
		public function ResultEvent_LicenseService_Subscribe(r:WSResultOfString)
		{
			super(Result_Subscribe,false,false);
			result = r;
		}
		
	}
}
