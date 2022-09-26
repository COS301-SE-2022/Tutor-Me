using FileSystem.Data;
using FileSystem.Entities;
using FileSystem.Models;
using FileSystem.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FileSystem.Controllers {
    [Route("api/[controller]")]
    [ApiController]
    public class UserFilesController : ControllerBase {
        private readonly FilesContext _context;
        private IUserFilesService userFilesService;

        public UserFilesController(FilesContext context, IUserFilesService userFilesService ) {
            _context = context;
            this.userFilesService = userFilesService;
        }


        // GET: api/UserFiles/5
        [HttpGet("image/{id}")]
        public async Task<IActionResult> GetImageByUserId(Guid id, string username, string password, Guid typeId) 
            {
            UserAuth userAuth = new UserAuth();
            userAuth.Email = username;
            userAuth.Password = password;
            userAuth.TypeId = typeId;
            if (_context.UserFiles == null) {
                return NotFound();
            }
            try {
                
                var connection = userFilesService.GetImageByUserId(id, userAuth);
                return Ok(connection);
            }
            catch (Exception e) {
                if (e.Message == "Unauthorized") {
                    return Unauthorized();
                }
                return BadRequest(e.Message);
            }

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
        public IActionResult createUserRecord(IUserFiles userFiles) {
            this.userFilesService.createUserRecord(userFiles);
            return Ok();
        }

        [HttpPut("image/{id}")]
        public IActionResult ModifyUserImage(Guid id, UserFiles userFiles) {
            if (id != userFiles.Id) {
                return BadRequest("Invalid request sent");
            }
            try {
                this.userFilesService.ModifyUserImage(userFiles);
                return Ok();
            }
            catch (Exception exception) {
                return NotFound(exception.Message);
            }
        }

        [HttpPut("transcript/{id}")]
        public IActionResult ModifyUserTranscript(Guid id,UserFiles userFiles) {
            if (id != userFiles.Id || userFiles == null) {
                return BadRequest("Invalid request sent");
            }
            try {
                this.userFilesService.ModifyUserTranscript(userFiles);
                return Ok();
            }
            catch (Exception exception) {
                return NotFound(exception.Message);
            }
        }

        // DELETE: api/UserFiles/5
        [HttpDelete("{id}")]
        public IActionResult DeleteUserFiles(Guid id) {
            if (_context.UserFiles == null) {
                return NotFound();
            }

            try {
                var response = userFilesService.DeleteUserFilesById(id);
                return Ok(response);
            }
            catch (Exception e) {
                return BadRequest(e);
            }
        }
    }
}