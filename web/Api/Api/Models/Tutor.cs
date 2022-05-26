using System;
using System.Collections.Generic;

namespace Api.Models
{
    public partial class Tutor
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string IdNumber { get; set; }
        public string Modules { get; set; }
        public string Email { get; set; }
        public string Tutees { get; set; }
    }
}
