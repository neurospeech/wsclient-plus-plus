using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;
using WSClientCloudService.Controllers;
using WSClientCloudService.Models;
using WSClientCloudService.Security;

namespace WSClientCloudService.Areas.Api.Controllers
{
    public class JobsController : DbController
    {

        protected override NeuroSpeech.WebAtoms.Entity.BaseSecurityContext CreateSecurityContext()
        {
            return DefaultSecurityContext.Instance;
        }

        public const string Header = "X-Mashape-Billing";


        public ActionResult Create(
            string wsdl, 
            string outputType="java", 
            string outputTarget = "android",
            string outputPackage = "wsclient.gen",
            string outputPrefix = "",
            string triggerEmail = null,
            string triggerUrl = null,
            bool demo = false
            ) 
        {
            if (!User.Identity.IsAuthenticated)
            {
                demo = true;

                wsdl = FormValue<string>("wsdl", true, wsdl);
                outputType = FormValue<string>("outputType", true, outputType);
                outputTarget = FormValue<string>("outputTarget", true, outputTarget);
                outputPackage = FormValue<string>("outputPackage", true, outputPackage);
                outputPrefix = FormValue<string>("outputPrefix", true, outputPrefix);
            }
            else 
            {
                Response.Headers.Add(Header, "Code Generation=1");
            }

            if (!Regex.IsMatch(wsdl, "^(http|https)\\:\\/\\/", RegexOptions.Compiled | RegexOptions.IgnoreCase))
                return JsonError("Invalid WSDL URL");

            if (!IsXml(wsdl))
                return JsonError("Invalid WSDL URL - WSDL URL does not point to a valid XML");

            if (!Regex.IsMatch(outputType, "java", RegexOptions.IgnoreCase | RegexOptions.Compiled)) {
                outputPackage = "";
            }

            WSJob job = new WSJob { 
                WSDLUrl = wsdl,
                IsDemo = demo,
                StartTime = DateTime.UtcNow,
                JobStatus = "Queued",
                OutputType = outputType,
                OutputPackage = outputPackage,
                OutputPrefix = outputPrefix,
                OutputTarget = outputTarget,
                TriggerEmail = triggerEmail,
                TriggerUrl = triggerUrl
            };
            if (User.Identity.IsAuthenticated)
                job.OwnerID = User.Identity.Name;

            using (DB.CreateSecurityScope(null))
            {
                DB.AddEntity(job);
                DB.Save();
            }

            // force update...
            CometController.Update();

            return JsonResult(job);
        }

        private bool IsXml(string wsdl)
        {
            try
            {
                using (WebClient client = new WebClient())
                {
                    string xml = client.DownloadString(wsdl);
                    XDocument.Parse(xml);
                }
                return true;
            }
            catch {
                return false;
            }
        }

        public ActionResult Status(long id) { 
            var job = DB.WSJobs.FirstOrDefault(x=>x.JobID == id);
            if (job == null)
                return HttpNotFound();
            return JsonResult(job);
        }

        public ActionResult List(int start = 0, int size = 100)
        {
            if (!User.Identity.IsAuthenticated)
                throw new UnauthorizedAccessException();
            string userName = User.Identity.Name;
            IQueryable<WSJob> jobs = DB.WSJobs.Where(x => x.OwnerID == userName).OrderByDescending(x=>x.JobID);
            if (start > 0) {
                jobs = jobs.Skip(start);
            }
            jobs = jobs.Take(size);
            return JsonResult(jobs.Select(x => new { 
                x.JobID,
                x.WSDLUrl,
                x.JobStatus,
                x.ResultUrl
            }));
        }


        [HttpPost]
        public ActionResult Update(long id) 
        {
            if (!User.Identity.IsAuthenticated || User.Identity.AuthenticationType != "WSClient")
                throw new UnauthorizedAccessException();

            using (DB.CreateSecurityScope(null))
            {
                var job = DB.WSJobs.FirstOrDefault(x => x.JobID == id);
                if (job.AssigneeID != User.Identity.Name)
                    throw new UnauthorizedAccessException();
                job.JobStatus = FormValue<string>("JobStatus");
                job.ResultUrl = FormValue<string>("ResultUrl");
                job.EndTime = DateTime.UtcNow;

                DB.SaveChanges();

                if(!string.IsNullOrWhiteSpace(job.TriggerEmail)){

                }

                if (!string.IsNullOrWhiteSpace(job.TriggerUrl)) {
                    try {
                        using (WebClient client = new WebClient()) { 
                            client.Headers[HttpRequestHeader.ContentType] = "application/json";
                            AtomJavaScriptSerializer js =new AtomJavaScriptSerializer(DefaultSecurityContext.Instance);
                            string result = js.Serialize(job);
                            client.UploadString(job.TriggerUrl, "POST", result);
                        }
                    }
                    catch
                    {
                    }
                }

                return JsonResult(job);

            }

        }

        

    }
}
