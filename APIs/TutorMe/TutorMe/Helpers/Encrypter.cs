using System.Security.Cryptography;
using System.Text;

namespace TutorMe.Helpers
{
    public class Encrypter
    {
        public Encrypter() { }
        
        public String HashString(String plainString){
            var sharEncrypter = SHA256.Create();
            var bytes = Encoding.Default.GetBytes(plainString);
            var hashedString = sharEncrypter.ComputeHash(bytes);
            return Convert.ToBase64String(hashedString);
        }
        
    }
}
