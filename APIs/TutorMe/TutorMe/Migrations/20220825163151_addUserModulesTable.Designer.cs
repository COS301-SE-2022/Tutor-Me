﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using TutorMe.Data;

#nullable disable

namespace TutorMe.Migrations
{
    [DbContext(typeof(TutorMeContext))]
    [Migration("20220825163151_addUserModulesTable")]
    partial class addUserModulesTable
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder, 1L, 1);

            modelBuilder.Entity("TutorMe.Models.Connection", b =>
                {
                    b.Property<Guid>("ConnectionId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("ModuleId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("TuteeId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid?>("TuteeUserId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("TutorId")
                        .HasColumnType("uniqueidentifier");

                    b.HasKey("ConnectionId");

                    b.HasIndex(new[] { "ModuleId" }, "IX_Connections_ModuleId");

                    b.HasIndex(new[] { "TuteeId" }, "IX_Connections_TuteeId");

                    b.HasIndex(new[] { "TuteeUserId" }, "IX_Connections_TuteeUserId");

                    b.HasIndex(new[] { "TutorId" }, "IX_Connections_TutorId");

                    b.ToTable("Connection");
                });

            modelBuilder.Entity("TutorMe.Models.Group", b =>
                {
                    b.Property<Guid>("GroupId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("Description")
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<Guid>("ModuleId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.HasKey("GroupId");

                    b.HasIndex(new[] { "ModuleId" }, "IX_Group_ModuleId");

                    b.ToTable("Group");
                });

            modelBuilder.Entity("TutorMe.Models.GroupMember", b =>
                {
                    b.Property<Guid>("GroupMemberId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<Guid>("GroupId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<Guid>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.HasKey("GroupMemberId");

                    b.HasIndex("GroupId");

                    b.HasIndex(new[] { "UserId" }, "IX_GroupMembers_UserId");

                    b.ToTable("GroupMember");
                });

            modelBuilder.Entity("TutorMe.Models.Institution", b =>
                {
                    b.Property<Guid>("InstitutionId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("Faculty")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Location")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("InstitutionId");

                    b.ToTable("Institution");
                });

            modelBuilder.Entity("TutorMe.Models.Module", b =>
                {
                    b.Property<Guid>("ModuleId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("Code")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Faculty")
                        .HasColumnType("nvarchar(max)");

                    b.Property<Guid>("InstitutionId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("ModuleName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Year")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("ModuleId");

                    b.HasIndex(new[] { "InstitutionId" }, "IX_Modules_InstitutionId");

                    b.ToTable("Module");
                });

            modelBuilder.Entity("TutorMe.Models.Request", b =>
                {
                    b.Property<Guid>("RequestId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("DateCreated")
                        .HasColumnType("nvarchar(max)");

                    b.Property<Guid>("ModuleId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("TuteeId")
                        .HasColumnType("uniqueidentifier");

                    b.Property<Guid>("TutorId")
                        .HasColumnType("uniqueidentifier");

                    b.HasKey("RequestId");

                    b.HasIndex(new[] { "ModuleId" }, "IX_Requests_ModuleId");

                    b.HasIndex(new[] { "TuteeId" }, "IX_Requests_TuteeId");

                    b.HasIndex(new[] { "TutorId" }, "IX_Requests_TutorId");

                    b.ToTable("Request");
                });

            modelBuilder.Entity("TutorMe.Models.User", b =>
                {
                    b.Property<Guid>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("Bio")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("DateOfBirth")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Gender")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<Guid>("InstitutionId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Location")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Password")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("Rating")
                        .HasColumnType("int")
                        .HasColumnName("rating");

                    b.Property<bool>("Status")
                        .HasColumnType("bit");

                    b.Property<Guid>("UserTypeId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("Year")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UserId");

                    b.HasIndex(new[] { "InstitutionId" }, "IX_User_InstitutionId");

                    b.HasIndex(new[] { "UserTypeId" }, "IX_User_UserTypeId");

                    b.ToTable("User");
                });

            modelBuilder.Entity("TutorMe.Models.UserModule", b =>
                {
                    b.Property<Guid>("UserModuleId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<Guid>("ModuleId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<Guid>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.HasKey("UserModuleId");

                    b.HasIndex("ModuleId");

                    b.HasIndex(new[] { "UserId" }, "IX_UserModule_UserId");

                    b.ToTable("UserModule");
                });

            modelBuilder.Entity("TutorMe.Models.UserType", b =>
                {
                    b.Property<Guid>("UserTypeId")
                        .ValueGeneratedOnAdd()
                        .HasMaxLength(36)
                        .HasColumnType("uniqueidentifier")
                        .HasDefaultValueSql("(newid())");

                    b.Property<string>("Type")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UserTypeId");

                    b.ToTable("UserType");
                });

            modelBuilder.Entity("TutorMe.Models.Connection", b =>
                {
                    b.HasOne("TutorMe.Models.Module", "Module")
                        .WithMany("Connections")
                        .HasForeignKey("ModuleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("TutorMe.Models.User", "Tutee")
                        .WithMany("ConnectionsTutee")
                        .HasForeignKey("TuteeId")
                        .IsRequired();

                    b.HasOne("TutorMe.Models.User", "Tutor")
                        .WithMany("ConnectionsTutor")
                        .HasForeignKey("TutorId")
                        .IsRequired();

                    b.Navigation("Module");

                    b.Navigation("Tutee");

                    b.Navigation("Tutor");
                });

            modelBuilder.Entity("TutorMe.Models.Group", b =>
                {
                    b.HasOne("TutorMe.Models.Module", "Module")
                        .WithMany("Group")
                        .HasForeignKey("ModuleId")
                        .IsRequired()
                        .HasConstraintName("Group_Module_FK");

                    b.Navigation("Module");
                });

            modelBuilder.Entity("TutorMe.Models.GroupMember", b =>
                {
                    b.HasOne("TutorMe.Models.Group", "Group")
                        .WithMany("GroupMembers")
                        .HasForeignKey("GroupId")
                        .IsRequired()
                        .HasConstraintName("GroupMembers_Group_FK");

                    b.HasOne("TutorMe.Models.User", "User")
                        .WithMany("GroupMembers")
                        .HasForeignKey("UserId")
                        .IsRequired()
                        .HasConstraintName("GroupMembers_User_FK");

                    b.Navigation("Group");

                    b.Navigation("User");
                });

            modelBuilder.Entity("TutorMe.Models.Module", b =>
                {
                    b.HasOne("TutorMe.Models.Institution", "Institution")
                        .WithMany("Module")
                        .HasForeignKey("InstitutionId")
                        .IsRequired()
                        .HasConstraintName("Modules_Institution_FK");

                    b.Navigation("Institution");
                });

            modelBuilder.Entity("TutorMe.Models.Request", b =>
                {
                    b.HasOne("TutorMe.Models.Module", "Module")
                        .WithMany("RequestModule")
                        .HasForeignKey("ModuleId")
                        .IsRequired()
                        .HasConstraintName("Requests_Module_FK");

                    b.HasOne("TutorMe.Models.User", "Tutee")
                        .WithMany("RequestsTutee")
                        .HasForeignKey("TuteeId")
                        .IsRequired()
                        .HasConstraintName("Requests_Tutee_FK");

                    b.HasOne("TutorMe.Models.User", "Tutor")
                        .WithMany("RequestsTutor")
                        .HasForeignKey("TutorId")
                        .IsRequired()
                        .HasConstraintName("Requests_Tutor_FK");

                    b.Navigation("Module");

                    b.Navigation("Tutee");

                    b.Navigation("Tutor");
                });

            modelBuilder.Entity("TutorMe.Models.User", b =>
                {
                    b.HasOne("TutorMe.Models.Institution", "Institution")
                        .WithMany("User")
                        .HasForeignKey("InstitutionId")
                        .IsRequired()
                        .HasConstraintName("User_Institutioin_FK");

                    b.HasOne("TutorMe.Models.UserType", "UserType")
                        .WithMany("User")
                        .HasForeignKey("UserTypeId")
                        .IsRequired()
                        .HasConstraintName("User_UserType_FK");

                    b.Navigation("Institution");

                    b.Navigation("UserType");
                });

            modelBuilder.Entity("TutorMe.Models.UserModule", b =>
                {
                    b.HasOne("TutorMe.Models.Module", "Module")
                        .WithMany("UserModule")
                        .HasForeignKey("ModuleId")
                        .IsRequired()
                        .HasConstraintName("UserModule_Group_FK");

                    b.HasOne("TutorMe.Models.User", "User")
                        .WithMany("UserModule")
                        .HasForeignKey("UserId")
                        .IsRequired()
                        .HasConstraintName("UserModule_User_FK");

                    b.Navigation("Module");

                    b.Navigation("User");
                });

            modelBuilder.Entity("TutorMe.Models.Group", b =>
                {
                    b.Navigation("GroupMembers");
                });

            modelBuilder.Entity("TutorMe.Models.Institution", b =>
                {
                    b.Navigation("Module");

                    b.Navigation("User");
                });

            modelBuilder.Entity("TutorMe.Models.Module", b =>
                {
                    b.Navigation("Connections");

                    b.Navigation("Group");

                    b.Navigation("RequestModule");

                    b.Navigation("UserModule");
                });

            modelBuilder.Entity("TutorMe.Models.User", b =>
                {
                    b.Navigation("ConnectionsTutee");

                    b.Navigation("ConnectionsTutor");

                    b.Navigation("GroupMembers");

                    b.Navigation("RequestsTutee");

                    b.Navigation("RequestsTutor");

                    b.Navigation("UserModule");
                });

            modelBuilder.Entity("TutorMe.Models.UserType", b =>
                {
                    b.Navigation("User");
                });
#pragma warning restore 612, 618
        }
    }
}
