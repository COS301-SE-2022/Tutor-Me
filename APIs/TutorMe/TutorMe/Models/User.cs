using System;
using System.Text.Json.Serialization;

namespace TutorMe.Models
{
    public partial class User
    {
        public User()
        {
            ConnectionsTutee = new HashSet<Connection>();
            ConnectionsTutor = new HashSet<Connection>();
            GroupMembers = new HashSet<GroupMember>();
            RequestsTutee = new HashSet<Request>();
            RequestsTutor = new HashSet<Request>();
            UserModule = new HashSet<UserModule>();
            Group = new HashSet<Group>();
            UserEvents = new HashSet<Event>();
            EventOwner = new HashSet<Event>();
        }

        public Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DateOfBirth { get; set; }
        public bool Status { get; set; }
        public string Gender { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public Guid UserTypeId { get; set; }
        public Guid InstitutionId { get; set; }
        public string Location { get; set; }
        public string Bio { get; set; }
        public string Year { get; set; }
        public int? Rating { get; set; }
        public int? NumberOfReviews { get; set; }

        [JsonIgnore]
        public virtual Institution Institution { get; set; }
        [JsonIgnore]
        public virtual UserType UserType { get; set; }
        [JsonIgnore]
        public virtual ICollection<Connection> ConnectionsTutee { get; set; }
        [JsonIgnore]
        public virtual ICollection<Connection> ConnectionsTutor { get; set; }
        [JsonIgnore]
        public virtual ICollection<GroupMember> GroupMembers { get; set; }
        [JsonIgnore]
        public virtual ICollection<UserModule> UserModule { get; set; }
        [JsonIgnore]
        public virtual ICollection<Request> RequestsTutee { get; set; }
        [JsonIgnore]
        public virtual ICollection<Request> RequestsTutor { get; set; }
        [JsonIgnore]
        public virtual ICollection<Group> Group { get; set; }
        [JsonIgnore]
        public virtual ICollection<Event> UserEvents { get; set; }
        [JsonIgnore]
        public virtual ICollection<Event> EventOwner { get; set; }
    }
}