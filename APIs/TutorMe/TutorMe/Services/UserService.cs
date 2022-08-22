using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IUserService
    {
        IEnumerable<User> GetAllUsers();
        User GetUserById(Guid id);
        Guid RegisterUser(User user);

        User UpdateUser(User user);
    }
    public class UserServices : IUserService
    {

        private TutorMeContext _context;
        public UserServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<User> GetAllUsers()
        {
            return _context.User;
        }

        public User GetUserById(Guid id)
        {
            var user = _context.User.Find(id);
            if (user == null)
            {
                throw new KeyNotFoundException("User not found");
            }
            return user;
        }
        public Guid RegisterUser(User user)
        {
            if (_context.User.Where(e => e.Email == user.Email).Any())
            {
                throw new KeyNotFoundException("This User already exists, Please log in");
            }
            //User.Password = BCrypt.Net.BCrypt.HashPassword(User.Password, "ThisWillBeAGoodPlatformForBothUsersAndTuteesToConnectOnADailyBa5e5");
            user.UserId = Guid.NewGuid();
            _context.User.Add(user);
            _context.SaveChanges();
            return user.UserId;
        }

        public User UpdateUser(User user)
        {

            try
            {
                var updateUser = _context.User.FirstOrDefault(e => e.UserId == user.UserId);
                if (updateUser != null)
                {
                    updateUser.FirstName = user.FirstName;
                    updateUser.LastName = user.LastName;
                    updateUser.DateOfBirth = user.DateOfBirth;
                    updateUser.Status = user.Status;
                    updateUser.Gender = user.Gender;
                    updateUser.Email = user.Email;
                    updateUser.Password = user.Password;
                    updateUser.UserTypeId = user.UserTypeId;
                    updateUser.InstitutionId = user.InstitutionId;
                    updateUser.Location = user.Location;
                    updateUser.Bio = user.Bio;
                    updateUser.Year = user.Year;
                    updateUser.Rating = user.Rating;

                    _context.SaveChanges();
                    return _context.User.FirstOrDefault(e => e.UserId == user.UserId);
                }
                else
                {
                    throw new Exception("User not found");
                }

            }
            catch (DbUpdateConcurrencyException)
            {
                throw;
            }

        }
    }
}