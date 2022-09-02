using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InstitutionsController : ControllerBase
    {
        private IInstitutionService institutionService;
        private IMapper mapper;
        private TutorMeContext _context;

        public InstitutionsController(IInstitutionService institutionService, IMapper mapper)
        {
            this.institutionService = institutionService;
            this.mapper = mapper;
        }

        [HttpGet]
        public IActionResult GetAllInstitutions()
        {
            var institutions = institutionService.GetAllInstitutions();
            if (institutions == null) {
                return NotFound();
            }
            return Ok(institutions);
        }

        [HttpGet("{id}")]
        public IActionResult GetInstitutionById(Guid id)
        {
            try {
                var institution = institutionService.GetInstitutionById(id);
                return Ok(institution);
            }
            catch(Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpPost]
        public IActionResult createInstitution(Institution institution)
        {
            try {
                var institutionId = institutionService.createInstitution(institution);
                return Ok(institutionId);
            }
            catch(Exception e) {
                return BadRequest(e.Message);
            }

        }

        [HttpDelete("{id}")]
        public IActionResult DeleteInstitution(Guid id)
        {
            try {
                var institution = institutionService.deleteInstitutionById(id);
                return Ok(institution);
            }
            catch(Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}