using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Helpers;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IUserAuthenticationService
    {
        User LogInUser(UserLogIn user);
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
            Console.Write(userDetails.Email);

            var user = _context.User.FirstOrDefault(e => e.Email == userDetails.Email);
            if (user != null)
            {
                if (user.Password == encrypter.HashString(userDetails.Password))
                {
                    return user;
                }
                else
                {
                    throw new Exception("Wrong Username/Password");
                }
            }
            else
            {
                throw new KeyNotFoundException("The user not found, Please register an account first.");
            }
        }
    }
}