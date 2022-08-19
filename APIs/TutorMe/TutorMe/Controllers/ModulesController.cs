using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;

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

        [HttpGet]
        public IActionResult GetAllModules()
        {
            var modules = moduleService.GetAllModules();
            return Ok(modules);
        }

        [HttpGet("{id}")]
        public IActionResult GetModuleById(Guid id)
        {
            var module = moduleService.GetModuleById(id);
            return Ok(module);
        }

        [HttpPost]
        public IActionResult createModule(Module module)
        {
            var moduleId = moduleService.createModule(module);
            return Ok(moduleId);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteModule(Guid id)
        {
            var module = moduleService.deleteModuleById(id);
            return Ok(module);
        }
    }
}