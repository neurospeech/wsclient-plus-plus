package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class VerifyProducts extends WSObject
{
	
	private java.util.Vector _ids = new java.util.Vector();
	public java.util.Vector getids(){
		return _ids;
	}
	public void setids(java.util.Vector value){
		_ids = value;
	}
	
	public static VerifyProducts loadVerifyProductsFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		VerifyProducts result = new VerifyProducts();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
		NodeList list;
		int i;
		list = WSHelper.getElementChildren(root, "ids");
		if(list != null)
		{
			for(i=0;i<list.getLength();i++)
			{
				Element nc = (Element)list.item(i);
				_ids.addElement(WSHelper.getLong(nc,null,false));
			}
		}
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("VerifyProducts");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
		if(_ids != null)
			ws.addChildArray(e,"ids","ns4:long",_ids);
	}
	
}
