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
            var groups = groupService.GetAllGroups();
            return Ok(groups);
        }

        [HttpGet("{id}")]
        public IActionResult GetGroupById(Guid id)
        {
            var group = groupService.GetGroupById(id);
            return Ok(group);
        }

        [HttpPost]
        public IActionResult createGroup(IGroup group)
        {
            var groupId = groupService.createGroup(group);
            return Ok(groupId);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteGroup(Guid id)
        {
            var group = groupService.deleteGroupById(id);
            return Ok(group);
        }
    }
}