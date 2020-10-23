package wsClasses
{
	public class WSMethod
	{
		
		private var service:SoapService;
		
		public function WSMethod(s:SoapService)
		{
			service = s;
		}
		
		public var name:String = null;
		
		public var inputMessage:String = null;
		
		public var ouputMessage:String = null;
		
		public var inputType:WSType = null;
		
		public var outputType:WSType = null;
		
		public function get returnType():WSType
		{
			if(outputType.members.length==1)
			{
				var wt:WSTypeMember = outputType.members[0];
				//if(!wt.type.isArray && !wt.type.isBuiltin)
					return wt.type;
			}
			return outputType;
		}
		
		public function get returnMember():WSTypeMember
		{
			if(outputType.members.length==1){
				var wt:WSTypeMember = outputType.members[0];
				//if(!wt.type.isArray && !wt.type.isBuiltin)
					return wt;
			}
			return null;
		}
		
		public var headerMessages:Array = [];
		
		//public var headerType:WSType = null;
		public var headerTypes:Array = [];
		
		public var soapAction:String = "";
		
		public var targetNamespace:String = "";
		
		public var signature:String = null;
		
		public var multipleReturns:Boolean = false;
		
		public function get parameters():Array
		{
			return inputType.members;
		}
		
		public function get requestName():String{
			return "Request_" + service.serviceName + "_" + name;
		}
		
		public function get resultEventName():String
		{
			return "ResultEvent_"+ service.serviceName + "_" + name ;
		}
		
		
	}
}