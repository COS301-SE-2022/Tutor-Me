using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserTypesController : ControllerBase
    {
        private IUserTypeService userTypeService;
        private IMapper mapper;
        private TutorMeContext _context;

        public UserTypesController(IUserTypeService userTypeService, IMapper mapper)
        {
            this.userTypeService = userTypeService;
            this.mapper = mapper;
        }

        [HttpGet]
        public IActionResult GetAllUserTypes()
        {
            var userTypes = userTypeService.GetAllUserTypes();
            return Ok(userTypes);
        }

        [HttpGet("{id}")]
        public IActionResult GetUserTypeById(Guid id)
        {
            var userType = userTypeService.GetUserTypeById(id);
            return Ok(userType);
        }

        [HttpPost]
        public IActionResult createUserType(UserType userType)
        {
            var userTypeId = userTypeService.createUserType(userType);
            return Ok(userTypeId);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteUserType(Guid id)
        {
            var userType = userTypeService.deleteUserTypeById(id);
            return Ok(userType);
        }
    }
}