namespace TutorMe.Entities {
    public class IGroupMember {
        public Guid GroupMemberId { get; set; }
        public Guid GroupId { get; set; }
        public Guid UserId { get; set; }
    }
}
