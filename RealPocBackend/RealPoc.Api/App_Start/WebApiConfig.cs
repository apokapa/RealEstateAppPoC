using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http.Cors;
using System.Net.Http;
using System.Web.Http;
using Microsoft.Owin.Security.OAuth;
using Newtonsoft.Json.Serialization;
using Newtonsoft.Json;
using SimpleInjector;
using RealPoc.Api.Abstractions;
using RealPoc.Api.Datastore.SqlDb;
using SimpleInjector.Integration.WebApi;

namespace RealPoc.Api
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {

            //My Api Config
            //Cors
            var corsAttr = new EnableCorsAttribute("*", "*", "*");
            config.EnableCors(corsAttr);

            // Web API routes
            config.MapHttpAttributeRoutes();
            config.IncludeErrorDetailPolicy = IncludeErrorDetailPolicy.Always;
            // clear the supported mediatypes of the xml formatter
            config.Formatters.XmlFormatter.SupportedMediaTypes.Clear();

            var json = config.Formatters.JsonFormatter;
            json.SerializerSettings.Formatting = Newtonsoft.Json.Formatting.Indented;
            json.SerializerSettings.NullValueHandling = NullValueHandling.Include;

            var container = new Container();
            container.Options.DefaultScopedLifestyle = new WebApiRequestLifestyle();
            //InitializeContainer(container);
            container.Register<IGeneralRepository, GeneralRepository>(Lifestyle.Scoped);
            container.RegisterWebApiControllers(GlobalConfiguration.Configuration);
            container.Verify();
            config.DependencyResolver = new SimpleInjectorWebApiDependencyResolver(container);


        }
    }
}
