using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RealPoc.Model
{
    public class PropertySearch
    {
        public int? OfferTypeId { get; set; }
        public int? CategoryId { get; set; }
        public int? SubCategoryId { get; set;}
        public string LocationCodes { get; set; }
        public decimal? MaxPrice { get; set; }
        public int? MinArea { get; set; }
        public int? MinRooms { get; set; }
        public int? MinFloorLevel { get; set; }
        public int? Page { get; set; }
        public int? PageSize { get; set; }
    }

}
