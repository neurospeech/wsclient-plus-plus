using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.IO;

namespace WSClientWeb
{
    public class Utils
    {
        #region Method Log
        private static object LockObject = new object();
        public static void Log(params Exception[] exs)
        {
            StringBuilder sb = new StringBuilder();
            foreach (Exception ex in exs)
                sb.AppendLine(ex.ToString());
            Log(sb.ToString());
        }
        #endregion

        public static void Log(string lines)
        {
            Log(lines, false);
        }

        public static void Log(string lines, bool logData)
        {
            lock (LockObject)
            {
                string logFile = HttpContext.Current.Server.MapPath("/logs/");
                DateTime now = DateTime.Today;
                logFile += string.Format("{0}-{1:00}-{2:00}.txt", now.Year, now.Month, now.Day);
                StreamWriter sw = new StreamWriter(logFile, true);
                sw.WriteLine();
                HttpRequest request = HttpContext.Current.Request;
                sw.WriteLine("Url      :" + request.Url.ToString());
                sw.WriteLine("Agent    :" + request.UserAgent);
                sw.WriteLine("Host     :" + request.UserHostAddress);
                sw.WriteLine("Time     :" + DateTime.Now.ToString());
                if (HttpContext.Current.User != null)
                    sw.WriteLine("User     :" + HttpContext.Current.User.Identity.Name);
                if (request.UrlReferrer != null)
                    sw.WriteLine("Referral :" + request.UrlReferrer.ToString());
                if (logData)
                {
                    sw.WriteLine("Request: ");
                    foreach (string key in request.Form.Keys)
                    {
                        sw.WriteLine("\t" + key + " : " + request.Form[key]);
                    }
                    request.InputStream.Position = 0;
                    StreamReader sin = new StreamReader(request.InputStream);
                    sw.WriteLine(sin.ReadToEnd());
                    sin.Close();
                }
                /*foreach (Exception e in ex)
                {
                    sw.WriteLine();
                    sw.WriteLine(e.ToString());
                }*/

                // split in characters of max 100
                sw.WriteLine(lines);

                sw.WriteLine("-------------------------------------- END -----------------------------------");
                sw.Close();
            }
        }
    }
}