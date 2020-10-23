package wsForm
{
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	
	import spark.components.List;
	
	public class DataList extends List
	{
		public function DataList()
		{
			super();
		}
		public override function set dataProvider(value:IList):void
		{
			super.dataProvider = value;
			updateData();	
			var ilv:ICollectionView = super.dataProvider as ICollectionView;
			if(ilv!=null){
				ilv.addEventListener(CollectionEvent.COLLECTION_CHANGE,onCollectionChange,false,0,true);
			}
			if(this.selectedIndex==-1){
				this.selectedIndex=0;
			}
		}
		
		private function onCollectionChange(ce:CollectionEvent):void
		{
			updateData();
		}
		
		public var dataField:String = "data";
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		public function get data():Object{
			var s:Object = this.selectedItem;
			if(s==null){
				if(_data)
					return _data;
				return null;
			}
			return s[dataField];
		}
		
		private var _data:Object = null;
		
		public function set data(v:Object):void
		{
			var old:Object = this.data;
			if(old===v)
				return;
			_data = v;
			updateData();
		}
		
		private function updateData():void
		{
			if(!this.dataProvider)
				return;
			if(!_data)
				return;
			for each(var item:Object in this.dataProvider)
			{
				if(item[dataField] == _data){
					_data = null;
					this.selectedItem = item;
					return;
				}
			}
		}
	}
}