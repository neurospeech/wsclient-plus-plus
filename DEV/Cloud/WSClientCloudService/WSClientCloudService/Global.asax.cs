using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Script.Serialization;
using WSClientCloudService.Models;

namespace WSClientCloudService
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);

            using (WSClientModelEntities db = new WSClientModelEntities()) {
                if (!db.WSUsers.Any()) {
                    var user = new WSUser { EmailAddress="ackava@gmail.com" , UserID = "ackava@gmail.com", PasswordHash = "change-me" };
                    db.WSUsers.AddObject(user);
                    db.SaveChanges();
                }
            }
        }
    }

    public class AppSettings{

        public static AppSettings Instance = new AppSettings();

        private Dictionary<string, object> Values = new Dictionary<string, object>();

        private AppSettings()
        {
            JavaScriptSerializer js = new JavaScriptSerializer();

            using (WSClientModelEntities db = new WSClientModelEntities()) {
                foreach (var pair in db.Settings.ToList()) {
                    Values[pair.Key] = pair.Value;
                }
            }
        }

        public T GetValue<T>(string key, T def = default(T)) {
            object val = null;
            Type valueType = typeof(T);
            if (!Values.TryGetValue(key, out val))
                return def;
            if (val == null)
                return def;
            if (val.GetType() == valueType)
                return (T)val;
            return (T)Convert.ChangeType(val, valueType);
        }

        public string XMashapeProxySecret {
            get {
                return GetValue<string>("X-Mashape-Proxy-Secret");
            }
        }
    }
}