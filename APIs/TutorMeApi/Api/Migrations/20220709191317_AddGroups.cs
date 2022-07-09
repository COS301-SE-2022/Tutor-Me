using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Api.Migrations
{
    public partial class AddGroups : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "groupIds",
                table: "Tutor",
                type: "varchar(max)",
                unicode: false,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "groupIds",
                table: "Tutee",
                type: "varchar(max)",
                unicode: false,
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Group",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    moduleCode = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: false),
                    moduleName = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    tutees = table.Column<string>(type: "varchar(36)", unicode: false, maxLength: 36, nullable: false),
                    tutorId = table.Column<string>(type: "varchar(36)", unicode: false, maxLength: 36, nullable: false),
                    description = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Group", x => x.id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Group");

            migrationBuilder.DropColumn(
                name: "groupIds",
                table: "Tutor");

            migrationBuilder.DropColumn(
                name: "groupIds",
                table: "Tutee");
        }
    }
}
