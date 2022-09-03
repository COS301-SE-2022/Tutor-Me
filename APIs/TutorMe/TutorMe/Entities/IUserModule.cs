namespace TutorMe.Entities {
    public class IUserModule {
        public Guid UserModuleId { get; set; }
        public Guid ModuleId { get; set; }
        public Guid UserId { get; set; }
    }
}
