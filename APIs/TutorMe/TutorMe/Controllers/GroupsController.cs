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
    public class GroupsController : ControllerBase
    {
        private IGroupService groupService;
        private IMapper mapper;
        private TutorMeContext _context;

        public GroupsController(IGroupService groupService, IMapper mapper)
        {
            this.groupService = groupService;
            this.mapper = mapper;
        }
        
        [Authorize]
        [HttpGet]
        public IActionResult GetAllGroups()
        {
            try {
                var groups = groupService.GetAllGroups();
                return Ok(groups);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("user/{id}")]
        public IActionResult GetGroupsByUserId(Guid id) {
            try {
                var groups = groupService.GetGroupsByUserId(id);
                return Ok(groups);
            }
            catch (Exception exception) {
                if(exception.Message == "User not found") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message);
            }
            
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetGroupById(Guid id)
        {
            try {
                var group = groupService.GetGroupById(id);
                return Ok(group);
            }
            catch (Exception exception) {
                if(exception.Message == "Group not found") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPost]
        public IActionResult createGroup(IGroup group)
        {
            try {
                var groupId = groupService.createGroup(group);
                return Ok(groupId);
            }
            catch (Exception exception) {
                if(exception.Message == "This Group already exists.") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message + " " + exception.StackTrace + " " + exception.InnerException);
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteGroup(Guid id)
        {
            try {
                var group = groupService.deleteGroupById(id);
                return Ok(group);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPut("description/{id}")]
        public IActionResult UpdateGroupDescription(Guid id, string description) {
            try {
                var group = groupService.updateGroupDescription(id, description);
                return Ok(group);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPut("videoId/{id}")]
        public IActionResult UpdateGroupVideoId(Guid id, string videoId) {
            try {
                var group = groupService.updateGroupVideoId(id, videoId);
                return Ok(group);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}