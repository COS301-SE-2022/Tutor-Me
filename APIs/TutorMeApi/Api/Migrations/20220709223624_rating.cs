using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Api.Migrations
{
    public partial class rating : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "rating",
                table: "Tutor",
                type: "varchar(max)",
                unicode: false,
                nullable: false,
                defaultValueSql: "('0,0')",
                oldClrType: typeof(string),
                oldType: "varchar(1)",
                oldUnicode: false,
                oldMaxLength: 1,
                oldDefaultValueSql: "((0))");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "rating",
                table: "Tutor",
                type: "varchar(1)",
                unicode: false,
                maxLength: 1,
                nullable: false,
                defaultValueSql: "((0))",
                oldClrType: typeof(string),
                oldType: "varchar(max)",
                oldUnicode: false,
                oldDefaultValueSql: "('0,0')");
        }
    }
}
