using System.Text.Json.Serialization;

namespace TutorMe.Models {
    public class GroupVideosLink {
        public Guid GroupVideoLinkId { get; set; }
        public Guid GroupId { get; set; }
        public string VideoLink { get; set; }

        [JsonIgnore]
        public virtual Group Group { get; set; }
    }
}
