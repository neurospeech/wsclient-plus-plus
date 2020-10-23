package nslm
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.controls.Alert;
	
	[Event(name="exit", type="flash.events.Event")]
	public class HostNameProvider extends EventDispatcher
	{
		public function HostNameProvider()
		{
			
		}
		public function getHostName():void {
			if(NativeProcess.isSupported) {
				var OS:String = Capabilities.os.toLocaleLowerCase();
				var file:File;
				
				if (OS.indexOf('win') > -1) {
					//Executable in windows
					file = new File('c:\\windows\\System32\\hostname.exe');
				} else if (OS.indexOf('mac') > -1 ) {
					file = new File('/bin/hostname');
				} else if (OS.indexOf('linux')) {
					//Executable in linux
					file = new File('/bin/hostname');
				}
				
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = file;
				
				var process:NativeProcess = new NativeProcess();
				process.addEventListener(NativeProcessExitEvent.EXIT, onExitError);
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutput);
				process.start(nativeProcessStartupInfo);
				process.closeInput();
			} else{
				
				Alert.show("Not supported");
				
				this.hostName= "Akash-PC";
				this.dispatchEvent(new Event("exit"));
			}
		}
		
		public function onExitError(event:NativeProcessExitEvent):void
		{
			
			this.dispatchEvent(event);
		}
		
		public var hostName:String = "";
		
		public function onOutput(event:ProgressEvent):void {
			var strHelper:StringHelper = new StringHelper();
			var output:String = event.target.standardOutput.readUTFBytes(event.target.standardOutput.bytesAvailable);
			output = strHelper.trimBack(output, "\n");
			output = strHelper.trimBack(output, "\r");
			hostName = output;
			//Alert.show(output);
		}
	}
}