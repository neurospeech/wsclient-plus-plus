using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;
using System.Web.Security;
using WSClientCloudService.Controllers;

namespace WSClientCloudService.Areas.Admin.Controllers
{
    public class UserController : DbController
    {

        public ActionResult Login(string redirectUrl) {
            return View();
        }

        [HttpPost]
        public ActionResult Login() 
        {

            string userName = FormValue<string>("Username");
            string password = FormValue<string>("Password");
            bool persist = FormValue<bool>("RememberMe", true, false);
            string redirectUrl = FormValue<string>("RedirectUrl", true, "/admin/");
            var user = DB.WSUsers.FirstOrDefault(x => x.UserID == userName);
            if (user == null)
                return JsonError("Invalid Username");

            if (user.PasswordHash != password)
                return JsonError("Invalid Password");

            FormsAuthentication.SetAuthCookie(userName, persist);

            return JsonResult(new { 
                RedirectUrl = redirectUrl
            });
        }

    }
}
