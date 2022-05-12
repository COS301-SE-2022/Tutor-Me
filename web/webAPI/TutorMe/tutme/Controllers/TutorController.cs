using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Tutors.Data;
using Tutors.Services;

namespace TutorMe.Controllers {
    [Route("api/[controller]")]
    [ApiController]
    public class TutorController : ControllerBase {
        private readonly ITutor database;

        public TutorController(ITutor tutorp) {
            database = tutorp;
        }

        [HttpPost]
        public async Task<IActionResult> Save([FromBody] Tutor data) {

            if (data == null) {
                return BadRequest();
            }
            ModelReturned model = await database.Save(data);
            if (model == null) {
                return NotFound();
            }
            return Ok(model);
    
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetTutor(int? id) {
            if (id == null) {
                return BadRequest();
            }
            Tutor model = await database.GetTutor(id);
            if (model == null) {
                return NotFound();
            }
            return Ok(model);
        }

   
        [HttpGet]
        public IActionResult GetTutors() {

            IQueryable<Tutor> model = database.GetTutors;
            if (model == null) {
                return NotFound();
            }
            return Ok(model);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int? id) {
            if (id == null) {
                return BadRequest();
            }
            ModelReturned model = await database.DeleteAsync(id);
            if (model == null) {
                return NotFound();
            }
            return Ok(model);
        }
    }
}
