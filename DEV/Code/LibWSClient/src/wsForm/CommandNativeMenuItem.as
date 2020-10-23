package wsForm
{
	import com.neuro.command.GenericCommand;
	
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	public class CommandNativeMenuItem extends NativeMenuItem
	{
		public function CommandNativeMenuItem(label:String="", isSeparator:Boolean=false, cmd:GenericCommand = null)
		{
			super(label, isSeparator);
			command = cmd;
			this.addEventListener(Event.SELECT, onMenuClicked, false, 0 , true);
		}
		
		private function onMenuClicked(e:Event):void
		{
			if(command!=null)
				command.invokeCommand();
		}
		
		public var command:GenericCommand = null;
	}
}