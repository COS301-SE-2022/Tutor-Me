namespace TutorMe.Entities {
    public class IUser {
        public Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DateOfBirth { get; set; }
        public bool Status { get; set; }
        public string Gender { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public Guid UserTypeId { get; set; }
        public Guid InstitutionId { get; set; }
        public string Location { get; set; }
        public string Bio { get; set; }
        public string Year { get; set; }
        public int? Rating { get; set; }
        public int? NumberOfReviews { get; set; }
        public bool verified { get; set; }
    }
}
