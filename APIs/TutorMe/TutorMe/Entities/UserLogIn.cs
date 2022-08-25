namespace TutorMe.Entities
{
    public class UserLogIn
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public Guid TypeId { get; set; }
    }
}