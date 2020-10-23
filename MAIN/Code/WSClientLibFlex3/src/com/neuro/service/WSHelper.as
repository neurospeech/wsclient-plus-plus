package com.neuro.service
{
	import com.neuro.utils.NSArrayCollection;
	
	import flash.xml.XMLNodeType;
	
	import mx.utils.StringUtil;
	
	public class WSHelper
	{
		
		
		
		public static function addChild(root:XML, name:String, value:String, attribute:Boolean):void
		{
			if(value==null)
				return;
			if(attribute){
				root.@[name] = value;
			}
			else
			{
				var node:XML = <node/>;
				node.setName(name);
				
				root.appendChild(node);
				node.* = value;
			}
		}
		
		
		private static function escape(value:String):String{
			if(value==null || value.length==0)
				return "";
			value = value.replace("&","&amp;");
			value = value.replace("<","&lt;");
			return value.replace(">","&gt;");
		}
		
		public static function addChildNodeNS(root:XML, nsURI:String, name:String, obj:WSObject ) :void
		{
			if(obj==null)
				return;
			var node:XML = <node/>;
			var qn:QName = new QName(nsURI,name);
			node.setName(qn);
			obj.fillXML(node);
			root.appendChild(node);
		}
		
		public static function addChildNode(root:XML , name:String, child:XML, obj:WSObject ):void
		{
			if(obj==null)
				return;
			var node:XML = <node/>;
			node.setName(name);
			if(child!=null)
			{
				node.appendChild(child);
			}
			else
			{
				obj.fillXML(node);
			}
			root.appendChild(node);
		}
		
		public static function addChildArray(root:XML, name:String, type:String, array:NSArrayCollection):void{
			if(array==null || array.length==0)
				return;
			var arrayElement:XML = <node/>;
			var obj:Object = null;
			arrayElement.setName(name);
			root.appendChild(arrayElement);
			if(type==null){
				for each(obj in array){
					var st:WSObject = obj as WSObject;
					arrayElement.appendChild(st.toXMLElement());
				}
			}else{
				for each(obj in array){
					var node:XML = <node/>;
					node.setName(type);
					node.appendChild(obj.toString());
					arrayElement.appendChild(node);
				}
			}
			
		}
		
		public static function addChildArrayInline(root:XML, name:String, type:String, array:NSArrayCollection):void{
			if(array==null || array.length==0)
				return;
			var arrayElement:XML = root;
			var obj:Object = null;
			if(type==null){
				for each(obj in array){
					var st:WSObject = obj as WSObject;
					arrayElement.appendChild(st.toXMLElement());
				}
			}else{
				for each(obj in array){
					var node:XML = <node/>;
					node.setName(type);
					node.appendChild(obj.toString());
					arrayElement.appendChild(node);
				}
			}
			
		}
		
		public static function getChildren(root:XML,name:String):Array
		{
			var children:Array = [];
			for each(var x:XML in root.children()){
				if(x.nodeKind() == "element")
				{
					if(name!=null && x.localName() != name)
						continue;
					children.push(x);
				}
			}
			return children;
		}
		
		public static function getElementChildren(root:XML, name:String):Array
		{
			var xl:XML = getElement(root,name);
			if(xl==null)
				return null;
			var children:Array = [];
			for each(var x:XML in xl.children()){
				if(x.nodeKind() == "element")
					children.push(x);
			}
			return children;
		}

		public static function getElement(root:XML, name:String):XML
		{
			if(name==null)
				return null;
			for each(var x:XML in root.children()){
				if(x.localName() == name)
					return x;
			}
			return null;
		}		
		
		public static function getElementNS(root:XML, nsURI:String, name:String):XML
		{
			if(name==null)
				return null;
			
			for each(var x:XML in root.children()){
				if(x.localName()==name && x.name().uri == nsURI)
					return x;
			}
			return null;
		}
		
		public static function getString(root:XML, name:String, isAttribute:Boolean):String
		{
			if(isAttribute)
			{
				return root.@[name];	
			}
			if(name==null)
			{
				return root.toString();
			}
			var child:XML = WSHelper.getElement(root, name);
			if(child==null)
				return null;
			return child.toString();
		}
		
		
		public static function getBoolean(root:XML, name:String, isAttribute:Boolean):Boolean
		{
			var val:String = WSHelper.getString(root, name, isAttribute);
			if(val==null)
				return false;
			val = val.toLowerCase();
			if(val == "true" || val == "yes")
				return true;
			return false;
		}
		
		public static function getDate(root:XML, name:String, isAttribute:Boolean):Date
		{
			var s:String = WSHelper.getString(root, name, isAttribute);
			if(s==null)
				return null;
			// parsing left...
			var year:int = parseInt(s.substr(0,4));
			var month:int = parseInt(s.substr(5,2));
			var day:int = parseInt(s.substr(8,2));
			var hour:int = parseInt(s.substr(11,2));
			var min:int = parseInt(s.substr(14,2));
			if(year==1 && month==1 && day==1 && hour == 0 && min == 0)
				return null;
			return new Date(year,month - 1,day,hour,min,0);
		}
		
		public static function getNumber(root:XML, name:String, isAttribute:Boolean):Number
		{
			var val:String = WSHelper.getString(root, name, isAttribute);
			if(val==null)
				return 0;
			return parseFloat(val);
			//return parseInt(val);
		}
		
		public static function toDateString(d:Date):String
		{
			var s:String = getStringValue(d.fullYear,4) + "-" + getStringValue(d.month + 1,2) + "-" + getStringValue(d.date,2);
			s += "T";
			s += getStringValue(d.hours,2);
			s += ":";
			s += getStringValue(d.minutes,2);
			s += ":00.0000";
			return s;
		}
		
		private static function getStringValue(n:Number,l:Number):String
		{
			var s:String = n.toString();
			for(var i:int = s.length;i<l;i++)
			{
				s = "0" + s; 
			}
			return s;
		}		
		
	}
}