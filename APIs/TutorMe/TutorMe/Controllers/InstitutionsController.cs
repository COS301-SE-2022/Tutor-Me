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
            return Ok(institutions);
        }

        [HttpGet("{id}")]
        public IActionResult GetInstitutionById(Guid id)
        {
            try
            {
                var institution = institutionService.GetInstitutionById(id);
                return Ok(institution);

            }
            catch (Exception e)
            {
                if(e.Message== "Institution not found")
                {
                    return NotFound();
                }
                return BadRequest();
            
            }
         
        }

        [Authorize]
        [HttpPost]
        public IActionResult createInstitution(Institution institution)
        {
            
            var institutionId = institutionService.createInstitution(institution);
            return Ok(institutionId);
        }

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteInstitution(Guid id)
        {
            try
            {
                var institution = institutionService.deleteInstitutionById(id);
                return Ok(institution);
            }
            catch (Exception e)
            {
               if(e.Message== "Institution not found")
               {
                    return NotFound(e.Message);
               }
               return BadRequest(e.Message);
            }
           
        }
    }
}