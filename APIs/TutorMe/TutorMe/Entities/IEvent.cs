namespace TutorMe.Entities {
    public class IEvent {
        public Guid EventId { get; set; }
        public Guid? GroupId { get; set; }
        public Guid OwnerId { get; set; }
        public Guid UserId { get; set; }
        public string DateOfEvent { get; set; }
        public string VideoLink { get; set; }
        public string TimeOfEvent { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
    }
}
