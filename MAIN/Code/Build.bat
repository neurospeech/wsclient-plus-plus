CALL D:\Desktop\AdobeAIRSDK\bin\adt -package -target native d:\Publish\WSClient\WSClientForCocoa.exe d:\publish\WSClient\WSClientForCocoa.air
CALL D:\Desktop\AdobeAIRSDK\bin\adt -package -target native d:\Publish\WSClient\WSClientForFlash.exe d:\publish\WSClient\WSClientForFlash.air
CALL D:\Desktop\AdobeAIRSDK\bin\adt -package -target native d:\Publish\WSClient\WSClientForJava.exe d:\publish\WSClient\WSClientForJava.air
CALL D:\Desktop\AdobeAIRSDK\bin\adt -package -target native d:\Publish\WSClient\WSClientForMobile.exe d:\publish\WSClient\WSClientForMobile.air
CALL D:\Desktop\AdobeAIRSDK\bin\adt -package -target native d:\Publish\WSClient\WSClientSuite.exe d:\publish\WSClient\WSClientSuite.air

copy d:\Publish\WSClient\WSClientForCocoa.* i:\neurospeech\wsclient
copy d:\Publish\WSClient\WSClientForFlash.* i:\neurospeech\wsclient
copy d:\Publish\WSClient\WSClientForJava.* i:\neurospeech\wsclient
copy d:\Publish\WSClient\WSClientForMobile.* i:\neurospeech\wsclient
copy d:\Publish\WSClient\WSClientSuite.* i:\neurospeech\wsclient
