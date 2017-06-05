using System;
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
        Task<IEnumerable<PropertyOffer>> SearchForPropertyOffersPaged(PropertySearch PropertySearch);
        Task<IEnumerable<PropertyOffer>> GetPropertyOffersByRange(ByRangeRequest ByRangeRequest);
        Task<IEnumerable<PropertyOffer>> GetSponsoredOffers();
        Task<PropertyOffer> GetPropertyOffer(int OfferId);
        Task<IEnumerable<PropertyLocation>> GetAllPropertyLocations();
        Task<IEnumerable<PropertyLocation>> SearchForPropertyLocations(string SearchString);
        Task<IEnumerable<PropertyLocation>> GetSelectedPropertyLocations(string SelectedLocations);
        Task<User> RegisterUser(User user);
        Task<User> LoginUser(User user);


    }

}
