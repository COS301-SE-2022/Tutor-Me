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
    public class ModulesController : ControllerBase
    {
        private IModuleService moduleService;
        private IMapper mapper;
        private TutorMeContext _context;

        public ModulesController(IModuleService moduleService, IMapper mapper)
        {
            this.moduleService = moduleService;
            this.mapper = mapper;
        }

        [Authorize]
        [HttpGet]
        public IActionResult GetAllModules()
        {
            try {
                var modules = moduleService.GetAllModules();
                return Ok(modules);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetModuleById(Guid id)
        {
            try {
                var module = moduleService.GetModuleById(id);
                return Ok(module);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPost]
        public IActionResult createModule(Module module)
        {
            try {
                var moduleId = moduleService.createModule(module);
                return Ok(moduleId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteModule(Guid id)
        {
            try {
                var module = moduleService.deleteModuleById(id);
                return Ok(module);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}