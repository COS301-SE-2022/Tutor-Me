using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FileSystem.Migrations
{
    public partial class initFiles : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "UserFiles",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", maxLength: 36, nullable: false, defaultValueSql: "(newid())"),
                    UserImage = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    UserTranscript = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    ImageKey = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    ImageIV = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    TranscriptKey = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    TranscriptIV = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserFiles", x => x.Id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserFiles");
        }
    }
}
