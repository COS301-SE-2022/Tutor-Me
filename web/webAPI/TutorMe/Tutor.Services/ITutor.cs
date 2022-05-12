using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tutors.Data;

namespace Tutors.Services{
    public interface ITutor{
        Task<Tutor> GetTutor(int? id);
        IQueryable<Tutor> GetTutors { get; }
        Task<ModelReturned> Save(Tutor tutor);
        Task<ModelReturned> DeleteAsync(int? id);
    }
}
