package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class ListProductsResponse extends WSObject
{
	
	private java.util.Vector _ListProductsResult = new java.util.Vector();
	public java.util.Vector getListProductsResult(){
		return _ListProductsResult;
	}
	public void setListProductsResult(java.util.Vector value){
		_ListProductsResult = value;
	}
	
	public static ListProductsResponse loadListProductsResponseFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		ListProductsResponse result = new ListProductsResponse();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
		NodeList list;
		int i;
		list = WSHelper.getElementChildren(root, "ListProductsResult");
		if(list != null)
		{
			for(i=0;i<list.getLength();i++)
			{
				Element nc = (Element)list.item(i);
				_ListProductsResult.addElement(Product.loadProductFrom(nc));
			}
		}
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("ListProductsResponse");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
		if(_ListProductsResult != null)
			ws.addChildArray(e,"ListProductsResult",null, _ListProductsResult);
	}
	
}
