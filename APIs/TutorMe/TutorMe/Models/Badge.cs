using System.ComponentModel.DataAnnotations;

namespace TutorMe.Models {
    public class Badge {
        [Key]
        public Guid BadgeId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Image { get; set; }
        public int Points { get; set; }
        public int PointsToAchieve { get; set; }
    }
}
