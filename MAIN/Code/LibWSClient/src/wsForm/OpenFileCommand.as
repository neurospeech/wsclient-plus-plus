package wsForm
{
	import com.neuro.command.GenericCommand;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	public class OpenFileCommand extends GenericCommand
	{
		public function OpenFileCommand(target:IEventDispatcher=null)
		{
			super(target);
			
			this.showBusyDialog = false;
		}
		
		public override function invokeCommand():void
		{
			var f:File = File.documentsDirectory;
			f.addEventListener(Event.SELECT, onFileSelected, false, 0 , true);
			f.browseForOpen(title,typeFilter);
		}
		
		private function onFileSelected(fe:Event):void
		{
			var f2:File = fe.target as File;
			lastFile = f2;
			super.dispatchResult(f2);
		}
		
		[Bindable]
		public var lastFile:File = null;
		
		public var title:String = "Open";
		
		public var typeFilter:Array = [new FileFilter("WS Gen Files","*.wsclient",null), new FileFilter("All Files", "*.*",null)];
		
	}
}