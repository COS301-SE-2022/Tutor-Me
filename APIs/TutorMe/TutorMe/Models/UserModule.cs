using System.Text.Json.Serialization;

namespace TutorMe.Models {
    public class UserModule {
        public Guid UserModuleId { get; set; }
        public Guid ModuleId { get; set; }
        public Guid UserId { get; set; }

        [JsonIgnore]
        public virtual Module Module { get; set; }
        [JsonIgnore]
        public virtual User User { get; set; }
    }
}