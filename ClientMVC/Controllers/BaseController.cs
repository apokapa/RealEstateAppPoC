using RealPoc.Api.Abstractions;
using RealPoc.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace ClientMVC.Controllers
{
    public class BaseController : Controller
    {

        //private readonly IGeneralRepository _GeneralRepository;
        public readonly IGeneralRepository _GeneralRepository;
        public BaseController(IGeneralRepository GeneralRepository)
        {
            _GeneralRepository = GeneralRepository;
        }

        //Action result for ajax call
        [HttpPost]
        public ActionResult GetSubCategories(int? categoryid)
        {
            List<PropertySubCategory> objsubcategories = new List<PropertySubCategory>();
            objsubcategories = GetAllSubCategories().Where(m => m.CategoryId == categoryid).ToList();
            SelectList obgsubcategories = new SelectList(objsubcategories, "Id", "Descr",0);
            return Json(obgsubcategories);
        }

        public List<OfferType> GetOfferTypes()
        {
            //To be implemented via DB call
            List<OfferType> objoffertypes = new List<OfferType>();
            objoffertypes.Add(new OfferType { Id = 1, Descr = "For Sale" });
            objoffertypes.Add(new OfferType { Id = 2, Descr = "For Rent" });
            return objoffertypes;
        }

        public List<PropertyCategory> GetAllCategories()
        {
            //To be implemented via DB call
            List<PropertyCategory> objcategories = new List<PropertyCategory>();
            objcategories.Add(new PropertyCategory { Id = 1, Descr = "Residential" });
            objcategories.Add(new PropertyCategory { Id = 2, Descr = "Commercial" });
            objcategories.Add(new PropertyCategory { Id = 3, Descr = "Land" });
            objcategories.Add(new PropertyCategory { Id = 4, Descr = "Other Properties" });
            return objcategories;
        }

        public List<PropertySubCategory> GetAllSubCategories()
        {
            //To be implemented via DB call
            List<PropertySubCategory> objsubcategories = new List<PropertySubCategory>();
            objsubcategories.Add(new PropertySubCategory { Id = 1, CategoryId = 1, Descr = "Flat" });
            objsubcategories.Add(new PropertySubCategory { Id = 2, CategoryId = 1, Descr = "Villa" });
            objsubcategories.Add(new PropertySubCategory { Id = 3, CategoryId = 1, Descr = "Studio" });
            objsubcategories.Add(new PropertySubCategory { Id = 4, CategoryId = 2, Descr = "Office" });
            objsubcategories.Add(new PropertySubCategory { Id = 5, CategoryId = 2, Descr = "Store" });
            objsubcategories.Add(new PropertySubCategory { Id = 6, CategoryId = 3, Descr = "Plot" });
            objsubcategories.Add(new PropertySubCategory { Id = 7, CategoryId = 3, Descr = "Parcel" });
            objsubcategories.Add(new PropertySubCategory { Id = 8, CategoryId = 4, Descr = "Parking" });
            objsubcategories.Add(new PropertySubCategory { Id = 9, CategoryId = 4, Descr = "Business" });

            return objsubcategories;
        }

        public async Task<JsonResult> Search(string q)
        {
            //List<Area> areas = new List<Area>();
            //areas.Add(new Area {id = 1, name = "Athens Center" });
            //areas.Add(new Area { id = 2, name = "Athens North" });
            //areas.Add(new Area { id = 3, name = "Athens South" });
            //areas.Add(new Area { id = 4, name = "Athens Abelokipoi" });

            IEnumerable<PropertyLocation> locations =  await _GeneralRepository.SearchForPropertyLocations(q);

            var searchResult = locations;


            return Json(searchResult, JsonRequestBehavior.AllowGet);
        }

        public async Task<JsonResult> GetPrepopulate(string selected)
        {
            //List<Area> areas = new List<Area>();
            //areas.Add(new Area { id = 1, name = "Athens Center" });
            //areas.Add(new Area { id = 2, name = "Athens North" });
            //areas.Add(new Area { id = 3, name = "Athens South" });
            //areas.Add(new Area { id = 4, name = "Athens Abelokipoi" });
            //string[] selectedArr = selected.Split(',');
            //var searchResult = new List<Area>();

            //foreach (var item in selectedArr)
            //{
            //    searchResult.Add(areas.Where(m => m.id.ToString() == item).FirstOrDefault());
            //}

            IEnumerable<PropertyLocation> locations = await _GeneralRepository.GetSelectedPropertyLocations(selected);
            var selectedLocations = locations;

            return Json(selectedLocations, JsonRequestBehavior.AllowGet);
        }


        public List<PropertySubCategory> GetAllSubCategories(int? categoryid)
        {
            List<PropertySubCategory> objsubcategories = new List<PropertySubCategory>();
            objsubcategories = GetAllSubCategories().Where(m => m.CategoryId == categoryid).ToList();
            return objsubcategories;
        }




    }
}