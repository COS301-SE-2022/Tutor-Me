using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;

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
            var userModules = userModuleService.GetAllUserModules();
            return Ok(userModules);
        }

        [HttpGet("{id}")]
        public IActionResult GetUserModuleById(Guid id) {
            var userModule = userModuleService.GetUserModuleById(id);
            return Ok(userModule);
        }

        [HttpPost]
        public IActionResult createUserModule(UserModule userModule) {
            var userModuleId = userModuleService.createUserModule(userModule);
            return Ok(userModuleId);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteUserModule(Guid id) {
            var userModule = userModuleService.deleteUserModuleById(id);
            return Ok(userModule);
        }
    }
}