using System;
using Microsoft.EntityFrameworkCore;
using FileSystem.Models;

namespace FileSystem.Data {
    public partial class FilesContext : DbContext {
        public FilesContext() {
        }

        public FilesContext(DbContextOptions<FilesContext> options)
            : base(options) {
        }

        public virtual DbSet<UserFiles> UserFiles { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder) {
            modelBuilder.Entity<UserFiles>(entity => {
                entity.HasKey(e => e.Id);

                entity.Property(e => e.Id).HasDefaultValueSql("(newid())").HasMaxLength(36);

                entity.Property(e => e.UserImage).HasColumnName("UserImage");

                entity.Property(e => e.UserTranscript).HasColumnName("UserTranscript");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}