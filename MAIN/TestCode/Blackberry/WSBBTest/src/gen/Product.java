package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class Product extends WSObject
{
	
	private String _Name;
	public String getName(){
		return _Name;
	}
	public void setName(String value){
		_Name = value;
	}
	private DataObject _Object;
	public DataObject getObject(){
		return _Object;
	}
	public void setObject(DataObject value){
		_Object = value;
	}
	private String _ProductID;
	public String getProductID(){
		return _ProductID;
	}
	public void setProductID(String value){
		_ProductID = value;
	}
	private String _Type;
	public String getType(){
		return _Type;
	}
	public void setType(String value){
		_Type = value;
	}
	
	public static Product loadProductFrom(Element root) throws Exception
	{
		if(root==null){
			return null;
		}
		Product result = new Product();
		result.load(root);
		return result;
	}
	
	
	protected void load(Element root) throws Exception
	{
		this.setName(WSHelper.getString(root,"Name",false));
		this.setObject(DataObject.loadDataObjectFrom(WSHelper.getElement(root,"Object")));
		this.setProductID(WSHelper.getString(root,"ProductID",false));
		this.setType(WSHelper.getString(root,"Type",false));
	}
	
	
	
	public Element toXMLElement(WSHelper ws, Element root)
	{
		Element e = ws.createElement("ns7:Product");
		fillXML(ws,e);
		return e;
	}
	
	public void fillXML(WSHelper ws,Element e)
	{
		ws.addChild(e,"ns7:Name",String.valueOf(_Name),false);
		if(_Object != null)
			ws.addChildNode(e, "ns7:Object",null,_Object);
		ws.addChild(e,"ns7:ProductID",String.valueOf(_ProductID),false);
		ws.addChild(e,"ns7:Type",String.valueOf(_Type),false);
	}
	
}
