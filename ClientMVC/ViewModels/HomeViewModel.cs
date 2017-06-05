using RealPoc.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ClientMVC.ViewModels
{
    public class HomeViewModel
    {
        public IEnumerable<OfferType> OfferTypes { get; set; }
        public int? OfferTypeId { get; set; }
        public string LocationCodes { get; set; }
        public IEnumerable<PropertyOffer> Sponsored { get; set; }


    }
}