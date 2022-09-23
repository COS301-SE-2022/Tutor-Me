namespace TutorMe.Entities {
    public class IRequest {
        public Guid RequestId { get; set; }
        public Guid TuteeId { get; set; }
        public Guid TutorId { get; set; }
        public string DateCreated { get; set; }
        public Guid ModuleId { get; set; }
    }
}
