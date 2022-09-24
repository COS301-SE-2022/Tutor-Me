
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

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteGroupVideosLinkById(Guid id) {
            try {
                groupVideosLinksService.DeleteGroupVideosLinkById(id);
                return Ok();
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }
    }
}
