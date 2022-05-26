using System;
using System.Collections.Generic;

namespace Api.Models
{
    public partial class Tutee
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string Surname { get; set; }
        public string IdNumber { get; set; }
        public string Module { get; set; }
        public string Email { get; set; }
        public string Tutors { get; set; }
    }
}
