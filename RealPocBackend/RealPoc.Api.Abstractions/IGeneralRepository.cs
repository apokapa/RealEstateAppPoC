﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RealPoc.Model;

namespace RealPoc.Api.Abstractions
{
    public interface IGeneralRepository : IRepository<object, int?>
    {
        Task<IEnumerable<PropertyOffer>> GetAllPropertyOffers();

        Task<IEnumerable<PropertyOffer>> SearchForPropertyOffers(PropertySearch PropertySearch);

        Task<IEnumerable<PropertyLocation>> GetAllPropertyLocations();

        Task<IEnumerable<PropertyLocation>> SearchForPropertyLocations(string SearchString);

    }

}
