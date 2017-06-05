using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RealPoc.Api.Abstractions;
using RealPoc.Model;
using System.Threading.Tasks;
using ClientMVC.ViewModels;

namespace ClientMVC.Controllers
{
    public class OfferController : BaseController
    {
        public OfferController(IGeneralRepository GeneralRepository) : base(GeneralRepository)
        {
        }

        // GET: Offer
        public  async Task<ActionResult> Index(int id)
        {

            var offer = await _GeneralRepository.GetPropertyOffer(id);
            OfferViewModel vm = new OfferViewModel();
            vm.Title = offer.Title;
            vm.Description = offer.Description;
            


            return View(vm);
        }
    }
}