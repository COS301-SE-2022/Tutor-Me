using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Api.Migrations
{
    public partial class changeInts : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "rating",
                table: "Tutor",
                type: "varchar(1)",
                unicode: false,
                maxLength: 1,
                nullable: false,
                defaultValueSql: "0",
                oldClrType: typeof(int),
                oldType: "int",
                oldUnicode: false,
                oldMaxLength: 1,
                oldDefaultValueSql: "0");

            migrationBuilder.AlterColumn<string>(
                name: "age",
                table: "Tutor",
                type: "varchar(max)",
                unicode: false,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int",
                oldUnicode: false);

            migrationBuilder.AlterColumn<string>(
                name: "age",
                table: "Tutee",
                type: "varchar(max)",
                unicode: false,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int",
                oldUnicode: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "rating",
                table: "Tutor",
                type: "int",
                unicode: false,
                maxLength: 1,
                nullable: false,
                defaultValueSql: "0",
                oldClrType: typeof(string),
                oldType: "varchar(1)",
                oldUnicode: false,
                oldMaxLength: 1,
                oldDefaultValueSql: "0");

            migrationBuilder.AlterColumn<int>(
                name: "age",
                table: "Tutor",
                type: "int",
                unicode: false,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(max)",
                oldUnicode: false);

            migrationBuilder.AlterColumn<int>(
                name: "age",
                table: "Tutee",
                type: "int",
                unicode: false,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(max)",
                oldUnicode: false);
        }
    }
}
