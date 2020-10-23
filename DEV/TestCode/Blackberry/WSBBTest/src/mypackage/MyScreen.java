package mypackage;

import java.util.Enumeration;
import java.util.Vector;

import gen.OrderService;
import net.rim.device.api.ui.container.MainScreen;

/**
 * A class extending the MainScreen class, which provides default standard
 * behavior for BlackBerry GUI applications.
 */
public final class MyScreen extends MainScreen
{
    /**
     * Creates a new MyScreen object
     */
    public MyScreen()
    {        
        // Set the displayed title of the screen       
        setTitle("MyTitle");
        
        
        try{
        	OrderService os = new OrderService();
        	os.setBaseUrl("http://wsclient.ns");
        
        	Vector list = os.ListProducts();
        	Enumeration en = list.elements();
        	while(en.hasMoreElements()){
        		Object obj = en.nextElement();
        		System.out.println(obj.toString());
        	}
        }catch(Exception ex){
        	ex.printStackTrace();
        }
        
    }
}
