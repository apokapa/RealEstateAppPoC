using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using RealPoc.Api.Abstractions;
using RealPoc.Model;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace RealPoc.Api.Datastore.SqlDb
{

    public class GeneralRepository : BaseRepository<object, int?>, IGeneralRepository
    {
        public async Task<IEnumerable<PropertyLocation>> GetAllPropertyLocations()
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.QueryAsync<PropertyLocation>("realpoc.getLocations_sp", null, commandType: CommandType.StoredProcedure);
            }
        }

        public async Task<IEnumerable<PropertyLocation>> SearchForPropertyLocations(string SearchString)
        {
            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@SearchString", SearchString);
                cn.Open();
                return await cn.QueryAsync<PropertyLocation>("realpoc.getLocations_sp", p, commandType: CommandType.StoredProcedure);
            }
        }


        public async Task<IEnumerable<PropertyLocation>> GetSelectedPropertyLocations(string SelectedLocations)
        {
            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@SelectedLocations", SelectedLocations);
                cn.Open();
                return await cn.QueryAsync<PropertyLocation>("realpoc.getSelectedLocations_sp", p, commandType: CommandType.StoredProcedure);
            }
        }


        

        public async Task<IEnumerable<PropertyOffer>> GetPropertyOffersByRange(ByRangeRequest ByRangeRequest)
        {

            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@lat", ByRangeRequest.lat);
                p.Add("@lng", ByRangeRequest.lng);
                p.Add("@range", ByRangeRequest.range);
                p.Add("@zoom", ByRangeRequest.zoom);

                cn.Open();
                return await cn.QueryAsync<PropertyOffer>("realpoc.getOffersByRange_sp", p,commandType: CommandType.StoredProcedure);
            }

        }



        public async Task<IEnumerable<PropertyOffer>> GetAllPropertyOffers()
        {

            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.QueryAsync<PropertyOffer>("realpoc.getPropertyOffersList_sp", null, commandType: CommandType.StoredProcedure);  
            }

        }

     
        public async Task<IEnumerable<PropertyOffer>> SearchForPropertyOffers(PropertySearch PropertySearch)
        {
            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@OfferTypeId", PropertySearch.OfferTypeId);
                p.Add("@CategoryId", PropertySearch.CategoryId);
                p.Add("@SubCategoryId", PropertySearch.SubCategoryId);
                p.Add("@MaxPrice", PropertySearch.MaxPrice);
                p.Add("@MinArea", PropertySearch.MinArea);
                p.Add("@MinRooms", PropertySearch.MinRooms);
                p.Add("@MinFloorLevel", PropertySearch.MinFloorLevel);
                p.Add("@LocationCode", PropertySearch.LocationCodes);

                cn.Open();
                return await cn.QueryAsync<PropertyOffer>("realpoc.searchPropertyOffers_sp", p, commandType: CommandType.StoredProcedure);
            }

        }

        public async Task<User> RegisterUser(User user)
        {
            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@email", user.Email);
                p.Add("@password", user.Password);
                cn.Open();
                var result= await cn.QueryAsync<User>("realpoc.registeruser_sp", p, commandType: CommandType.StoredProcedure);

                return result.FirstOrDefault();
            }
        }

        public async Task<User> LoginUser(User user)
        {

            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@email", user.Email);
                cn.Open();
                var result = await cn.QueryAsync<User>("realpoc.loginuser_sp", p, commandType: CommandType.StoredProcedure);

                return result.FirstOrDefault();
            }
        }

        public async Task<IEnumerable<PropertyOffer>> SearchForPropertyOffersPaged(PropertySearch PropertySearch)
        {
            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@OfferTypeId", PropertySearch.OfferTypeId);
                p.Add("@CategoryId", PropertySearch.CategoryId);
                p.Add("@SubCategoryId", PropertySearch.SubCategoryId);
                p.Add("@MaxPrice", PropertySearch.MaxPrice);
                p.Add("@MinArea", PropertySearch.MinArea);
                p.Add("@MinRooms", PropertySearch.MinRooms);
                p.Add("@MinFloorLevel", PropertySearch.MinFloorLevel);
                p.Add("@LocationCode", PropertySearch.LocationCodes);
                p.Add("@Page", PropertySearch.Page);
                p.Add("@PageSize", PropertySearch.PageSize);

                cn.Open();
                return await cn.QueryAsync<PropertyOffer>("realpoc.searchPropertyOffersPaged_sp", p, commandType: CommandType.StoredProcedure);
            }
        }

        public async Task<PropertyOffer> GetPropertyOffer(int OfferId)
        {
            using (IDbConnection cn = Connection)
            {
                var p = new DynamicParameters();
                p.Add("@OfferId", OfferId);
      
                cn.Open();
                var result= await cn.QueryAsync<PropertyOffer>("realpoc.getofferbyid_sp", p, commandType: CommandType.StoredProcedure);

                return result.FirstOrDefault();
            }

        }

        public async Task<IEnumerable<PropertyOffer>> GetSponsoredOffers()
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.QueryAsync<PropertyOffer>("realpoc.getsponsored_sp", null, commandType: CommandType.StoredProcedure);

            }
        }

    }
}

