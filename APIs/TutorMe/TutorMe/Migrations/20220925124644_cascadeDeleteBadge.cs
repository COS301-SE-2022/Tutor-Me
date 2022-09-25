using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TutorMe.Migrations
{
    public partial class cascadeDeleteBadge : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "UserBadge_Group_FK",
                table: "UserBadge");

            migrationBuilder.AddForeignKey(
                name: "UserBadge_Group_FK",
                table: "UserBadge",
                column: "BadgeId",
                principalTable: "Badge",
                principalColumn: "BadgeId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "UserBadge_Group_FK",
                table: "UserBadge");

            migrationBuilder.AddForeignKey(
                name: "UserBadge_Group_FK",
                table: "UserBadge",
                column: "BadgeId",
                principalTable: "Badge",
                principalColumn: "BadgeId");
        }
    }
}
