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

    public class BaseRepository<T, TK> : IRepository<T, TK>
    {

        internal IDbConnection Connection
        {
            get
            {
                return new SqlConnection(ConfigurationManager.ConnectionStrings["MyAppConString"].ConnectionString);
            }
        }

        public virtual async Task<TK> InsertAsync(T entity)
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.InsertAsync<TK>(entity);
            }
        }

        public virtual async Task DeleteAsync(object id)
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                await cn.DeleteAsync<T>(id);
            }
        }

        public virtual async Task DeleteAsync(T entity)
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                await cn.DeleteAsync(entity);
            }
        }

        public virtual async Task UpdateAsync(T entity)
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                await cn.UpdateAsync(entity);
            }
        }

        public virtual async Task<T> GetByIdAsync(object id)
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.GetAsync<T>(id);
            }
        }

        public virtual async Task<IEnumerable<T>> Find(string condition)
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.GetListAsync<T>(condition);
            }
        }

        public virtual async Task<IEnumerable<T>> FindAll()
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.GetListAsync<T>();
            }
        }

        public virtual async Task<IEnumerable<T>> FindPaged(int pageNumber, int rowsPerPage, string conditions, string orderby)
        {
            using (IDbConnection cn = Connection)
            {
                cn.Open();
                return await cn.GetListPagedAsync<T>(pageNumber, rowsPerPage, conditions, orderby);
            }
        }
    }





}

