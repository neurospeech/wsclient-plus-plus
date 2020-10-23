using Amazon.S3.Model;
using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Script.Serialization;

namespace WSClientSubscriber
{
    public class Comet
    {

        static string airFile = @"C:\Program Files (x86)\WSClientServiceApp\WSClientServiceApp.exe";

        static void SetupAuth(WebHeaderCollection headers){

            headers.Add("X-WSClient-Username", "ackava@gmail.com");
            headers.Add("X-WSClient-PasswordHash", "change-me");

        }

        public static Dictionary<string,string> Settings { get; set; }           

        public void Start() {

            FetchSettings();

            JavaScriptSerializer js = new JavaScriptSerializer();


            Console.WriteLine("Connecting to Comet");
            
            HttpWebRequest request = WebRequest.CreateHttp(Host + "/api/comet/fetch?_=" + DateTime.UtcNow.Ticks);
            SetupAuth(request.Headers);

            HttpWebResponse response = request.GetResponse() as HttpWebResponse;
            if(response.StatusCode != HttpStatusCode.OK){
                Console.WriteLine(response.StatusCode);
                Console.WriteLine(response.StatusDescription);
            }
            using(var s = response.GetResponseStream()){
                using (var sr = new StreamReader(s)) {

                    Console.WriteLine("Starting to read");

                    do
                    {



                        string line = sr.ReadLine();

                        try
                        {
                            var job = js.Deserialize<CometJob>(line);
                            if (job.JobID == 0)
                            {
                                Console.WriteLine(job.Message);
                                continue;
                            }
                            else {
                                Task.Run(() => {
                                    using (JobProcessor jp = new JobProcessor(job)) {
                                        jp.Execute();
                                    }
                                });
                            }

                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.ToString());
                            break;
                        }
                    } while (true);

                }
            }
        }

        private static Amazon.Runtime.BasicAWSCredentials S3Credentials = null;

        public static Amazon.S3.AmazonS3Client CreateS3Client() {
            return new Amazon.S3.AmazonS3Client(S3Credentials, Amazon.RegionEndpoint.USEast1);
        }

        private void FetchSettings()
        {
            if (Settings != null)
                return;

            using (WebClient client = new WebClient()) {
                SetupAuth(client.Headers);

                string text = client.DownloadString(Host + "/api/comet/settings");

                JavaScriptSerializer js = new JavaScriptSerializer();
                Settings = js.Deserialize<List<CometSetting>>(text).ToDictionary(x => x.Key, x => x.Value);
                
            }

            S3Credentials = new Amazon.Runtime.BasicAWSCredentials(Settings["Amazon-S3-ID"],Settings["Amazon-S3-Secret"]);
            
        }



        public static string Host = "https://wsclient.azurewebsites.net";

        public class JobProcessor : IDisposable
        {

            CometJob Job;
            DirectoryInfo TempFolder;
            DirectoryInfo ZipFolder;
            DirectoryInfo InputFolder;

            public JobProcessor(CometJob job)
            {
                Job = job;

                TempFolder = new DirectoryInfo(Path.GetTempPath() + "\\WSClientJobs\\" + GetNewKey());
                TempFolder.Create();
                ZipFolder = new DirectoryInfo(TempFolder.FullName + "\\zip");
                ZipFolder.Create();
                InputFolder = new DirectoryInfo(TempFolder.FullName + "\\input");
                InputFolder.Create();
            }

            private string CreateOutputFile(string name) {
                return ZipFolder.FullName + "\\" + name;                    
            }

            private string CreateInputFile(string name) {
                return InputFolder.FullName + "\\" + name;
            }

            public void SaveJob(string status)
            {

                string zipPath = TempFolder.FullName + "\\output.zip";
                string awsUrl = "";
                using (FileStream zf = File.OpenWrite(zipPath))
                {
                    using (ZipOutputStream zfs = new ZipOutputStream(zf))
                    {
                        AddFiles(zfs, ZipFolder);
                        if (status == "Success")
                        {
                            if (Regex.IsMatch(Job.OutputType, "objc", RegexOptions.Compiled| RegexOptions.IgnoreCase))
                            {
                                AddResource(zfs, "NSWSDL.h", LibResources.NSWSDL_H);
                                AddResource(zfs, "NSWSDL.M", LibResources.NSWSDL_M);
                                AddResource(zfs, "help.html", LibResources.objc_help);
                            }
                            else 
                            {
                                if (Regex.IsMatch(Job.OutputTarget, "android", RegexOptions.Compiled | RegexOptions.IgnoreCase))
                                {
                                    AddResource(zfs, "wsclient.android.jar", LibResources.wsclient_android);
                                }
                                else if (Regex.IsMatch(Job.OutputTarget, "blackberry", RegexOptions.Compiled | RegexOptions.IgnoreCase))
                                {
                                    AddResource(zfs, "wsclient.blackberry.jar", LibResources.wsclient_blackberry);
                                }
                                else {
                                    AddResource(zfs, "wsclient.jar", LibResources.wsclient);
                                }
                                AddResource(zfs, "help.html", LibResources.java_help);
                            }
                        }
                    }

                }

                using (Amazon.S3.AmazonS3Client client = CreateS3Client())
                { 
                    PutObjectRequest obj = new PutObjectRequest();
                    obj.BucketName = "wsclient";

                    string key = GetNewKey() + ".zip";

                    obj.Key =  "jobs/" + Job.JobID + "/" + key;
                    awsUrl = obj.Key;
                    obj.FilePath = zipPath;
                    obj.ContentType = "application/octat-stream";
                    obj.CannedACL = Amazon.S3.S3CannedACL.PublicRead;
                    client.PutObject(obj);
                }

                using (WebClient client = new WebClient())
                {
                    client.Headers[HttpRequestHeader.ContentType] = "application/json";
                    SetupAuth(client.Headers);
                    JavaScriptSerializer js = new JavaScriptSerializer();
                    string data = js.Serialize(new
                    {
                        JobStatus = status,
                        ResultUrl = "https://s3.amazonaws.com/wsclient/" + awsUrl
                    });
                    string result = client.UploadString(Host + "/api/jobs/update/" + Job.JobID + "?_=" + DateTime.UtcNow.Ticks, "POST", data);
                }
            }

