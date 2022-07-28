using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TuteesController : ControllerBase
    {
        private readonly TutorMeContext _context;

        public TuteesController(TutorMeContext context)
        {
            _context = context;
        }

        // GET: api/Tutees
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Tutee>>> GetAllTutees()
        {
            if (_context.Tutees == null)
            {
                return NotFound();
            }
            return await _context.Tutees.ToListAsync();
        }

        // GET: api/Tutees/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Tutee>> GetTuteeById(Guid id)
        {
            if (_context.Tutees == null)
            {
                return NotFound();
            }
            var tutee = await _context.Tutees.FindAsync(id);

            if (tutee == null)
            {
                return NotFound();
            }

            return tutee;
        }

        // PUT: api/Tutees/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateTutee(Guid id, Tutee tutee)
        {
            if (id != tutee.Id)
            {
                return BadRequest();
            }

            _context.Entry(tutee).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TuteeExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Tutees
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Tutee>> RegisterTutee(Tutee tutee)
        {
            if (_context.Tutees == null)
            {
                return Problem("Entity set 'TutorMeContext.Tutees'  is null.");
            }
            _context.Tutees.Add(tutee);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTuteeById", new { id = tutee.Id }, tutee);
        }

        // DELETE: api/Tutees/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTuteeById(Guid id)
        {
            if (_context.Tutees == null)
            {
                return NotFound();
            }
            var tutee = await _context.Tutees.FindAsync(id);
            if (tutee == null)
            {
                return NotFound();
            }

            _context.Tutees.Remove(tutee);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TuteeExists(Guid id)
        {
            return (_context.Tutees?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
