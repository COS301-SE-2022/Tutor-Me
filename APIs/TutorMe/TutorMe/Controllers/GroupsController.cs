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
        
        /// <summary> Get all the groups stored</summary>
        /// <returns>A list of group objects</returns>
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

        /// <summary> Gets group owned by a user</summary>
        /// <param name="id"> The user's Id</param>
        /// <returns> Returns a list of groups </returns>
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

        /// <summary> Get a group by it's Id </summary>
        /// <param name="id"> The group's Id</param>
        /// <returns> Returns a group object</returns>
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

        /// <summary> Stores a new group </summary>
        /// <param name="group">A group object (check entities)</param>
        /// <returns> Returns the new group's Id </returns>
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

        /// <summary> Delete a group by it's Id </summary>
        /// <param name="id"> The group's Id</param>
        /// <returns> Returns a boolean</returns>
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

        /// <summary> Update group's description</summary>
        /// <param name="id"> The group's description </param>
        /// <param name="description"> The new group's description </param>
        /// <returns> Returns a boolean </returns>
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

        /// <summary> Updates the groups meeting link </summary>
        /// <param name="id"> The group's Id </param>
        /// <param name="videoId"> The new group's meeting link</param>
        /// <returns> Returns a boolean </returns>
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