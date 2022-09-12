using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IInstitutionService
    {
        IEnumerable<Institution> GetAllInstitutions();
        Institution GetInstitutionById(Guid id);
        Guid createInstitution(Institution institution);
        bool deleteInstitutionById(Guid id);
    }
    public class InstitutionServices : IInstitutionService
    {

        private TutorMeContext _context;
        public InstitutionServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<Institution> GetAllInstitutions()
        {
            return _context.Institution;
        }

        public Institution GetInstitutionById(Guid id)
        {
            var institution = _context.Institution.Find(id);
            if (institution == null)
            {
                throw new KeyNotFoundException("Institution not found");
            }
            return institution;
        }
        public Guid createInstitution(Institution institution)
        {
            if (_context.Institution.Where(e => e.Name == institution.Name).Any())
            {
                throw new KeyNotFoundException("This Institution already exists");
            }
            //Institution.Password = BCrypt.Net.BCrypt.HashPassword(Institution.Password, "ThisWillBeAGoodPlatformForBothInstitutionsAndTuteesToConnectOnADailyBa5e5");
            institution.InstitutionId = Guid.NewGuid();
            _context.Institution.Add(institution);
            _context.SaveChanges();
            return institution.InstitutionId;
        }

        public bool deleteInstitutionById(Guid id)
        {
            var institution = _context.Institution.Find(id);
            if (institution == null)
            {
                throw new KeyNotFoundException("Institution not found");
            }
            _context.Institution.Remove(institution);
            _context.SaveChanges();
            return true;
        }
    }
}