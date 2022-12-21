using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;

namespace Monitor3EAPI.Controllers
{
    public class HomeController : Controller
    {
        public HttpStatusCodeResult Index()
        {
            string username = System.Configuration.ConfigurationManager.AppSettings["username"];
            string pwd = System.Configuration.ConfigurationManager.AppSettings["pwd"];
            string url = System.Configuration.ConfigurationManager.AppSettings["url"];
            CredentialCache credCache = new CredentialCache();
            credCache.Add(new Uri(url), "NTLM", new NetworkCredential(username, pwd));
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(url);
            request.Method = "GET";
            request.Credentials = credCache;
            HttpStatusCodeResult coderes = new HttpStatusCodeResult(HttpStatusCode.OK);
            try
            {
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        return coderes;
                    }
                }
                coderes = new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
                return coderes;
            }
            catch
            {
                coderes = new HttpStatusCodeResult(HttpStatusCode.InternalServerError);
                return coderes;
            }
        }
    }
}
