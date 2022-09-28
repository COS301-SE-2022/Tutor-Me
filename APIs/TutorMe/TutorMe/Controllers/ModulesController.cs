using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using Microsoft.AspNetCore.Authorization;
using TutorMe.Entities;

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

        /// <summary> Get all the modules stored </summary>
        /// <returns> A list of modules </returns>
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

        /// <summary> Get a modules by it's Id </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetModuleById(Guid id)
        {
            try {
                var module = moduleService.GetModuleById(id);
                return Ok(module);
            }
            catch (Exception exception) {
                if(exception.Message == "Module not found") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message);
            }
        }

        /// <summary> Store a new modules </summary>
        /// <param name="module"> The module object (check entities)</param>
        /// <returns> The modules's Id</returns>
        [Authorize]
        [HttpPost]
        public IActionResult createModule(IModule module)
        {
            try {
                var moduleId = moduleService.createModule(module);
                return Ok(moduleId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        /// <summary> Delete a module by Id </summary>
        /// <param name="id"> The module's Id </param>
        /// <returns> A boolean </returns>
        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteModule(Guid id)
        {
            try {
                var module = moduleService.deleteModuleById(id);
                return Ok(module);
            }
            catch (Exception exception) {
                if(exception.Message == "Module not found") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message);
            }
        }
    }
}