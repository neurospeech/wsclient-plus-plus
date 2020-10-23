package wsClasses
{
	public class WSTypeMember
	{
		public function WSTypeMember()
		{
		}
		
		public var prefixedName:String = null;
		
		public var localName:String = null;

		public var name:String = null;
		
		
		public var type:WSType = null;
		
		public var bAttribute:Boolean = false;
		
		public var bIsText: Boolean = false;
		
		public var ref:QName = null;
		
		public var publicName:String = "";
		public var upName:String = "";
		
		public var fieldName:String = "";
		
		public var noNamespace:Boolean = true;
	}
}