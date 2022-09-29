using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class changeUserRatingToInt : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "rating",
                table: "User",
                type: "int",
                nullable: true,
                defaultValue: 0,
                oldClrType: typeof(double),
                oldType: "float",
                oldNullable: true,
                oldDefaultValue: 0.0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<double>(
                name: "rating",
                table: "User",
                type: "float",
                nullable: true,
                defaultValue: 0.0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true,
                oldDefaultValue: 0);
        }
    }
}
