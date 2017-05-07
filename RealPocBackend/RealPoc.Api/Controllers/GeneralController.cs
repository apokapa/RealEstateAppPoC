using RealPoc.Api.Abstractions;
using RealPoc.Api.ErrorHandling;
using RealPoc.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;

namespace RealPoc.Api.Controllers
{

    [RoutePrefix("api")]
    [EnableCors("*", "*", "*")]
    [ApiExceptionFilter]
    public class GeneralController : ApiController
    {
        private readonly IGeneralRepository _GeneralRepository;
        public GeneralController(IGeneralRepository GeneralRepository)
        {
            _GeneralRepository = GeneralRepository;
        }

        [HttpGet]
        [Route("propertyOffers")]
        public async Task<IHttpActionResult> GetAllPropertyOffers()
        {

            var results = await _GeneralRepository.GetAllPropertyOffers();
            return Ok(results);
        }



        [HttpPost]
        [Route("searchPropertyOffers")]
        public async Task<IHttpActionResult> GetAllPropertyOffers([FromBody]PropertySearch propertySearch)
        {
            var results = await _GeneralRepository.SearchForPropertyOffers(propertySearch);
            return Ok(results);
        }


        [HttpGet]
        [Route("propertyLocations")]
        public async Task<IHttpActionResult> GetAllPropertyLocations()
        {
            var results = await _GeneralRepository.GetAllPropertyLocations();
            return Ok(results);
        }

        [HttpGet]
        [Route("propertyLocations{SearchString}")]
        public async Task<IHttpActionResult> SearchForPropertyLocations(string SearchString)
        {
            var results = await _GeneralRepository.SearchForPropertyLocations(SearchString);
            return Ok(results);
        }


    }
}
