﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ClientMVC.ViewModels
{
    public class OfferViewModel
    {
        public int OfferId { get; set; }
        public string OfferCategory { get; set; }
        public string PropertyCategory { get; set; }
        public string PropertySubCategory { get; set; }
        public string PropertyLocation { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public int Rooms { get; set; }
        public int FloorLevel { get; set; }
        public string HeatingType { get; set; }
        public string HeatingMedium { get; set; }
        public string ConstructionYear { get; set; }
        public int Area { get; set; }
        public string OtherFeatures { get; set; }
        public string PropertyLat { get; set; }
        public string PropertyLng { get; set; }
        public byte[] FeaturedImage { get; set; }



    }
}