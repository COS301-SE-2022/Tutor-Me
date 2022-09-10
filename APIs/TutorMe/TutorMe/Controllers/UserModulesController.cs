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

        [Authorize]
        [HttpGet]
        public IActionResult GetAllUserModules() {
            Console.WriteLine("this is what we got");
            try {
                var userModules = userModuleService.GetAllUserModules();
                return Ok(userModules);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetUserModulesByUserId(Guid id) {
            try {
                var userModule = userModuleService.GetUserModulesByUserId(id);
                if (userModule == null) {
                    return NotFound();
                }
                return Ok(userModule);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

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