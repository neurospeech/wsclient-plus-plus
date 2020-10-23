package nsl
{
	import mx.utils.ObjectProxy;
	import flash.events.Event;
	import mx.rpc.soap.types.*;
	public class ResultEvent_LicenseService_Ping extends Event
	{
		public static var Result_Ping:String = 'Result_Ping';
		
		public function ResultEvent_LicenseService_Ping(){super(Result_Ping,false,false);}
	}
}
