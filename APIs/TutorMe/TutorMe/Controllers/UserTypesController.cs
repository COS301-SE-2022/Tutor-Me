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

        /// <summary> Get all the userTypes </summary>
        /// <returns> A list of user types </returns>
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

        /// <summary> Get a userType by it's Id </summary>
        /// <param name="id"> The userType's Id</param>
        /// <returns> a UserType </returns>
        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetUserTypeById(Guid id)
        {
            try {
                var userType = userTypeService.GetUserTypeById(id);
                return Ok(userType);
            }
            catch (Exception exception) {
                if(exception.Message == "UserType not found")
                    return NotFound(exception.Message);
                return BadRequest(exception.Message);
            }
        }

        /// <summary> Store a new UserType </summary>
        /// <param name="userType"> The UserType object </param>
        /// <returns> UserType's Id </returns>
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

        /// <summary> Delete a UserType by it's Id </summary>
        /// <param name="id">The UserType's Id</param>
        /// <returns></returns>
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