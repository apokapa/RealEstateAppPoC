using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace RealPoc.Model
{
    public class ByRangeRequest
    {
        public string lat { get; set; }
        public string lng { get; set; }
        public int? range { get; set; }
        public int? zoom { get; set; } 
    }
}
