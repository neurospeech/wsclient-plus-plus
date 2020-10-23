package wsForm
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import com.neuro.command.GenericCommand;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;
	
	public class UpdateAppCommand extends GenericCommand
	{
		public function UpdateAppCommand(target:IEventDispatcher=null)
		{
			super(target);
			this.showBusyDialog = false;
		}
		
		private var appName:String = "";
		
		public override function invokeCommand():void
		{
			// load license
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespaceDeclarations()[0];
			appName = descriptor.ns::filename;
			
			updateApp();
		}
		
		private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		
		protected function updateApp():void
		{
			// we set the URL for the update.xml file 
			if(LICENSE::csdemo){
				appUpdater.updateURL = "http://account.neurospeech.com/Update/AirUpdate.ashx?EditionUID=com.neurospeech.wsclient.suite.cs";
			}else{
				appUpdater.updateURL = "http://account.neurospeech.com/Update/AirUpdate.ashx?EditionUID=com.neurospeech.wsclient.suite";
			}
			//we set the event handlers for INITIALIZED nad ERROR
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate);
			appUpdater.addEventListener(ErrorEvent.ERROR, onError);
			//we can hide the dialog asking for permission for checking for a new update;
			//if you want to see it just leave the default value (or set true).
			appUpdater.isCheckForUpdateVisible = true;
			//if isFileUpdateVisible is set to true, File Update, File No Update, 
			//and File Error dialog boxes will be displayed
			appUpdater.isFileUpdateVisible = true;
			//if isInstallUpdateVisible is set to true, the dialog box for installing the update is visible
			appUpdater.isInstallUpdateVisible = true;
			//we initialize the updater
			appUpdater.initialize();
		}
		
		/**
		 * Handler function triggered by the ApplicationUpdater.initialize;
		 * The updater was initialized and it is ready to take commands 
		 * (such as <code>checkNow()</code>
		 * @param UpdateEvent 
		 */ 
		private function onUpdate(event:UpdateEvent):void {
			//start the process of checking for a new update and to install
			appUpdater.checkNow();
		}
		
		/**
		 * Handler function for error events triggered by the ApplicationUpdater.initialize
		 * @param ErrorEvent 
		 */ 
		private function onError(event:ErrorEvent):void {
			Alert.show(event.toString());
		}
		
		
	}
}