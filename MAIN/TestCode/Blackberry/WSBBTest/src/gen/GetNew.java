package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class GetNew extends WSObject
{
	
	private Product _p;
	public Product getp(){
		return _p;
	}
	public void setp(Product value){
		_p = value;
	}
	
	public static GetNew loadGetNewFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		GetNew result = new GetNew();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
		this.setp(Product.loadProductFrom(WSHelper.getElement(root,"p")));
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("GetNew");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
		if(_p != null)
			ws.addChildNode(e, "p",null,_p);
	}
	
}
