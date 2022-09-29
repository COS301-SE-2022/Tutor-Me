
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Services;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GroupVideosLinksController : ControllerBase
    {
        private readonly TutorMeContext _context;
        private IGroupVideosLinkService groupVideosLinksService;

        public GroupVideosLinksController(TutorMeContext context, IGroupVideosLinkService groupVideosLinksService) {
            _context = context;
            this.groupVideosLinksService = groupVideosLinksService;
        }

        /// <summary> Get all groupVideos by the group Id </summary>
        /// <param name="id"> Group's Id</param>
        /// <returns>Returns groupVideo record objects</returns>
        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetAllGroupVideosLinksByGroupId(Guid id) {
            try {
                var groupVideosLinks = groupVideosLinksService.GetAllGroupVideosLinksByGroupId(id);
                return Ok(groupVideosLinks);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        /// <summary> Creates a new group video record </summary>
        /// <param name="groupVideosLink"> A group video objecct (check entities)</param>
        /// <returns> Returns the new GroupVideoLink object Id</returns>
        [Authorize]
        [HttpPost]
        public IActionResult CreateGroupVideosLink(IGroupVideosLink groupVideosLink) {
            try {
                var groupVideosLinkId = groupVideosLinksService.CreateGroupVideosLink(groupVideosLink);
                return Ok(groupVideosLinkId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        /// <summary> Delete groupVideoLinks by the Id </summary>
        /// <param name="id">The groupVideosLink object's Id</param>
        /// <returns> Returns a boolean</returns>
        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteGroupVideosLinkById(Guid id) {
            try {
                groupVideosLinksService.DeleteGroupVideosLinkById(id);
                return Ok();
            }
            catch (Exception e) {
                if(e.Message == "GroupVideosLink not found") {
                    return NotFound();
                }
                return BadRequest(e.Message);
            }
        }
    }
}
