package gen;

import com.neurospeech.wsclient.*;
import org.w3c.dom.*;

public class OrderServiceAsync extends SoapWebService {
	
	
	
	public OrderServiceAsync(){
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
	
	
	public class ListProductsResultHandler extends ResultHandler
	{
		
		protected final void onServiceResult()
		{
			onResult((java.util.Vector)__result);
		}
		
		protected void onResult(java.util.Vector result){}
		
	}
	
	
	class ListProductsRequest extends com.neurospeech.wsclient.ServiceRequest
	{
		
		ListProductsRequest( ListProductsResultHandler handler)
		{
			super(handler);
		}
		
		public void executeRequest() throws Exception
		{
			SoapRequest req = buildSoapRequest("http://tempuri.org/IOrderService/ListProducts");
			WSHelper ws = new WSHelper(req.document);
			ListProducts ____method = new ListProducts();
			req.method = ____method.toXMLElement(ws,req.root);
			SoapResponse sr = getSoapResponse(req);
			ListProductsResponse __response = ListProductsResponse.loadListProductsResponseFrom((Element)sr.body.getFirstChild());
			__result = __response.getListProductsResult();
		}
		
	}
	
	public void ListProducts( ListProductsResultHandler handler)
	{
		ListProductsRequest r = new ListProductsRequest(handler);
		r.executeAsync();
	}
	
	
	public class VerifyProductsResultHandler extends ResultHandler
	{
		
		protected final void onServiceResult()
		{
			onResult((String)__result);
		}
		
		protected void onResult(String result){}
		
	}
	
	
	class VerifyProductsRequest extends com.neurospeech.wsclient.ServiceRequest
	{
		java.util.Vector ids;
		
		VerifyProductsRequest(java.util.Vector ids, VerifyProductsResultHandler handler)
		{
			super(handler);
			this.ids = ids;
		}
		
		public void executeRequest() throws Exception
		{
			SoapRequest req = buildSoapRequest("http://tempuri.org/IOrderService/VerifyProducts");
			WSHelper ws = new WSHelper(req.document);
			VerifyProducts ____method = new VerifyProducts();
			____method.setids(ids);
			req.method = ____method.toXMLElement(ws,req.root);
			SoapResponse sr = getSoapResponse(req);
			VerifyProductsResponse __response = VerifyProductsResponse.loadVerifyProductsResponseFrom((Element)sr.body.getFirstChild());
			__result = __response.getVerifyProductsResult();
		}
		
	}
	
	public void VerifyProducts(java.util.Vector ids, VerifyProductsResultHandler handler)
	{
		VerifyProductsRequest r = new VerifyProductsRequest(ids,handler);
		r.executeAsync();
	}
	
	
	public class GetNewResultHandler extends ResultHandler
	{
		
		protected final void onServiceResult()
		{
			onResult((DataObject)__result);
		}
		
		protected void onResult(DataObject result){}
		
	}
	
	
	class GetNewRequest extends com.neurospeech.wsclient.ServiceRequest
	{
		Product p;
		
		GetNewRequest(Product p, GetNewResultHandler handler)
		{
			super(handler);
			this.p = p;
		}
		
		public void executeRequest() throws Exception
		{
			SoapRequest req = buildSoapRequest("http://tempuri.org/IOrderService/GetNew");
			WSHelper ws = new WSHelper(req.document);
			GetNew ____method = new GetNew();
			____method.setp(p);
			req.method = ____method.toXMLElement(ws,req.root);
			SoapResponse sr = getSoapResponse(req);
			GetNewResponse __response = GetNewResponse.loadGetNewResponseFrom((Element)sr.body.getFirstChild());
			__result = __response.getGetNewResult();
		}
		
	}
	
	public void GetNew(Product p, GetNewResultHandler handler)
	{
		GetNewRequest r = new GetNewRequest(p,handler);
		r.executeAsync();
	}
	
	
}
