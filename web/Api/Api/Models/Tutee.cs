using System;
using System.Collections.Generic;

namespace Api.Models
{
    public partial class Tutee
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Age { get; set; }
        public string Gender { get; set; }
        public string Institution { get; set; }
        public string Modules { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Location { get; set; }
        public string TutorsCode { get; set; }
        public string Bio { get; set; }
        public string Connections { get; set; }
    }
}
