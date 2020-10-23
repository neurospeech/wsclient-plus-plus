package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class DataObject extends WSObject
{
	
	private String _ObjectName;
	public String getObjectName(){
		return _ObjectName;
	}
	public void setObjectName(String value){
		_ObjectName = value;
	}
	
	public static DataObject loadDataObjectFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		DataObject result = new DataObject();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
		this.setObjectName(WSHelper.getString(root,"ObjectName",false));
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("ns6:DataObject");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
		ws.addChild(e,"ns6:ObjectName",String.valueOf(_ObjectName),false);
	}
	
}
