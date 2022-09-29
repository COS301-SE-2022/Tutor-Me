using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Entities;
using Microsoft.AspNetCore.Authorization;

namespace TutorMe.Controllers {
    [Route("api/[controller]")]
    [ApiController]
    public class UserModulesController : ControllerBase {
        private IUserModuleService userModuleService;
        private IMapper mapper;
        private TutorMeContext _context;

        public UserModulesController(IUserModuleService userModuleService, IMapper mapper) {
            this.userModuleService = userModuleService;
            this.mapper = mapper;
        }

        /// <summary> Get UserModule records </summary>
        /// <returns> A list of UserModule objects </returns>
        [Authorize]
        [HttpGet]
        public IActionResult GetAllUserModules() {
            try {
                var userModules = userModuleService.GetAllUserModules();
                return Ok(userModules);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        /// <summary> Get UserModule by User's Id </summary>
        /// <param name="id"> User's Id </param>
        /// <returns> A list of UserModules </returns>
        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetUserModulesByUserId(Guid id) {
            try {
                var userModule = userModuleService.GetUserModulesByUserId(id);
                return Ok(userModule);
            }
            catch (Exception exception) {
                if(exception.Message == "UserModule not found") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message);
            }
        }

        /// <summary> Store a new UserModule object </summary>
        /// <param name="userModule"> The UserModule object (check entities)</param>
        /// <returns> The UserModule's Id </returns>
        [Authorize]
        [HttpPost]
        public IActionResult createUserModule(IUserModule userModule) {
            try {
                var userModuleId = userModuleService.createUserModule(userModule);
                return Ok(userModuleId);
            }
            catch(Exception exception) {
                return BadRequest(exception.Message);
            }
            
        }

        /// <summary> Delete a UserModule by it's Id </summary>
        /// <param name="id"> UserModule's Id </param>
        /// <returns> A boolean </returns>
        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteUserModule(Guid id) {
            try {
                var userModule = userModuleService.deleteUserModuleById(id);
                return Ok(userModule);
            }
            catch(Exception exception) {
                return BadRequest(exception.Message);
            }
            
        }
    }
}