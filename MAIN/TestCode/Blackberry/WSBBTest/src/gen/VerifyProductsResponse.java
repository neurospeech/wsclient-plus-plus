package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class VerifyProductsResponse extends WSObject
{
	
	private String _VerifyProductsResult;
	public String getVerifyProductsResult(){
		return _VerifyProductsResult;
	}
	public void setVerifyProductsResult(String value){
		_VerifyProductsResult = value;
	}
	
	public static VerifyProductsResponse loadVerifyProductsResponseFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		VerifyProductsResponse result = new VerifyProductsResponse();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
		this.setVerifyProductsResult(WSHelper.getString(root,"VerifyProductsResult",false));
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("VerifyProductsResponse");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
		ws.addChild(e,"VerifyProductsResult",String.valueOf(_VerifyProductsResult),false);
	}
	
}
