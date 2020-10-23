package wsForm
{
	import flash.events.InvokeEvent;
	
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	
	public class WSApplication extends WindowedApplication
	{
		public function WSApplication()
		{
			super();
			
			this.addEventListener(InvokeEvent.INVOKE, onInvoked,false,0,true);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete,false,0,true);
			
			
		}
		
		private var tabs:WSTabs = new WSTabs();
		
		private function onInvoked(e:InvokeEvent):void
		{
			tabs.args = e.arguments;
		}
		
		private function onCreationComplete(fe:FlexEvent):void
		{
			this.addChild(tabs);
			tabs.setupMenus(this);
		}
	}
}