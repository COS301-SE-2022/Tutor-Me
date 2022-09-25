using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace TutorMe.Models {
    public class Badge {

        public Badge() {
            UserBadges = new HashSet<UserBadge>();
        }
        
        [Key]
        public Guid BadgeId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Image { get; set; }
        public int Points { get; set; }
        public int PointsToAchieve { get; set; }

        [JsonIgnore]
        public virtual ICollection<UserBadge> UserBadges { get; set; }
    }
}
