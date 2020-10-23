package wsClasses
{
	import nslm.NSFeatureSet;

	public class License
	{
		public function License()
		{
		}
		
		public static var demo:Boolean = true;
		
		public static function get debug():Boolean{
			return false;
		}
		
		public static var features:NSFeatureSet = new NSFeatureSet();
		
		public static var version:String = "";
		
		public static var productUID:String = "";
		
	}
}