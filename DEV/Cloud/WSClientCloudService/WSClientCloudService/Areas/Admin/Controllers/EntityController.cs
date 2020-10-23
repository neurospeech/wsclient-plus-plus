using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NeuroSpeech.WebAtoms.Mvc;
using WSClientCloudService.Models;

namespace WSClientCloudService.Areas.Admin.Controllers
{
    public class AdminSecurityContext : NeuroSpeech.WebAtoms.Entity.BaseSecurityContext<WSClientModelEntities>
    {
        public static AdminSecurityContext Instance = new AdminSecurityContext();

        public AdminSecurityContext()
        {
            this.IgnoreSecurity = true;
        }
    }

    public class EntityController : AtomEntityController<WSClientModelEntities>
    {

        protected override void OnAuthorization(AuthorizationContext filterContext)
        {
            base.OnAuthorization(filterContext);

            if (!User.Identity.IsAuthenticated)
                throw new UnauthorizedAccessException();
        }

        protected override NeuroSpeech.WebAtoms.Entity.BaseSecurityContext CreateSecurityContext()
        {
            return AdminSecurityContext.Instance;
        }

    }
}
