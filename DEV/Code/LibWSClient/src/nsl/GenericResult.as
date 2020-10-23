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
	public class GenericResult extends WSObject
	{
		public function GenericResult(){}
		
		public var Total:Number=0;
		public var Successful:Boolean=false;
		public var Message:String="";
		public var MessageDetails:String="";
		
		
		public static function loadFrom(node:XML):GenericResult
		{
			if(node == null) return null;
			var obj:GenericResult = new GenericResult();
			obj.load(node);
			return obj;
		}
		
		public override function load(node:XML):void
		{
			super.load(node);
			this.Total = WSHelper.getNumber(node,"Total",false);
			this.Successful = WSHelper.getBoolean(node,"Successful",false);
			this.Message = WSHelper.getString(node,"Message",false);
			this.MessageDetails = WSHelper.getString(node,"MessageDetails",false);
		}
		
		public override function toXMLElement():XML
		{
			var node:XML = <node/>
			node.setName("GenericResult")
			this.fillXML(node);
			return node;
		}
		public override function fillXML(node:XML):void
		{
			
			super.fillXML(node);
			
			WSHelper.addChild(node,"Total",(isNaN(Total) ? "0" : Total.toString()),false);
			WSHelper.addChild(node,"Successful",Successful.toString(),false);
			if(Message!=null)
			{
				WSHelper.addChild(node,"Message",Message.toString(),false);
			}
			if(MessageDetails!=null)
			{
				WSHelper.addChild(node,"MessageDetails",MessageDetails.toString(),false);
			}
		}
	}
}
