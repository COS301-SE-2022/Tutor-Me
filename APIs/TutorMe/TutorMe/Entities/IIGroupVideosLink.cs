namespace TutorMe.Entities {
    public class IGroupVideosLink {
        public Guid GroupVideoLinkId { get; set; }
        public Guid GroupId { get; set; }
        public string VideoLink { get; set; }
    }
}
