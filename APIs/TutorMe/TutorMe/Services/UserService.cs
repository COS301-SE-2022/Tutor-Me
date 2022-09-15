using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;
using TutorMe.Helpers;
using TutorMe.Entities;

namespace TutorMe.Services {
    public interface IUserService
    {
        IEnumerable<User> GetAllUsers();
        IEnumerable<User> GetAllTutors();
        IEnumerable<User> GetAllTutees();
        IEnumerable<User> GetAllAdmins();
        User GetUserById(Guid id);
        Guid RegisterUser(IUser user);
        bool DeleteUserById(Guid id);
        bool updateUserBio(Guid id, string bio);
        User UpdateUser(IUser user);
    }
    public class UserServices : IUserService
    {

        private TutorMeContext _context;
        private Encrypter encrypter;
        private UserAuthenticationServices auth;
        public UserServices(TutorMeContext context){
            _context = context;
            encrypter = new Encrypter();
            auth = new UserAuthenticationServices(_context);
        }

        public IEnumerable<User> GetAllUsers()
        {
            return _context.User;
        }

        public IEnumerable<User> GetAllTutors() {
            var type = _context.UserType.Where(e => e.Type == "Tutor").FirstOrDefault();
            if(type == null) {
                return null;
            }
            var user = _context.User.Where(e => e.UserTypeId == type.UserTypeId);
            return user;
        }

        public IEnumerable<User> GetAllTutees() {
            var type = _context.UserType.Where(e => e.Type == "Tutee").FirstOrDefault();
            if (type == null) {
                return null;
            }
            Console.Write(type);
            var user = _context.User.Where(e => e.UserTypeId == type.UserTypeId);
            Console.Write(user);
            return user;
        }

        public IEnumerable<User> GetAllAdmins() {
            var type = _context.UserType.Where(e => e.Type == "Admin").FirstOrDefault();
            if (type == null) {
                return null;
            }
            Console.Write(type);
            var user = _context.User.Where(e => e.UserTypeId == type.UserTypeId);
            Console.Write(user);
            return user;
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
        
        public Guid RegisterUser(IUser user)
        {
            if (_context.User.Where(e => e.Email == user.Email).Any())
            {
                throw new KeyNotFoundException("This User already exists, Please log in");
            }
            var newUser = new User();
            newUser.UserId = Guid.NewGuid();
            newUser.FirstName = user.FirstName;
            newUser.LastName = user.LastName;
            newUser.DateOfBirth = user.DateOfBirth;
            newUser.Gender = user.Gender;
            newUser.Email = user.Email;
            newUser.Password = encrypter.HashString(user.Password);
            newUser.UserTypeId = user.UserTypeId;
            newUser.InstitutionId = user.InstitutionId;
            newUser.Location = user.Location;
            newUser.Bio = user.Bio;
            newUser.Year = user.Year;
            newUser.Rating = user.Rating;
            newUser.NumberOfReviews = user.NumberOfReviews;
            _context.User.Add(newUser);
            _context.SaveChanges();
            return user.UserId;
        }

        public User UpdateUser(IUser user)
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
                    updateUser.Password = encrypter.HashString(user.Password);
                    updateUser.UserTypeId = user.UserTypeId;
                    updateUser.InstitutionId = user.InstitutionId;
                    updateUser.Location = user.Location;
                    updateUser.Bio = user.Bio;
                    updateUser.Year = user.Year;
                    updateUser.Rating = user.Rating;
                    updateUser.NumberOfReviews = user.NumberOfReviews;

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

        public bool updateUserBio(Guid id, string bio) {
            var user = _context.User.Find(id);
            if (user == null) {
                throw new KeyNotFoundException("User not found");
            }
            user.Bio = bio;
            _context.SaveChanges();
            return true;
        }

        public bool DeleteUserById(Guid id) {
            var user = _context.User.Find(id);
            if (user == null) {
                throw new KeyNotFoundException("User not found");
            }
            _context.User.Remove(user);
            _context.SaveChanges();
            return true;
        }
    }
}