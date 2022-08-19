using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Api.Data;
using Api.Models;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RequestsController : ControllerBase
    {
        private readonly TutorMeContext _context;

        public RequestsController(TutorMeContext context)
        {
            _context = context;
        }

        // GET: api/Requests
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Request>>> GetRequests()
        {
          if (_context.Requests == null)
          {
              return NotFound();
          }
            return await _context.Requests.ToListAsync();
        }

        // GET: api/Requests/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Request>> GetRequest(Guid id)
        {
          if (_context.Requests == null)
          {
              return NotFound();
          }
            var request = await _context.Requests.FindAsync(id);

            if (request == null)
            {
                return NotFound();
            }

            return request;
        }

        [HttpGet("Tutor/{tutorId}")]
        public async Task<ActionResult<Request>> GetTutorRequests(String tutorId)
        {
            if (_context.Tutors == null)
            {
                return NotFound();
            }
            var tutorRequests = await _context.Requests.Where(e => e.ReceiverId == tutorId).ToListAsync();

            if (tutorRequests == null)
            {
                return NotFound();
            }

            return Ok(tutorRequests);
        }

        [HttpGet("Tutee/{tuteeId}")]
        public async Task<ActionResult<Request>> GetTuteeRequests(String tuteeId)
        {
            if (_context.Tutors == null)
            {
                return NotFound();
            }

            //var tutor = await _context.Tutors.FirstOrDefaultAsync(e => e.Email == email);
            //var tutorRequests = await _context.Requests.FindAsync(e => e.RequesterId == id);
            var tuteeRequests = await _context.Requests.Where(e => e.RequesterId == tuteeId).ToListAsync();

            if (tuteeRequests == null)
            {
                return NotFound();
            }

            return Ok(tuteeRequests);
        }

        // PUT: api/Requests/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRequest(Guid id, Request request)
        {
            if (id != request.Id)
            {
                return BadRequest();
            }

            _context.Entry(request).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RequestExists(id))
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

        // POST: api/Requests
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Request>> PostRequest(Request request)
        {
          if (_context.Requests == null)
          {
              return Problem("Entity set 'TutorMeContext.Requests'  is null.");
          }
            _context.Requests.Add(request);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetRequest", new { id = request.Id }, request);
        }

        // DELETE: api/Requests/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRequest(Guid id)
        {
            if (_context.Requests == null)
            {
                return NotFound();
            }
            var request = await _context.Requests.FindAsync(id);
            if (request == null)
            {
                return NotFound();
            }

            _context.Requests.Remove(request);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RequestExists(Guid id)
        {
            return (_context.Requests?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
