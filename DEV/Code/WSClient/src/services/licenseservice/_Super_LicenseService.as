/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this service wrapper you may modify the generated sub-class of this class - LicenseService.as.
 */
package services.licenseservice
{
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.services.wrapper.WebServiceWrapper;
import com.adobe.serializers.utility.TypeUtility;
import mx.rpc.AbstractOperation;
import mx.rpc.AsyncToken;
import mx.rpc.soap.mxml.Operation;
import mx.rpc.soap.mxml.WebService;
import valueObjects.LicenseResult;

[ExcludeClass]
internal class _Super_LicenseService extends com.adobe.fiber.services.wrapper.WebServiceWrapper
{
    
    // Constructor
    public function _Super_LicenseService()
    {
        // initialize service control
        _serviceControl = new mx.rpc.soap.mxml.WebService();
        var operations:Object = new Object();
        var operation:mx.rpc.soap.mxml.Operation;

        operation = new mx.rpc.soap.mxml.Operation(null, "GetLicense");
         operation.resultType = valueObjects.LicenseResult;
        operations["GetLicense"] = operation;

        operation = new mx.rpc.soap.mxml.Operation(null, "Deactivate");
         operation.resultType = valueObjects.LicenseResult;
        operations["Deactivate"] = operation;

        _serviceControl.operations = operations;
        try
        {
            _serviceControl.convertResultHandler = com.adobe.serializers.utility.TypeUtility.convertResultHandler;
        }
        catch (e: Error)
        { /* Flex 3.4 and earlier does not support the convertResultHandler functionality. */ }


        preInitializeService();
        model_internal::initialize();
    }
    
    //init initialization routine here, child class to override
    protected function preInitializeService():void
    {


        _serviceControl.service = "LicenseService";
        _serviceControl.port = "LicenseServiceSoap";
        wsdl = "http://store.neurospeech.com/Service/LicenseService.asmx?WSDL";
        model_internal::loadWSDLIfNecessary();
    }
    

    /**
      * This method is a generated wrapper used to call the 'GetLicense' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function GetLicense(productUID:String, version:String, emailAddress:String, licenseCode:String, upgradeCode:String, computerName:String) : mx.rpc.AsyncToken
    {
        model_internal::loadWSDLIfNecessary();
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("GetLicense");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(productUID,version,emailAddress,licenseCode,upgradeCode,computerName) ;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'Deactivate' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function Deactivate(orderID:Number, computerName:String) : mx.rpc.AsyncToken
    {
        model_internal::loadWSDLIfNecessary();
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("Deactivate");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(orderID,computerName) ;
        return _internal_token;
    }
     
}

}
