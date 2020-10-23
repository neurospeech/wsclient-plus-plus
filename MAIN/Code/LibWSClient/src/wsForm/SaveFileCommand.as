package wsForm
{
	import com.neuro.command.GenericCommand;
	
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	public class SaveFileCommand extends GenericCommand
	{
		public function SaveFileCommand(target:IEventDispatcher=null)
		{
			super(target);
			this.showBusyDialog = false;
		}
		
		public override function invokeCommand():void
		{
			var f:File = File.documentsDirectory;
			f.addEventListener(Event.SELECT, onFileSelected, false, 0 , true);
			f.browseForSave(title);
		}
		
		private function onFileSelected(fe:Event):void
		{
			var f2:File = fe.target as File;
			lastFile = f2;
			super.dispatchResult(f2);
		}
		
		[Bindable]
		public var lastFile:File = null;
		
		public var title:String = "Save file";
		
		
		
	}
}