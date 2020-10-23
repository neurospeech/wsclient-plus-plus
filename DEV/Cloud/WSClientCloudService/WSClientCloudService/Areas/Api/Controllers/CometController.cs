using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading;
using System.Transactions;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using WSClientCloudService.Models;

namespace WSClientCloudService.Areas.Api.Controllers
{
    public class CometController : SecureController
    {

        public static BlockingCollection<long> Jobs = new BlockingCollection<long>();

        static CometController() {
            Update();
        }


        public static Func<Expression<Func<WSJob,bool>>> Queued = ()=>{
            DateTime utcNow = DateTime.UtcNow.AddMinutes(-1);
            return x => x.JobStatus == "Queued" || (x.JobStatus == "Assigned" && x.EndTime < utcNow);
        };

        public static void Update() {
            using (WSClientModelEntities db = new WSClientModelEntities()) {

                var list = Jobs.ToList();

                foreach (var job in db.WSJobs.Where(Queued()).Where(x=>! list.Contains(x.JobID) ).Select(x=>x.JobID).ToList())
                {
                    Jobs.Add(job);
                }
            }
        }

        public ActionResult Fetch()
        {
            return new CometResult(FetchResult);
        }

        public ActionResult Settings() {
            return JsonResult(DB.Settings.Select(x => new { x.Key, x.Value}).ToList());
        }

        private static void FetchResult(ControllerContext context) {
            
            TimeSpan ts = TimeSpan.FromSeconds(10);

            var User = context.HttpContext.User;
            var Response = context.HttpContext.Response;

            string username = User.Identity.Name;

            long jobID;

            AtomJavaScriptSerializer js = new AtomJavaScriptSerializer(null);

            Response.Output.WriteLine("{ 'JobID': 0, 'Message': 'Welcome' }");
            Response.Flush();

            Update();

            do
            {

                if (!Response.IsClientConnected)
                    break;


                if (!Jobs.TryTake(out jobID, ts))
                {
                    Response.Output.WriteLine("{ 'JobID': 0, 'Message':'None' }");
                    Response.Flush();
                    Update();
                    continue;
                }

                using (WSClientModelEntities db = new WSClientModelEntities())
                {
                    using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, TimeSpan.FromSeconds(60)))
                    {
                        DateTime utcNow = DateTime.UtcNow;

                        WSJob job = db.WSJobs.Where(Queued()).FirstOrDefault(x => x.JobID == jobID);
                        if (job == null)
                            continue;

                        job.AssigneeID = username;
                        job.JobStatus = "Assigned";
                        job.EndTime = DateTime.UtcNow;

                        var s = js.Serialize(new { 
                            job.JobID,
                            job.JobStatus,
                            job.WSDLUrl,
                            job.IsDemo,
                            job.OutputType,
                            job.OutputTarget,
                            job.OutputPrefix,
                            job.OutputPackage
                        });



                        Response.Output.WriteLine(s);
                        Response.Flush();

                        db.SaveChanges();
                        
                        scope.Complete();
                    }
                }



            } while (true);

        }


        public class CometResult : ActionResult {

            public Action<ControllerContext> CommetAction;

            public CometResult(Action<ControllerContext> a)
            {
                CommetAction = a;
            }

            public override void ExecuteResult(ControllerContext context)
            {
                CommetAction(context);
            }
        }

    }


}
