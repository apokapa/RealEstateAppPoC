using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(RealPoc.Api.Startup))]

namespace RealPoc.Api
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
        
        }
    }
}
