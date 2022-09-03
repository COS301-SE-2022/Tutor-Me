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

        [HttpGet("user/{id}")]
        public IActionResult GetGroupsByUserId(Guid id) {
            try {
                var groups = groupService.GetGroupsByUserId(id);
                return Ok(groups);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpGet("{id}")]
        public IActionResult GetGroupById(Guid id)
        {
            try {
                var group = groupService.GetGroupById(id);
                return Ok(group);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpPost]
        public IActionResult createGroup(IGroup group)
        {
            try {
                var groupId = groupService.createGroup(group);
                return Ok(groupId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

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
    }
}