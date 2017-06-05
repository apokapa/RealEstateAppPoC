using ClientMVC.ViewModels;
using RealPoc.Api.Abstractions;
using RealPoc.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;


namespace ClientMVC.Controllers
{
    public class HomeController : BaseController
    {
        public HomeController(IGeneralRepository GeneralRepository) : base(GeneralRepository)
        {
        }

        public async Task<ActionResult> Index()
        {
            HomeViewModel vm = new HomeViewModel();
            vm.OfferTypes = GetOfferTypes();
            //vmodel.Categories = GetAllCategories();       
            vm.OfferTypeId = 1;
            //vmodel.CategoryId = 1;
            //vmodel.SubCategories = GetAllSubCategories(vmodel.CategoryId);
            vm.Sponsored = await _GeneralRepository.GetSponsoredOffers();
            


            return View(vm);
        }


   
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}