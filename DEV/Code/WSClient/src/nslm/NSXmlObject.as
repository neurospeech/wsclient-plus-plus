package nslm
{
	public class NSXmlObject
	{
		public function NSXmlObject()
		{
		}
		
		public function load(xml:XML):void
		{
			for each(var x:XML in xml.elements()){
				var name:String = x.localName();
				if(x.elements().length()>0)
				{
					if(this.hasOwnProperty(name)){
						loadProperty(name,x);
					}
					continue;
				}
				var val:String = x.text();
				if(val=="")
					continue;
				if(this.hasOwnProperty(name)){
					this[name] = val;
				}
				
			}
		}
		
		protected function loadProperty(name:String, x:XML):void
		{
			
		}
		
	}
}