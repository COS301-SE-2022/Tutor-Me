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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Tutee>(entity =>
            {
                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("email");

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("firstName");

                entity.Property(e => e.IdNumber)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("idNumber");

                entity.Property(e => e.Module)
                    .IsUnicode(false)
                    .HasColumnName("module");

                entity.Property(e => e.Surname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("surname");

                entity.Property(e => e.Tutors)
                    .IsUnicode(false)
                    .HasColumnName("tutors");
            });

            modelBuilder.Entity<Tutor>(entity =>
            {
                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("email");

                entity.Property(e => e.IdNumber)
                    .IsRequired()
                    .HasMaxLength(13)
                    .IsUnicode(false)
                    .HasColumnName("idNumber");

                entity.Property(e => e.Modules)
                    .IsUnicode(false)
                    .HasColumnName("modules");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("name");

                entity.Property(e => e.Surname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("surname");

                entity.Property(e => e.Tutees)
                    .IsUnicode(false)
                    .HasColumnName("tutees");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
