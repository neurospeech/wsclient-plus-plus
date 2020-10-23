package nsl
{
	
	import mx.utils.ObjectProxy;
	import flash.utils.ByteArray;
	import mx.collections.ArrayCollection;
	import mx.rpc.soap.types.*;
	import com.neuro.utils.NSArrayCollection;
	import com.neuro.service.NSWebService;
	import com.neuro.service.WSObject;
	import com.neuro.service.WSHelper;
	
	[Bindable]
	public class WSResultOfString extends GenericResult
	{
		public function WSResultOfString(){}
		
		public var Result:String="";
		public var Results:NSArrayCollection = new NSArrayCollection();
		
		
		public static function loadFrom(node:XML):WSResultOfString
		{
			if(node == null) return null;
			var obj:WSResultOfString = new WSResultOfString();
			obj.load(node);
			return obj;
		}
		
		public override function load(node:XML):void
		{
			super.load(node);
			var child:XML = null;
			var arrayItem:XML = null;
			var ac:NSArrayCollection = null;
			this.Result = WSHelper.getString(node,"Result",false);
			child = WSHelper.getElement(node,"Results")
			if(child != null)
			{
				ac = new NSArrayCollection();
				for each(arrayItem in child.elements())
				{
					ac.addItem(WSHelper.getString(arrayItem,null,false));
				}
				this.Results= ac;
			}
		}
		
		public override function toXMLElement():XML
		{
			var node:XML = <node/>
			node.setName("WSResultOfString")
			this.fillXML(node);
			return node;
		}
		public override function fillXML(node:XML):void
		{
			
			super.fillXML(node);
			
			if(Result!=null)
			{
				WSHelper.addChild(node,"Result",Result.toString(),false);
			}
			if(Results!=null)
			{
				WSHelper.addChildArray(node,"Results","string",this.Results);
			}
		}
	}
}
