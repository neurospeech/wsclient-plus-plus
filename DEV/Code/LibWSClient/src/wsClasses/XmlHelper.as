package wsClasses
{
	public class XmlHelper
	{
		public function XmlHelper()
		{
		}
		
		
		public static function toQName(e:XML, name:String):QName
		{
			
			var p:String = preFixText(name);
			
			var n:String = postFixText(name);
			
			var ns:Namespace = e.namespace(p);
			
			if(p==null && ns==null){
				return new QName("http://www.w3.org/2001/XMLSchema",n);
			}
			
			return new QName(ns.uri, n);
		}
		
		private static function preFixText(name:String):String{
			var i:int = name.indexOf(":");
			if(i==-1)
				return null;
			return name.substring(0,i);
		}
		
		private static function postFixText(name:String):String
		{
			var i:int = name.indexOf(":");
			if(i==-1)
				return name;
			return name.substring(i+1);
		}
		
		
	}
}