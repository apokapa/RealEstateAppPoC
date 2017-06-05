using RealPoc.Api.Abstractions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ClientMVC.Controllers
{
    public class ManageController : BaseController
    {
        public ManageController(IGeneralRepository GeneralRepository) : base(GeneralRepository)
        {
        }


        // GET: Manage
        public ActionResult Index()
        {
            return View();
        }



    }
}