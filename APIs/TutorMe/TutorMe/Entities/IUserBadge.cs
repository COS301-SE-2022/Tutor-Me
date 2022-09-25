namespace TutorMe.Entities {
    public class IUserBadge {
        public Guid UserBadgeId { get; set; }
        public Guid UserId { get; set; }
        public Guid BadgeId { get; set; }
        public int pointAchieved { get; set; }
    }
}
