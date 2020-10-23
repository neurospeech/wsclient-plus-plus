using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;
using WSClientCloudService.Controllers;

namespace WSClientCloudService.Areas.Admin.Controllers
{

    public class SecureController : DbController
    {
        protected override void OnAuthorization(System.Web.Mvc.AuthorizationContext filterContext)
        {
            base.OnAuthorization(filterContext);

            if (!User.Identity.IsAuthenticated)
            {
                filterContext.Result = new RedirectResult("https://" + Request.Url.Host + "/admin/user/login");
            }
        }
    }

    public class HomeController : SecureController
    {
        public ActionResult Index() {

            return View();
        }
    }
}
