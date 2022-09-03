using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Helpers;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IUserAuthenticationService
    {
        User LogInUser(UserLogIn user);
        string hashPassword(string password);
        bool UpdateEmailByUserId(Guid id, UserEmail emailEntity);
        bool UpdatePassword(Guid id, IAuthPassword authPass);
    }
    public class UserAuthenticationServices : IUserAuthenticationService
    {

        private TutorMeContext _context;
        private Encrypter encrypter;
        public UserAuthenticationServices(TutorMeContext context)
        {
            _context = context;
            encrypter = new Encrypter();
        }

        public User LogInUser(UserLogIn userDetails)
        {
            var user = _context.User.FirstOrDefault(e => e.Email == userDetails.Email && e.UserTypeId == userDetails.TypeId);
            if (user != null){
                if (user.Password == encrypter.HashString(userDetails.Password))
                {
                    return user;
                }
                else
                {
                    throw new Exception("Wrong Username/Password");
                }
            }
            else{
                throw new KeyNotFoundException("The user not found, Please register an account first.");
            }
        }
        
        public bool UpdateEmailByUserId(Guid id, UserEmail data) {
            var user = _context.User.Find(id);
            if (user == null) {
                throw new KeyNotFoundException("User not found");
            }
            if (user.Password == hashPassword(data.Password) && user.Email == data.OldEmail) {
                user.Email = data.NewEmail;
                _context.SaveChanges();
                return true;
            }
            else {
                throw new KeyNotFoundException("Password or Email is incorrect");
            }
        }

        public bool UpdatePassword(Guid id, IAuthPassword authPassword) {
            var user = _context.User.Find(id);
            if (user == null) {
                throw new KeyNotFoundException("User not found");
            }
            if (user.Password == hashPassword(authPassword.OldPassword)) {
                user.Password = hashPassword(authPassword.Password);
                _context.SaveChanges();
                return true;
            }
            else {
                throw new KeyNotFoundException("Password or Email is incorrect");
            }
        }

        public string hashPassword(string password) {
            return encrypter.HashString(password);
        }
    }
}