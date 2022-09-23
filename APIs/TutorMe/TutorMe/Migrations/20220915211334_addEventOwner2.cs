using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class addEventOwner2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Event_GroupId1",
                table: "Event");

            migrationBuilder.RenameIndex(
                name: "IX_Event_OwnerId",
                table: "Event",
                newName: "IX_Event_OwenerId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameIndex(
                name: "IX_Event_OwenerId",
                table: "Event",
                newName: "IX_Event_OwnerId");

            migrationBuilder.CreateIndex(
                name: "IX_Event_GroupId1",
                table: "Event",
                column: "UserId");
        }
    }
}
