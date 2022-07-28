﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
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

        public virtual DbSet<Module> Modules { get; set; }
        public virtual DbSet<Request> Requests { get; set; }
        public virtual DbSet<Admin> Admin { get; set; }
        public virtual DbSet<Tutee> Tutees { get; set; }
        public virtual DbSet<Tutor> Tutors { get; set; }
        public virtual DbSet<Group> Group { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Module>(entity =>{
                entity.ToTable("Module");

                entity.HasKey(e => e.Code)
                    .HasName("PK__Modules__357D4CF8AD050163");

                entity.Property(e => e.Code)
                    .HasMaxLength(800)
                    .IsUnicode(false)
                    .HasColumnName("code");

                entity.Property(e => e.Faculty)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("faculty");

                entity.Property(e => e.Institution)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("institution");

                entity.Property(e => e.Year)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("year");

                entity.Property(e => e.ModuleName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("moduleName");
            });

            modelBuilder.Entity<Admin>(entity =>{

                entity.ToTable("Admin");

                entity.Property(e => e.Id)
                    .HasMaxLength(800)
                    .IsUnicode(false)
                    .HasColumnName("id");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("name");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("email");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("password");
            });

            modelBuilder.Entity<Request>(entity =>
            {
                entity.ToTable("Request");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.DateCreated)
                    .IsRequired()
                    .HasMaxLength(10)
                    .IsUnicode(false)
                    .HasColumnName("dateCreated");

                entity.Property(e => e.ReceiverId)
                    .IsRequired()
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("receiverId");

                entity.Property(e => e.RequesterId)
                    .IsRequired()
                    .HasMaxLength(36)
                    .IsUnicode(false)
                    .HasColumnName("requesterId");

                entity.Property(e => e.ModuleCode)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("moduleCode");
            });

            modelBuilder.Entity<Group>(entity =>
            {
                entity.ToTable("Group");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.ModuleCode)
                    .IsRequired()
                    .HasMaxLength(10)
                    .IsUnicode(false)
                    .HasColumnName("moduleCode");

                entity.Property(e => e.ModuleName)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("moduleName");

                entity.Property(e => e.Tutees)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("tutees");

                entity.Property(e => e.TutorId)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("tutorId");
                
                entity.Property(e => e.Description)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("description");

                entity.Property(e => e.GroupLink)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("groupLink");

            });

            modelBuilder.Entity<Tutee>(entity =>
            {
                entity.ToTable("Tutee");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.Bio)
                    .IsUnicode(false)
                    .HasColumnName("bio");

                entity.Property(e => e.Connections)
                    .IsUnicode(false)
                    .HasColumnName("connections");

                entity.Property(e => e.Course)
                    .IsUnicode(false)
                    .HasColumnName("course");

                entity.Property(e => e.DateOfBirth)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("dateOfBirth");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("email");

                entity.Property(e => e.Faculty)
                    .IsUnicode(false)
                    .HasColumnName("faculty");

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("firstName");

                entity.Property(e => e.Gender)
                    .IsRequired()
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .HasColumnName("gender");

                entity.Property(e => e.Institution)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("institution");

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("lastName");

                entity.Property(e => e.Location)
                    .IsUnicode(false)
                    .HasColumnName("location");

                entity.Property(e => e.Modules)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("modules");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("password");

                entity.Property(e => e.Status)
                    .IsRequired()
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .HasColumnName("status")
                    .HasDefaultValueSql("('0')");

                entity.Property(e => e.TutorsCode)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("tutorsCode");

                entity.Property(e => e.Year)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("year");

                entity.Property(e => e.GroupIds)
                    .IsUnicode(false)
                    .HasColumnName("groupIds");
            });

            modelBuilder.Entity<Tutor>(entity =>{

                entity.ToTable("Tutor");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.Bio)
                    .IsUnicode(false)
                    .HasColumnName("bio");

                entity.Property(e => e.Connections)
                    .IsUnicode(false)
                    .HasColumnName("connections");

                entity.Property(e => e.Course)
                    .IsUnicode(false)
                    .HasColumnName("course");

                entity.Property(e => e.DateOfBirth)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("dateOfBirth");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("email");

                entity.Property(e => e.Faculty)
                    .IsUnicode(false)
                    .HasColumnName("faculty");

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("firstName");

                entity.Property(e => e.Gender)
                    .IsRequired()
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .HasColumnName("gender");

                entity.Property(e => e.Institution)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("institution");

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("lastName");

                entity.Property(e => e.Location)
                    .IsUnicode(false)
                    .HasColumnName("location");

                entity.Property(e => e.Modules)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("modules");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("password");

                entity.Property(e => e.Rating)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("rating")
                    .HasDefaultValueSql("('0,0')");

                entity.Property(e => e.Requests)
                    .IsUnicode(false)
                    .HasColumnName("requests");

                entity.Property(e => e.Status)
                    .IsRequired()
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .HasColumnName("status")
                    .HasDefaultValueSql("('0')");

                entity.Property(e => e.TuteesCode)
                    .IsUnicode(false)
                    .HasColumnName("tuteesCode");

                entity.Property(e => e.Year)
                    .IsRequired()
                    .IsUnicode(false)
                    .HasColumnName("year");

                entity.Property(e => e.GroupIds)
                    .IsUnicode(false)
                    .HasColumnName("groupIds");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

      
    }
}