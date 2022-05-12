using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tutors.Data;


//will come back to making the e repo

namespace Tutors.Repo
{
    public class TutorDbContext: DbContext{
        public TutorDbContext(DbContextOptions<TutorDbContext> options) : base(options) { }  //create database here

        public DbSet<Tutor> Tutors { get; set; }

    }
}
