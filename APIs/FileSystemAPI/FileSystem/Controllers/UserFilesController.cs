using FileSystem.Data;
using FileSystem.Models;
using FileSystem.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FileSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserFilesController : ControllerBase
    {
        private readonly FilesContext _context;
        private UserFilesService userFilesService;

        public UserFilesController(FilesContext context)
        {
            _context = context;
            userFilesService = new UserFilesService(_context);
        }


        // GET: api/UserFiles/5
        [HttpGet("image/{id}")]
        public IActionResult GetImageByUserId(Guid id){
              if (_context.UserFiles == null)
              {
                  return NotFound();
              }
            var connection = userFilesService.GetImageByUserId(id);
            return Ok(connection);
        }

        [HttpGet("transcript/{id}")]
        public IActionResult GetTranscriptByUserId(Guid id) {
            if (_context.UserFiles == null) {
                return NotFound();
            }
            var connection = userFilesService.GetTranscriptByUserId(id);
            return Ok(connection);
        }

        // PUT: api/UserFiles/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<IActionResult> createUserRecord( UserFiles userFiles)
        {
            this.userFilesService.createUserRecord(userFiles);
            return Ok();
        }

        [HttpPut("{id}")]
        public IActionResult ModifyUserFiles(Guid id, UserFiles userFiles) { 
            if (id != userFiles.Id || userFiles == null) { 
                return BadRequest("Invalid request sent");
            }
            try {
                this.userFilesService.ModifyUserFiles(userFiles);
                return Ok();
            }
            catch(Exception exception) {
                return NotFound(exception.Message);
            }
        }
        
        // DELETE: api/UserFiles/5
        [HttpDelete("{id}")]
        public IActionResult DeleteUserFiles(Guid id)
        {
            if (_context.UserFiles == null)
            {
                return NotFound();
            }

            try {
                var response = userFilesService.DeleteUserFilesById(id);
                return Ok(response);
            }
            catch(Exception e) {
                return BadRequest(e);
            }
        }
    }
}
