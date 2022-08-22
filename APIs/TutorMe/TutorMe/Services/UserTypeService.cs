using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IUserTypeService
    {
        IEnumerable<UserType> GetAllUserTypes();
        UserType GetUserTypeById(Guid id);
        Guid createUserType(UserType userType);
        bool deleteUserTypeById(Guid id);
    }
    public class UserTypeServices : IUserTypeService
    {

        private TutorMeContext _context;
        public UserTypeServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<UserType> GetAllUserTypes()
        {
            return _context.UserType;
        }

        public UserType GetUserTypeById(Guid id)
        {
            var userType = _context.UserType.Find(id);
            if (userType == null)
            {
                throw new KeyNotFoundException("UserType not found");
            }
            return userType;
        }
        public Guid createUserType(UserType userType)
        {
            if (_context.UserType.Where(e => e.Type == userType.Type).Any())
            {
                throw new KeyNotFoundException("This sser type already exists, Please log in");
            }
            //UserType.Password = BCrypt.Net.BCrypt.HashPassword(UserType.Password, "ThisWillBeAGoodPlatformForBothUserTypesAndTuteesToConnectOnADailyBa5e5");
            userType.UserTypeId = Guid.NewGuid();
            _context.UserType.Add(userType);
            _context.SaveChanges();
            return userType.UserTypeId;
        }

        public bool deleteUserTypeById(Guid id)
        {
            var userType = _context.UserType.Find(id);
            if (userType == null)
            {
                throw new KeyNotFoundException("UserType not found");
            }
            _context.UserType.Remove(userType);
            _context.SaveChanges();
            return true;
        }
    }
}