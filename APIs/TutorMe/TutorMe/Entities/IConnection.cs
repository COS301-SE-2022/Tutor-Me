namespace TutorMe.Entities {
    public class IConnection {
        public Guid ConnectionId { get; set; }
        public Guid TutorId { get; set; }
        public Guid TuteeId { get; set; }
        public Guid ModuleId { get; set; }
    }
}
