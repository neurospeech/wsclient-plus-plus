using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using WSClientCloudService.Models;

namespace WSClientCloudService.Controllers
{
    public abstract class DbController : NeuroSpeech.WebAtoms.Mvc.WebAtomsController<WSClientModelEntities>
    {

        protected override Dictionary<string, object> FormModel
        {
            get
            {
                if (_FormModel == null) {
                    if (!System.Text.RegularExpressions.Regex.IsMatch(Request.ContentType, "application\\/json", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
                        return base.FormModel;
                    JavaScriptSerializer js = new JavaScriptSerializer();
                    var s = Request.InputStream;
                    s.Seek(0, System.IO.SeekOrigin.Begin);
                    using (StreamReader sr = new StreamReader(s)) {
                        string content = sr.ReadToEnd();
                        _FormModel = (Dictionary<string, object>)js.Deserialize(content, typeof(object));
                    }
                }
                return _FormModel;
            }
        }

        protected WSClientModelEntities DB {
            get {
                return ObjectContext;
            }
        }

        protected override void Log(Exception ex)
        {
            try
            {
                DateTime now = DateTime.UtcNow;
                string filePath = Server.MapPath("/logs") + string.Format("\\log-{0:0000}-{1:00}-{2:00}.txt", now.Year, now.Month, now.Day);
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.AppendLine(now + " - " + Request.RawUrl);
                sb.AppendLine(now + " - " + ex.ToString());
                System.IO.File.AppendAllText(filePath, sb.ToString());
            }
            catch { }
        }
        

        protected override void OnAuthorization(AuthorizationContext filterContext)
        {
            base.OnAuthorization(filterContext);

            if (User.Identity.IsAuthenticated)
                return;

            var mashapeProxy = Request.Headers["X-Mashape-Proxy-Secret"] as string;
            if (mashapeProxy == AppSettings.Instance.XMashapeProxySecret)
            {
                var mashapeUser = (Request.Headers["X-Mashape-User"] as string) + "@user.mashape.com";
                using (WSClientModelEntities db = new WSClientModelEntities())
                {
                    var user = db.WSUsers.FirstOrDefault(x => x.UserID == mashapeUser);
                    if (user == null)
                    {
                        user = new WSUser { UserID = mashapeUser, PasswordHash = AppSettings.Instance.XMashapeProxySecret };
                        db.WSUsers.AddObject(user);
                        db.SaveChanges();
                    }

                    SetUser("Mashape", true, user.UserID);
                    return;
                }
            }

            var wsUser = Request.Headers["X-WSClient-Username"] as string;
            if (wsUser != null)
            {
                var wsHash = Request.Headers["X-WSClient-PasswordHash"] as string;
                using (WSClientModelEntities db = new WSClientModelEntities())
                {
                    var user = db.WSUsers.FirstOrDefault(x => x.UserID == wsUser && x.PasswordHash == wsHash);
                    if (user != null)
                    {
                        SetUser("WSClient", true, user.UserID);
                        return;
                    }
                    else
                    {
                        throw new AccessViolationException();
                    }
                }
            }

            SetUser();
        }

        private void SetUser(string authenticationType = "Anonymous", bool isAuthenticated=false, string userName= "Anonymous")
        {
            if (isAuthenticated)
            {
                DB.UserID = userName;
            }

            ControllerContext.HttpContext.User = new ServiceUser(authenticationType, isAuthenticated, userName);
            
        }


    }


    public class ServiceUser : IPrincipal
    {
        public ServiceUser(string authType = "Anonymous", bool authenticated = false, string name = "Anonymous")
        {
            Identity = new ServiceIdentity(authType, authenticated, name);
        }

        public IIdentity Identity
        {
            get;
            private set;
        }

        public bool IsInRole(string role)
        {
            throw new NotImplementedException();
        }

        public class ServiceIdentity : IIdentity
        {

            public ServiceIdentity(string authType, bool authenticated, string name)
            {
                AuthenticationType = authType;
                IsAuthenticated = authenticated;
                Name = name;
            }

            public string AuthenticationType
            {
                get;
                private set;
            }

            public bool IsAuthenticated
            {
                get;
                private set;
            }

            public string Name
            {
                get;
                private set;
            }
        }
    }
}
