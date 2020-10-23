package nsl
{
	import mx.utils.ObjectProxy;
	import flash.events.Event;
	import mx.rpc.soap.types.*;
	import com.neuro.utils.NSArrayCollection;
	[Bindable]
	public class Request_LicenseService_RequestTrialLicense
	{
		public var emailAddress:String;
		public var editionUID:String;
		public var subscribe:Boolean;
	}
}
