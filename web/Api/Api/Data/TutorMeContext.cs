using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Api.Models;

namespace Api.Data
{
    public partial class TutorMeContext : DbContext
    {
        public TutorMeContext()
        {
        }

        public TutorMeContext(DbContextOptions<TutorMeContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Tutee> Tutees { get; set; }
        public virtual DbSet<Tutor> Tutors { get; set; }

        

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
