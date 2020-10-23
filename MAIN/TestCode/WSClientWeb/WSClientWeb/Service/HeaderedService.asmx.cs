using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

namespace WSClientWeb.Service
{
    /// <summary>
    /// Summary description for HeaderedService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class HeaderedService : System.Web.Services.WebService
    {


        public AuthHeader authHeader;


        [WebMethod]
        [SoapHeader("authHeader",Direction=SoapHeaderDirection.InOut)]
        public string Process(string input)
        {

            if (authHeader == null) {
                authHeader = new AuthHeader { Username="unknown" };
                return "New header created...";
            }
            return authHeader.Username;
        }

        [WebMethod]
        public Customer GetNew() {
            return new Customer();
        }

        [WebMethod]
        public Archivable GetAll() {
            return new Customer();
        }

        [WebMethod]
        public Customer GetNewCustomer(string name, string passKey) {
            return new Customer { Name=name, ID=passKey};
        }

        [WebMethod]
        public Customer[] GetAllNewCustomers() {
            return null;
        }

    }


    public class AuthHeader : SoapHeader {

        public string Username { get; set; }

        public string PassKey { get; set; }

    }

    public class Archivable {

        public bool IsArchived { get; set; }

    }

    public class Customer : Archivable {
        public Customer()
        {
            Name = "Unknown";
        }
        public string Name { get; set; }
        public string ID { get; set; }
    }


}
