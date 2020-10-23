package wsClasses
{
	import com.adobe.utils.StringUtil;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.utils.StringUtil;

	public class StringWriter
	{
		public function StringWriter()
		{
		}

		public var headerCode:String = "";
		
		public var code:String = "";
		
		public var codePad:String = "";
		
		public function indent():void
		{
			codePad += "\t";
		}
		
		public function startIfBrace(c:String):void
		{
			add("if("+c+"){");
			indent();
		}
		
		public function startBrace():void
		{
			add("{");
			indent();
		}
		
		public function appendElse():void
		{
			unindent();
			add("} else {");
			indent();
		}
		
		public function endBrace():void
		{
			unindent();
			add("}");
		}
		
		public function unindent():void
		{
			if(codePad.length>0)
				codePad = codePad.substring(1);
		}
		
		public function addHeader(line:String = ""):void
		{
			headerCode += line + "\n";
		}
		
		public function add(line:String=""):void
		{
			code += codePad + line + "\n";
		}
		
		public function addFormat(line:String, ... args):void{
			code += codePad + mx.utils.StringUtil.substitute(line,args) + "\n";
		}
		
		public function addIf(condition:String, line:String):void
		{
			add("if("+condition+"){");
			indent();
			add(line);
			unindent();
			add("}");
		}
		
		public function save(filePath:String):void
		{
			var f:File = new File(filePath);
			if(f.exists)
				f.deleteFile();
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.WRITE);
			fs.writeMultiByte(com.adobe.utils.StringUtil.replace(code,"$$HEADER$$",headerCode) , File.systemCharset);
			fs.close();
		}
	}
}