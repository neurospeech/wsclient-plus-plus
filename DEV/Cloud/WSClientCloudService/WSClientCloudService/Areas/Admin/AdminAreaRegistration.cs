using System.Web.Mvc;

namespace WSClientCloudService.Areas.Admin
{
    public class AdminAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Admin";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {

            context.MapRoute(
                "Admin_Entity",
                "Admin/Entity/{table}/{action}/{id}",
                new { controller = "Entity", action = "query", id = UrlParameter.Optional },
                new string[] { "WSClientCloudService.Areas.Admin.Controllers" }
            );

            context.MapRoute(
                "Admin_default",
                "Admin/{controller}/{action}/{id}",
                new { controller="Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
