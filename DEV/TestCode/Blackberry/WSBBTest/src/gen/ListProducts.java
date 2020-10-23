package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class ListProducts extends WSObject
{
	
	
	public static ListProducts loadListProductsFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		ListProducts result = new ListProducts();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("ListProducts");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
	}
	
}
