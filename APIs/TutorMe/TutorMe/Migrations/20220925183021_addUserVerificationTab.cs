using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class addUserVerificationTab : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "verified",
                table: "User",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "verified",
                table: "User");
        }
    }
}
