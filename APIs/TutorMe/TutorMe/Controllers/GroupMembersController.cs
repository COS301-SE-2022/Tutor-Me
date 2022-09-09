using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Entities;
using Microsoft.AspNetCore.Authorization;

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
        
        [Authorize]
        [HttpGet]
        public IActionResult GetAllGroupMembers()
        {
            var groupMembers = groupMemberService.GetAllGroupMembers();
            return Ok(groupMembers);
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetGroupMemberById(Guid id)
        {
            var groupMember = groupMemberService.GetGroupMemberById(id);
            return Ok(groupMember);
        }
        
        [Authorize]
        [HttpPost]
        public IActionResult createGroupMember(IGroupMember groupMember)
        {
            var groupMemberId = groupMemberService.createGroupMember(groupMember);
            return Ok(groupMemberId);
        }

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteGroupMember(Guid id)
        {
            var groupMember = groupMemberService.deleteGroupMemberById(id);
            return Ok(groupMember);
        }

        [Authorize]
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

        [Authorize]
        [HttpGet("group/{id}")]
        public IActionResult getUserGroups(Guid id) {
            try {
                var groups = groupMemberService.GetUserGroups(id);
                return Ok(groups);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}