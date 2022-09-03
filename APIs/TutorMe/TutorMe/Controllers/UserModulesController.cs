using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Entities;

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

        [HttpGet]
        public IActionResult GetAllUserModules() {
            Console.WriteLine("this is what we got");
            var userModules = userModuleService.GetAllUserModules();
            return Ok(userModules);
        }

        [HttpGet("{id}")]
        public IActionResult GetUserModulesByUserId(Guid id) {
            var userModule = userModuleService.GetUserModulesByUserId(id);
            if (userModule == null) {
                return NotFound();
            }
            return Ok(userModule);
        }

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