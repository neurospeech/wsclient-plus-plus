package wsClasses
{
	import flash.utils.Dictionary;

	public class WSType
	{
		public function WSType()
		{
		}
		
		public var className:String = "";
		
		public var qName:QName = null;
		
		public var prefixedName:String = "";
		
		public var nativeType:String = null;
		
		public var prefix:String = null;
		
		public var isCustom: Boolean = false;
		
		public var isSimple:Boolean = false;
		
		public var isBuiltin:Boolean = false;
		
		public function get isVoid():Boolean
		{
			if(isBuiltin && qName.localName == "void")
				return true;
			return false;
		}
		
		public var isArray:Boolean = false;
		
		public var isValueType:Boolean = false;
		
		public var isInlineArray:Boolean = false;
		
		public var arrayType:WSType = null;
		
		public var serviceName:String = null;
		
		public var defaultValue:String = null;
		
		public var isDate:Boolean = false;
		
		public var isHeader : Boolean = false;
		
		public var headerNS: String = null;
		
		public function get isObjectType():Boolean{
			if(isCustom)
				return true;
			if(isArray)
			{
				if(isBuiltin && qName.localName == "void")
					return false;
				return true;
			}
			return false;
		}
		
		
		public function get wsType():String
		{
			if(isArray)
				return arrayType.qName.localName;
			return qName.localName;
		}
		
		// array of WSTypeMember...
		public var members:Array = [];
		
		public function addMember(w:WSTypeMember):void
		{
			for each(var e:WSTypeMember in members){
				if(e.name == w.name)
					return;
			}
			members.push(w);
		}
		
		
		public var baseType:WSType = null;
		
		public var elementNames:Array = [];
		
		public function get hasArrayMember():Boolean
		{
			for each(var st:WSTypeMember in members){
				if(st.type.isArray)
					return true;
			}
			return false;
		}
		
		public function toString():String
		{
			var str:String = "";
			str += qName.localName;
			str += "\n";
			for each(var sp1:WSTypeMember in members)
			{
				str += "\t" + sp1.name + ":" + sp1.type.qName.localName;
				str += "\n";
			}
			return str;
		}
		
		public var fnLoadFromService:Function = null;
		public var fnToStringValue:Function = null;
		public var fnSerialize:Function = null;
		public var fnDeserialize:Function = null;
		
		public function loadFromService(root:String, name:String , attribute:Boolean):String{
			if(fnLoadFromService==null)
				return "No LoadFrom Service for " + this.qName.localName;
			return fnLoadFromService.call(null,root, name ,attribute);
		}
		
		public function toStringValue(member:String):String{
			return fnToStringValue.call(null,member);
		}
		
		public function serialize(stream:String, name:String):String{
			return fnSerialize.call(null,stream,name);
		}
		
		public function deserialize(stream:String, name:String):String{
			return fnDeserialize.call(null,stream,name);
		}
		
	}
}