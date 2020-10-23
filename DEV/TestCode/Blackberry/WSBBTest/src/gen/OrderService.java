package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class OrderService extends SoapWebService{
	
	
	public OrderService(){
		this.setUrl("/OrderService.svc");
	}
	
	protected String getNamespaces()
	{
		return 
		" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \r\n" + 
		" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \r\n" + 
		" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" \r\n" + 
		" xmlns:ns4=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\" \r\n" + 
		" xmlns:ns5=\"http://schema3\" \r\n" + 
		" xmlns:ns6=\"http://schema2\" \r\n" + 
		" xmlns:ns7=\"http://schema1\" \r\n" + 
		" xmlns:ns8=\"http://schemas.microsoft.com/2003/10/Serialization/\" \r\n" + 
		" xmlns=\"http://tempuri.org/\" \r\n" + 
		 "" ;
	}
	
	protected void appendNamespaces(Element e)
	{
		e.setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
		e.setAttribute("xmlns:xsd", "http://www.w3.org/2001/XMLSchema");
		e.setAttribute("xmlns:soap", "http://schemas.xmlsoap.org/soap/envelope/");
		e.setAttribute("xmlns:ns4", "http://schemas.microsoft.com/2003/10/Serialization/Arrays");
		e.setAttribute("xmlns:ns5", "http://schema3");
		e.setAttribute("xmlns:ns6", "http://schema2");
		e.setAttribute("xmlns:ns7", "http://schema1");
		e.setAttribute("xmlns:ns8", "http://schemas.microsoft.com/2003/10/Serialization/");
		e.setAttribute("xmlns", "http://tempuri.org/");
	}
	
	
	public java.util.Vector ListProducts() throws Exception 
	{
		SoapRequest req = buildSoapRequest("http://tempuri.org/IOrderService/ListProducts");
		WSHelper ws = new WSHelper(req.document);
		ListProducts ____method = new ListProducts();
		req.method = ____method.toXMLElement(ws,req.root);
		SoapResponse sr = getSoapResponse(req);
		ListProductsResponse __response = ListProductsResponse.loadListProductsResponseFrom((Element)sr.body.getFirstChild());
		return  __response.getListProductsResult();
	}
	
	public String VerifyProducts(java.util.Vector ids) throws Exception 
	{
		SoapRequest req = buildSoapRequest("http://tempuri.org/IOrderService/VerifyProducts");
		WSHelper ws = new WSHelper(req.document);
		VerifyProducts ____method = new VerifyProducts();
		____method.setids(ids);
		req.method = ____method.toXMLElement(ws,req.root);
		SoapResponse sr = getSoapResponse(req);
		VerifyProductsResponse __response = VerifyProductsResponse.loadVerifyProductsResponseFrom((Element)sr.body.getFirstChild());
		return  __response.getVerifyProductsResult();
	}
	
	public DataObject GetNew(Product p) throws Exception 
	{
		SoapRequest req = buildSoapRequest("http://tempuri.org/IOrderService/GetNew");
		WSHelper ws = new WSHelper(req.document);
		GetNew ____method = new GetNew();
		____method.setp(p);
		req.method = ____method.toXMLElement(ws,req.root);
		SoapResponse sr = getSoapResponse(req);
		GetNewResponse __response = GetNewResponse.loadGetNewResponseFrom((Element)sr.body.getFirstChild());
		return  __response.getGetNewResult();
	}
	
}
