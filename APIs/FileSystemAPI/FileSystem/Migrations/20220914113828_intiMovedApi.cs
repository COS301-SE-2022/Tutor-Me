using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FileSystem.Migrations
{
    public partial class intiMovedApi : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "TuteeFiles",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    tuteeImage = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    tuteeTranscript = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TuteeFiles", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "TutorFiles",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    tutorImage = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    tutorTranscript = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TutorFiles", x => x.id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TuteeFiles");

            migrationBuilder.DropTable(
                name: "TutorFiles");
        }
    }
}
