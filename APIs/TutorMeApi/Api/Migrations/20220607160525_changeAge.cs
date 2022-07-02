using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Api.Migrations
{
    public partial class changeAge : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "age",
                table: "Tutor",
                newName: "dateOfBirth");

            migrationBuilder.RenameColumn(
                name: "age",
                table: "Tutee",
                newName: "dateOfBirth");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "dateOfBirth",
                table: "Tutor",
                newName: "age");

            migrationBuilder.RenameColumn(
                name: "dateOfBirth",
                table: "Tutee",
                newName: "age");
        }
    }
}
