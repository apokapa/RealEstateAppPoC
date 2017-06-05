using RealPoc.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ClientMVC.ViewModels
{
    public class SearchViewModel
    {
        public IEnumerable<OfferType> OfferTypes { get; set; }
        public IEnumerable<PropertyCategory> Categories { get; set; }
        public IEnumerable<PropertySubCategory> SubCategories { get; set; }
        public int OfferId { get; set; }
        public int? OfferTypeId { get; set; }
        public int? CategoryId { get; set; }
        public int? SubCategoryId { get; set; }
        public string LocationCodes { get; set; }
        public int Page { get; set; }
        public int PageSize { get; set; }
        public IEnumerable<PropertyOffer> Results { get; set; }
        public int TotalResults { get; set; }
        public int Pages { get; set; }
        public int PagerStart { get; set; }
        public int PagerEnd { get; set; }


    }
}