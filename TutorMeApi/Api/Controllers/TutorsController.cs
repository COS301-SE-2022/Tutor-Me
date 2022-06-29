using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Cors;

namespace Api.Controllers
{
    //enable cors
    [EnableCors("AllowAll")]
    [Route("api/[controller]")]
    [ApiController]
    public class TutorsController : ControllerBase {
        private readonly TutorMeContext _context;

        public TutorsController(TutorMeContext context) {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Tutor>>> GetTutors() {
            if (_context.Tutors == null) {
                return NotFound();
            }
            return await _context.Tutors.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Tutor>> GetTutor(Guid id) {
            if (_context.Tutors == null) {
                return NotFound();
            }
            var tutor = await _context.Tutors.FindAsync(id);
                
            if (tutor == null) {
                return NotFound();
            }

            return tutor;
        }

        //GET: api/Tutors/email/
        [HttpGet("email/{email}")]
        public async Task<ActionResult<Tutor>> GetTutorByEmail( string email, Guid id = default(Guid)){
            if (_context.Tutors == null) {
                return NotFound();
            }

            var tutor = await _context.Tutors.FirstOrDefaultAsync(e => e.Email == email);

            if (tutor == null) {
                return NotFound();
            }

            return tutor;
        }
        
        // PUT: api/Tutors/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTutor(Guid id, Tutor tutor) {
            if (id != tutor.Id) {
                return BadRequest();
            }

            _context.Entry(tutor).State = EntityState.Modified;

            try {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException) {
                if (!TutorExists(id)) {
                    return NotFound();
                }
                else {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Tutors
        [HttpPost]
        public async Task<ActionResult<Tutor>> PostTutor(Tutor tutor) {
            if (_context.Tutors == null) {
                return Problem("Entity set 'TutorMeContext.Tutors'  is null.");
            }
            
            _context.Tutors.Add(tutor);
            try {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException) {
                if (TutorExists(tutor.Id)) {
                    return Conflict();
                }
                else {
                    throw;
                }
            }

            return CreatedAtAction("GetTutor", new { id = tutor.Id }, tutor);
        }

        

        // DELETE: api/Tutors/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTutor(Guid id)
        {
            if (_context.Tutors == null)
            {
                return NotFound();
            }
            var tutor = await _context.Tutors.FindAsync(id);
            if (tutor == null)
            {
                return NotFound();
            }

            _context.Tutors.Remove(tutor);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TutorExists(Guid id)
        {
            return (_context.Tutors?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
