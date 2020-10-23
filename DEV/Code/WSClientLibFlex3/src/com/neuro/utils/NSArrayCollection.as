package com.neuro.utils
{
	import mx.collections.ArrayCollection;

	public class NSArrayCollection extends ArrayCollection
	{
		public function NSArrayCollection(source:Array=null)
		{
			super(source);
		}
		
		public function removeItem(item:Object):void
		{
			var i:int = getItemIndex(item);
			if(i==-1)
				return;
			removeItemAt(i);
		}
		
		public function removeItems(items:Array):void
		{
			for each(var o:Object in items)
				removeItem(o);
		}
		
		public function addItems(items:Array):void
		{
			this.disableAutoUpdate();
			for each(var o:Object in items){
				addItem(o);
			}
			this.enableAutoUpdate();
			this.refresh();
		}
		
		/*public function replaceItem(item:Object, field:String):void
		{
			var fieldData:Object = item[field];
			
		}*/
	}
}