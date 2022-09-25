using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using Microsoft.AspNetCore.Authorization;

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

        [Authorize]
        [HttpGet]
        public IActionResult GetAllUserTypes()
        {
            try {
                var userTypes = userTypeService.GetAllUserTypes();
                return Ok(userTypes);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetUserTypeById(Guid id)
        {
            try {
                var userType = userTypeService.GetUserTypeById(id);
                return Ok(userType);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPost]
        public IActionResult createUserType(UserType userType)
        {
            try {
                var userTypeId = userTypeService.createUserType(userType);
                return Ok(userTypeId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteUserType(Guid id)
        {
            try {
                var userType = userTypeService.deleteUserTypeById(id);
                return Ok(userType);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}