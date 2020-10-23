package wsClasses
{
	public class AS4Generator extends AS3Generator
	{
		public function AS4Generator()
		{
			super();
		}
		
		protected override function includeClassImports(sw:StringWriter):void
		{
			sw.add("import mx.utils.ObjectProxy;");
			sw.add("import flash.utils.ByteArray;");
			sw.add("import mx.collections.ArrayCollection;");
			sw.add("import mx.rpc.soap.types.*;");
			sw.add("import com.neuro.service.*;");
			sw.add("import com.neuro.utils.*;");
			//sw.add("import ui.atoms.utils.NSArrayCollection;");
			//sw.add("import ui.atoms.service.NSWebService;");
			//sw.add("import ui.atoms.service.WSObject;");
		}
		
		protected override function includeRequestObjectImports(sw:StringWriter):void
		{
			sw.add("import mx.utils.ObjectProxy;");
			sw.add("import flash.events.Event;");
			sw.add("import mx.rpc.soap.types.*;");
			sw.add("import com.neuro.utils.*;");
			//sw.add("import ui.atoms.utils.NSArrayCollection;");
		}
		
		protected override function includeServiceImports(sw:StringWriter):void
		{
			sw.add("import com.neuro.service.*;");
			sw.add("import mx.rpc.AsyncToken;");
			sw.add("import mx.rpc.events.ResultEvent;");
			sw.add("import com.neuro.utils.*;");
			//sw.add("import ui.atoms.utils.NSArrayCollection;");
		} 
		
	}
}