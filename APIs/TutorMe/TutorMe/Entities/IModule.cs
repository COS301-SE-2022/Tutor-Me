namespace TutorMe.Entities {
    public class IModule {
        public Guid ModuleId { get; set; }
        public string Code { get; set; }
        public string ModuleName { get; set; }
        public Guid InstitutionId { get; set; }
        public string Faculty { get; set; }
        public string Year { get; set; }
    }
}
