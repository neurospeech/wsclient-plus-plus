package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class GetNewResponse extends WSObject
{
	
	private DataObject _GetNewResult;
	public DataObject getGetNewResult(){
		return _GetNewResult;
	}
	public void setGetNewResult(DataObject value){
		_GetNewResult = value;
	}
	
	public static GetNewResponse loadGetNewResponseFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		GetNewResponse result = new GetNewResponse();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
		this.setGetNewResult(DataObject.loadDataObjectFrom(WSHelper.getElement(root,"GetNewResult")));
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("GetNewResponse");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
		if(_GetNewResult != null)
			ws.addChildNode(e, "GetNewResult",null,_GetNewResult);
	}
	
}
