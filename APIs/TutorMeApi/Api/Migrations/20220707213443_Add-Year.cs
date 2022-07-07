using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Api.Migrations
{
    public partial class AddYear : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Modules",
                columns: table => new
                {
                    code = table.Column<string>(type: "varchar(800)", unicode: false, maxLength: 800, nullable: false),
                    moduleName = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    institution = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    faculty = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    year = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Modules__357D4CF8AD050163", x => x.code);
                });

            migrationBuilder.CreateTable(
                name: "Requests",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    requesterId = table.Column<string>(type: "varchar(36)", unicode: false, maxLength: 36, nullable: false),
                    receiverId = table.Column<string>(type: "varchar(36)", unicode: false, maxLength: 36, nullable: false),
                    dateCreated = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Requests", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Tutee",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    firstName = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    lastName = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    dateOfBirth = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    status = table.Column<string>(type: "varchar(1)", unicode: false, maxLength: 1, nullable: false, defaultValueSql: "('0')"),
                    gender = table.Column<string>(type: "varchar(1)", unicode: false, maxLength: 1, nullable: false),
                    institution = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    faculty = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    course = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    modules = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    email = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    password = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    location = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    tutorsCode = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    bio = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    connections = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    year = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tutee", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Tutor",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    firstName = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    lastName = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    dateOfBirth = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    gender = table.Column<string>(type: "varchar(1)", unicode: false, maxLength: 1, nullable: false),
                    status = table.Column<string>(type: "varchar(1)", unicode: false, maxLength: 1, nullable: false, defaultValueSql: "('0')"),
                    faculty = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    course = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    institution = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    modules = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    email = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    password = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false),
                    location = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    tuteesCode = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    bio = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    connections = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    rating = table.Column<string>(type: "varchar(1)", unicode: false, maxLength: 1, nullable: false, defaultValueSql: "((0))"),
                    requests = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    year = table.Column<string>(type: "varchar(max)", unicode: false, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tutor", x => x.id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Modules");

            migrationBuilder.DropTable(
                name: "Requests");

            migrationBuilder.DropTable(
                name: "Tutee");

            migrationBuilder.DropTable(
                name: "Tutor");
        }
    }
}
