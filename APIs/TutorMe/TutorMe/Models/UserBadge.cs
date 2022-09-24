using System.Text.Json.Serialization;

namespace TutorMe.Models {
    public class UserBadge {
        public Guid UserBadgeId { get; set; }
        public Guid UserId { get; set; }
        public Guid BadgeId { get; set; }
        public int pointAchieved { get; set; }

        [JsonIgnore]
        public virtual Badge Badge { get; set; }
        [JsonIgnore]
        public virtual User User { get; set; }

    }
}
