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
        //private TutorMeContext _context;

        public GroupMembersController(IGroupMemberService groupMemberService, IMapper mapper)
        {
            this.groupMemberService = groupMemberService;
            this.mapper = mapper;
        }

        /// <summary> Get all group member objects </summary>
        /// <returns> a list of group member objects</returns>
        [Authorize]
        [HttpGet]
        public IActionResult GetAllGroupMembers()
        {
            var groupMembers = groupMemberService.GetAllGroupMembers();
            return Ok(groupMembers);
        }

        /// <summary> Gets a specific groupMember object by Id </summary>
        /// <param name="id"> The groupMember object's Id</param>
        /// <returns> Returns a groupMember Id </returns>
        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetGroupMemberById(Guid id)
        {
            try
            {
                var groupMember = groupMemberService.GetGroupMemberById(id);
                return Ok(groupMember);
            }
            catch (Exception e)
            {
                if(e.Message=="GroupMember not found")
                {
                    return NotFound(e.Message);
                }
                
                return BadRequest(e.Message);

            }
        }

        /// <summary> This creates a new group member record </summary>
        /// <param name="groupMember"> Groupmember entity (check entities)</param>
        /// <returns>returns the id of the new object</returns>
        [Authorize]
        [HttpPost]
        public IActionResult createGroupMember(IGroupMember groupMember)
        {
            var groupMemberId = groupMemberService.createGroupMember(groupMember);
            return Ok(groupMemberId);
        }

        /// <summary> Delete a group member object by Id </summary>
        /// <param name="id"> The group member object's Id</param>
        /// <returns> Rreturns a boolean</returns>
        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteGroupMember(Guid id)
        {
            var groupMember = groupMemberService.deleteGroupMemberById(id);
            return Ok(groupMember);
        }

        /// <summary> Get the tutees in a group</summary>
        /// <param name="id"> The group Id</param>
        /// <returns> A list of User obkects</returns>
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

        /// <summary> Get the groups the user is in </summary>
        /// <param name="id"> The user Id</param>
        /// <returns>A list of groups</returns>
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