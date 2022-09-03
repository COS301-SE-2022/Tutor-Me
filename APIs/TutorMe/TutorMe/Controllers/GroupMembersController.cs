using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Entities;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GroupMembersController : ControllerBase
    {
        private IGroupMemberService groupMemberService;
        private IMapper mapper;
        private TutorMeContext _context;

        public GroupMembersController(IGroupMemberService groupMemberService, IMapper mapper)
        {
            this.groupMemberService = groupMemberService;
            this.mapper = mapper;
        }

        [HttpGet]
        public IActionResult GetAllGroupMembers()
        {
            var groupMembers = groupMemberService.GetAllGroupMembers();
            return Ok(groupMembers);
        }

        [HttpGet("{id}")]
        public IActionResult GetGroupMemberById(Guid id)
        {
            var groupMember = groupMemberService.GetGroupMemberById(id);
            return Ok(groupMember);
        }

        [HttpPost]
        public IActionResult createGroupMember(IGroupMember groupMember)
        {
            var groupMemberId = groupMemberService.createGroupMember(groupMember);
            return Ok(groupMemberId);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteGroupMember(Guid id)
        {
            var groupMember = groupMemberService.deleteGroupMemberById(id);
            return Ok(groupMember);
        }

        [HttpGet("tutee/{id}")]
        public IActionResult GetGroupTutees(Guid id) {
            try {
                var groupMembers = groupMemberService.GetGroupTutees(id);
                return Ok(groupMembers);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}