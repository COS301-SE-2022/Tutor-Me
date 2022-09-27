namespace FileSystem.Entities {
    public class IUserFiles {
        public Guid Id { get; set; }
        public byte[]? UserImage { get; set; }
        public byte[]? UserTranscript { get; set; }
    }
}
