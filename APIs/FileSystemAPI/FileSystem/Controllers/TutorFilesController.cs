using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FileSystem.Data;
using FileSystem.Models;

namespace FileSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TutorFilesController : ControllerBase
    {
        private readonly FilesContext _context;

        public TutorFilesController(FilesContext context)
        {
            _context = context;
        }

        // GET: api/TutorFiles
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TutorFile>>> GetTutorFiles()
        {
            if (_context.TutorFiles == null)
            {
                return NotFound();
            }
            return await _context.TutorFiles.ToListAsync();
        }

        // GET: api/TutorFiles/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TutorFile>> GetTutorFile(Guid id)
        {
            if (_context.TutorFiles == null)
            {
                return NotFound();
            }
            var tutorFile = await _context.TutorFiles.FindAsync(id);

            if (tutorFile == null)
            {
                return NotFound();
            }

            return tutorFile;
        }

        // PUT: api/TutorFiles/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTutorFile(Guid id, TutorFile tutorFile)
        {
            if (id != tutorFile.Id)
            {
                return BadRequest();
            }

            _context.Entry(tutorFile).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TutorFileExists(id))
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

        // POST: api/TutorFiles
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TutorFile>> PostTutorFile(TutorFile tutorFile)
        {
            if (_context.TutorFiles == null)
            {
                return Problem("Entity set 'FilesContext.TutorFiles'  is null.");
            }
            _context.TutorFiles.Add(tutorFile);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (TutorFileExists(tutorFile.Id))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetTutorFile", new { id = tutorFile.Id }, tutorFile);
        }

        // DELETE: api/TutorFiles/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTutorFile(Guid id)
        {
            if (_context.TutorFiles == null)
            {
                return NotFound();
            }
            var tutorFile = await _context.TutorFiles.FindAsync(id);
            if (tutorFile == null)
            {
                return NotFound();
            }

            _context.TutorFiles.Remove(tutorFile);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TutorFileExists(Guid id)
        {
            return (_context.TutorFiles?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
