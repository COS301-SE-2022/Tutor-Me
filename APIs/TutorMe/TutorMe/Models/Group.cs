﻿using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace TutorMe.Models
{
    public partial class Group
    {
        public Group()
        {
            GroupMembers = new HashSet<GroupMember>();
        }

        public Guid GroupId { get; set; }
        public Guid ModuleId { get; set; }
        public string Description { get; set; }

        //TODO: add owner field to group

        [JsonIgnore]
        public virtual Module Module { get; set; }
        [JsonIgnore]
        public virtual ICollection<GroupMember> GroupMembers { get; set; }
    }
}