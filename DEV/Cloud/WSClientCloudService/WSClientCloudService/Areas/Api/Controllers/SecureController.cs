using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using WSClientCloudService.Controllers;
using WSClientCloudService.Models;

namespace WSClientCloudService.Areas.Api.Controllers
{
    public abstract class SecureController : DbController
    {
        protected override void OnAuthorization(AuthorizationContext filterContext)
        {
            base.OnAuthorization(filterContext);

            if (!User.Identity.IsAuthenticated)
                throw new UnauthorizedAccessException();
        }
    }


}