            public static string GetNewKey()
            {
                return Guid.NewGuid().ToString().ToLower().Replace("-", "");
            }

            private void AddResource(ZipOutputStream zfs, string name, byte[] data)
            {
                zfs.PutNextEntry(new ZipEntry(name));
                zfs.Write(data, 0, data.Length);
                zfs.CloseEntry();
            }


            private void AddFiles(ZipOutputStream zf, DirectoryInfo folder, string parent = "")
            {

                foreach (var item in folder.GetFiles())
                {
                    using (FileStream fs = item.OpenRead()) {
                        string file = parent + item.Name;
                        zf.PutNextEntry(new ZipEntry(parent + item.Name));
                        fs.CopyTo(zf);
                        zf.CloseEntry();
                    }
                }
                foreach (var item in folder.GetDirectories())
                {
                    AddFiles(zf, item, parent + item.Name + "\\");
                }
            }

            public void Execute()
            {
                try
                {

                    Console.WriteLine("Job " + Job.JobID + " started");

                    string url = Job.WSDLUrl;
                    if (!Regex.IsMatch(url, @"(http)|(https)\:\/\/", RegexOptions.IgnoreCase | RegexOptions.Compiled))
                    {
                        File.WriteAllText(CreateOutputFile("error.text"), "Invalid WSDL Url");
                        SaveJob("Failed");
                    }
                    else 
                    {
                        string folderPath = ZipFolder.FullName;

                        string package = Job.OutputPackage;
                        if (Regex.IsMatch(Job.OutputType,"java", RegexOptions.IgnoreCase| RegexOptions.Compiled) 
                            &&  !string.IsNullOrWhiteSpace(package)) {
                            var dir = new DirectoryInfo(ZipFolder.FullName + "\\" + package.Replace('.', '\\'));
                            dir.Create();
                            folderPath = dir.FullName;
                        }

                        JavaScriptSerializer js = new JavaScriptSerializer();
                        string config = js.Serialize(new { 
                            folderPath = folderPath,
                            generateType = Job.OutputType,
                            target = Job.OutputTarget,
                            forIPhone = Regex.IsMatch(Job.OutputTarget,"iphone|ios", RegexOptions.IgnoreCase),
                            forBlackberry = Regex.IsMatch(Job.OutputTarget, "blackberry", RegexOptions.IgnoreCase),
                            forAndroid = Regex.IsMatch(Job.OutputTarget,"android", RegexOptions.IgnoreCase),
                            localNamespace = string.IsNullOrWhiteSpace(Job.OutputPackage) ? Job.OutputPrefix : Job.OutputPackage,
                            generateFilename = "wsclient",
                            wsdlUrl = Job.WSDLUrl
                        });

                        string inputConfig = CreateInputFile("input.config");
                        string outputLog = CreateOutputFile("log.txt");
                        File.WriteAllText(inputConfig, config);
                        string args = string.Format("\"{0}\" \"{1}\" \"{2}\"", inputConfig, Job.IsDemo ? "demo" : "full", outputLog);

                        Process p = Process.Start(airFile, args);
                        p.WaitForExit();

                        SaveJob("Success");

                        Console.WriteLine("Job " + Job.JobID + " saved.");

                    }
                }
                catch (WebException we)
                {
                    using (Stream s = we.Response.GetResponseStream())
                    {
                        using (StreamReader sr = new StreamReader(s))
                        {
                            string error = sr.ReadToEnd();
                            Console.WriteLine(error);
                            File.WriteAllText(CreateOutputFile("log.txt"),error);
                            SaveJob("Failed");
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                    File.WriteAllText(CreateOutputFile("log.txt"), ex.ToString());
                    SaveJob("Failed");
                }
            }

            public void Dispose()
            {
                try
                {
                    if (TempFolder.Exists)
                        TempFolder.Delete(true);
                }
                catch { }
            }
        }

    }



    public class CometJob 
    {
        public long JobID { get; set; }
        public string Message { get; set; }
        public string OutputType { get; set; }
        public string OutputTarget { get; set; }
        public string OutputPackage { get; set; }
        public string OutputPrefix { get; set; }
        public string WSDLUrl { get; set; }
        public bool IsDemo { get; set; }
    }

    public class CometSetting {
        public string Key { get; set; }
        public string Value { get; set; }
    }
    
}
