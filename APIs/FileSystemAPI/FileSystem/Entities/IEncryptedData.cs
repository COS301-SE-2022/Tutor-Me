namespace FileSystem.Entities {
    public class IEncryptedData {
        public byte[] data { get; set; }
        public byte[] key { get; set; }
        public byte[] iv { get; set; }
    }
}
