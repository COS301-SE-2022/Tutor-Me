using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class faculty : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "videoLink",
                table: "Event",
                newName: "VideoLink");

            migrationBuilder.RenameColumn(
                name: "dateOfEvent",
                table: "Event",
                newName: "DateOfEvent");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "VideoLink",
                table: "Event",
                newName: "videoLink");

            migrationBuilder.RenameColumn(
                name: "DateOfEvent",
                table: "Event",
                newName: "dateOfEvent");
        }
    }
}
