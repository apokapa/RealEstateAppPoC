using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using RealPoc.Api;
using RealPoc.Api.Controllers;
using System.Threading.Tasks;
using RealPoc.Api.Datastore.SqlDb;

namespace RealPoc.Api.Tests.Controllers
{
    [TestClass]
    public class GeneralControllerTest
    {

        [TestMethod]
        public async Task GetAllPropertyOffers()
        {
            //Arrange
            GeneralController controller = new GeneralController(new GeneralRepository());
            //Act
            var result = await controller.GetAllPropertyOffers();
            // Assert
            Assert.IsNotNull(result);


        }

    }
}
