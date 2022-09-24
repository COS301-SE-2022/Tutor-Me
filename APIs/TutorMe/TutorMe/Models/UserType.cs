using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace TutorMe.Models
{
    public partial class UserType
    {
        public UserType()
        {
            User = new HashSet<User>();
        }

        public Guid UserTypeId { get; set; }
        public string Type { get; set; }

        [JsonIgnore]
        public virtual ICollection<User> User { get; set; }
    }
}