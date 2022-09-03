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
    public class TuteeFilesController : ControllerBase
    {
        private readonly FilesContext _context;

        public TuteeFilesController(FilesContext context)
        {
            _context = context;
        }

        // GET: api/TuteeFiles
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TuteeFile>>> GetTuteeFiles()
        {
            if (_context.TuteeFiles == null)
            {
                return NotFound();
            }
            return await _context.TuteeFiles.ToListAsync();
        }

        // GET: api/TuteeFiles/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TuteeFile>> GetTuteeFile(Guid id)
        {
            if (_context.TuteeFiles == null)
            {
                return NotFound();
            }
            var tuteeFile = await _context.TuteeFiles.FindAsync(id);

            if (tuteeFile == null)
            {
                return NotFound();
            }

            return tuteeFile;
        }

        // PUT: api/TuteeFiles/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTuteeFile(Guid id, TuteeFile tuteeFile)
        {
            if (id != tuteeFile.Id)
            {
                return BadRequest();
            }

            _context.Entry(tuteeFile).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TuteeFileExists(id))
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

        // POST: api/TuteeFiles
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TuteeFile>> PostTuteeFile(TuteeFile tuteeFile)
        {
            if (_context.TuteeFiles == null)
            {
                return Problem("Entity set 'FilesContext.TuteeFiles'  is null.");
            }
            _context.TuteeFiles.Add(tuteeFile);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (TuteeFileExists(tuteeFile.Id))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetTuteeFile", new { id = tuteeFile.Id }, tuteeFile);
        }

        // DELETE: api/TuteeFiles/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTuteeFile(Guid id)
        {
            if (_context.TuteeFiles == null)
            {
                return NotFound();
            }
            var tuteeFile = await _context.TuteeFiles.FindAsync(id);
            if (tuteeFile == null)
            {
                return NotFound();
            }

            _context.TuteeFiles.Remove(tuteeFile);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TuteeFileExists(Guid id)
        {
            return (_context.TuteeFiles?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
