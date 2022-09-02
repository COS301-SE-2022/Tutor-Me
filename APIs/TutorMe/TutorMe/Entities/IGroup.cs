namespace TutorMe.Entities {
    public class IGroup {
        public Guid GroupId { get; set; }
        public Guid ModuleId { get; set; }
        public string Description { get; set; }
        public Guid UserId { get; set; }
    }
}
