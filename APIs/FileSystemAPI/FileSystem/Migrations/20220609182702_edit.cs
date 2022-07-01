using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FileSystem.Migrations
{
    public partial class edit : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "id",
                table: "TutorImages",
                newName: "Tuterid");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Tuterid",
                table: "TutorImages",
                newName: "id");
        }
    }
}
