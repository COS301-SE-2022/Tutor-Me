using System.Text.Json.Serialization;

namespace TutorMe.Models {
    public class Event {
        public Guid EventId { get; set; }
        public Guid GroupId { get; set; }
        public Guid UserId { get; set; }
        public string DateOfEvent { get; set; }
        public string VideoLink { get; set; }

        [JsonIgnore]
        public virtual Group Group { get; set; }
        [JsonIgnore]
        public virtual User User { get; set; }
    }
}
