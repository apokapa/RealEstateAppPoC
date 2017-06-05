using ClientMVC.ViewModels;
using RealPoc.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Newtonsoft.Json;
using RealPoc.Api.Datastore.SqlDb;
using System.Threading.Tasks;
using RealPoc.Api.Abstractions;

namespace ClientMVC.Controllers
{
    public class SearchController : BaseController
    {
        public SearchController(IGeneralRepository GeneralRepository) : base(GeneralRepository)
        {
        }



        // GET: SearchForm
        public async Task<ActionResult> Index([FromBody]SearchViewModel SearchData)
        {
            //ViewBag
            ViewBag.Active = "active";

            //Request Filters Setup
            PropertySearch requestData = new PropertySearch();
            requestData.OfferTypeId = SearchData.OfferTypeId;
            requestData.CategoryId = SearchData.CategoryId;
            requestData.SubCategoryId = SearchData.SubCategoryId;
            requestData.LocationCodes = SearchData.LocationCodes;
            

            //Page Filters setup
            requestData.Page = SearchData.Page == 0 ? 1: SearchData.Page;
            requestData.PageSize = (SearchData.PageSize == 0 || SearchData.PageSize==0) ? 10: SearchData.PageSize ;

            //GetMatchingResults
            GeneralRepository repo = new GeneralRepository();          
            var Results = await repo.SearchForPropertyOffersPaged(requestData);

            //ViewModel Setup
            SearchViewModel vm = SearchData;
            vm.Categories = GetAllCategories();
            vm.OfferTypes = GetOfferTypes();
            vm.SubCategories = GetAllSubCategories(SearchData.CategoryId);
            vm.Page = SearchData.Page == 0 ? 1 : SearchData.Page;
            vm.PageSize = SearchData.PageSize == 0 ? 10 : SearchData.PageSize;
            vm.Results = Results;
            if (Results.Count() > 0) {
                int pages = 0;
                vm.TotalResults = (int)Results.FirstOrDefault().TotalResults;
                pages = (int)vm.TotalResults / (int)requestData.PageSize;       
                if (((int)vm.TotalResults % (int)requestData.PageSize) != 0)
                {
                    pages++;
                }
                vm.Pages = pages;
            };

            vm.PagerStart= SearchData.Page<=5 ? 1 : SearchData.Page-4;
            vm.PagerEnd = vm.Pages > 10 ? vm.Page + 5: vm.Pages;
            vm.PagerEnd = vm.PagerEnd < 10 && vm.PagerEnd < vm.Pages ? 10 : vm.PagerEnd;
            vm.PagerEnd = vm.PagerEnd > vm.Pages ? vm.Pages : vm.PagerEnd;


            return View(vm);
        }


        public async Task<ActionResult> Map()
        {

            return View();
        }


    }
}