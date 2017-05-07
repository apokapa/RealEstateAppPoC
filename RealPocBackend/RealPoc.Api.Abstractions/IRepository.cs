using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RealPoc.Api.Abstractions
{
    public interface IRepository<T, TK>
    {
        Task<TK> InsertAsync(T entity);
        Task DeleteAsync(object id);
        Task DeleteAsync(T entity);
        Task UpdateAsync(T entity);
        Task<T> GetByIdAsync(object id);
        Task<IEnumerable<T>> Find(string condition);
        Task<IEnumerable<T>> FindAll();
        Task<IEnumerable<T>> FindPaged(int pageNumber, int rowsPerPage, string conditions, string orderby);
    }

}
