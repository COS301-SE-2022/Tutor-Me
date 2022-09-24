using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace TutorMe.Models
{
    public partial class Institution
    {
        public Institution()
        {
            Module = new HashSet<Module>();
            User = new HashSet<User>();
        }

        public Guid InstitutionId { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        
        
        [JsonIgnore]
        public virtual ICollection<Module> Module { get; set; }
        [JsonIgnore]
        public virtual ICollection<User> User { get; set; }
    }
}