namespace TutorMe.Entities {
    public class UserEmail {
        public string NewEmail { get; set; }
        public string OldEmail { get; set; }
        public Guid UserId { get; set; }
        public string Password { get; set; }
    }
}
