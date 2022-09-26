using System;
using System.Collections.Generic;

namespace FileSystem.Models {
    public partial class UserFiles {
        public Guid Id { get; set; }
        public byte[]? UserImage { get; set; }
        public byte[]? UserTranscript { get; set; }
        public byte[]? ImageKey { get; set; }
        public byte[]? ImageIV { get; set; }
        public byte[]? TranscriptKey { get; set; }
        public byte[]? TranscriptIV { get; set; }
    }
}