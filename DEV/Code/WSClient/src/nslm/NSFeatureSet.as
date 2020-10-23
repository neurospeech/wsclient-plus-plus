package nslm
{
	import mx.collections.ArrayCollection;

	public class NSFeatureSet extends NSXmlObject
	{
		public function NSFeatureSet()
		{
		}
		
		public var Version:String = "";
		
		public var ComputerName:String = "";
		
		public var Features:Array = [];
		
		public var OrderID:int = 0;
		public function hasFeature(f:String):Boolean
		{
			for each(var x:String in Features){
				if(x==f)
					return true;
			}
			return false;
		}
		
		override protected function loadProperty(name:String, x:XML):void
		{
			// TODO Auto Generated method stub
			
			if(name=="Features"){
				// load features...
				for each(var child:XML in x.elements()){
					var txt:String = child.text();
					Features.push(txt);
				}
			}else{
				super.loadProperty(name, x);
			}
		}
		
		
	}
}