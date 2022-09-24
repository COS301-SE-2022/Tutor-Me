using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace TutorMe.Models
{
    public partial class GroupMember
    {
        public Guid GroupMemberId { get; set; }
        public Guid GroupId { get; set; }
        public Guid UserId { get; set; }

        [JsonIgnore]
        public virtual Group Group { get; set; }
        [JsonIgnore]
        public virtual User User { get; set; }
    }
}