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
        public async Task<IActionResult> GetImageByUserId(Guid id, string username, string password, Guid typeId) {
            UserAuth userAuth = new UserAuth();
            userAuth.Email = username;
            userAuth.Password = password;
            userAuth.TypeId = typeId;
            if (_context.UserFiles == null) {
                return NotFound();
            }
            try {
                if (await userFilesService.checkIfAuthorized(userAuth)) {
                    var record = await userFilesService.GetImageByUserId(id);
                    if (record == null) {
                        return NotFound();
                    }
                    return Ok(record);
                }
                else {
                    return Unauthorized();
                }
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }

        }

        [HttpGet("transcript/{id}")]
        public async Task<IActionResult> GetTranscriptByUserId(Guid id, string username, string password, Guid typeId) {
            UserAuth userAuth = new UserAuth();
            userAuth.Email = username;
            userAuth.Password = password;
            userAuth.TypeId = typeId;
            if (_context.UserFiles == null) {
                return NotFound();
            }
            try {
                if(await userFilesService.checkIfAuthorized(userAuth)) {
                    var record = await userFilesService.GetTranscriptByUserId(id);
                    if (record == null) {
                        return NotFound();
                    }
                    return Ok(record);
                }
                else {
                    return Unauthorized();
                }
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }

        // PUT: api/UserFiles/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<IActionResult> createUserRecord(IUserFiles userFiles, string username, string password, Guid typeId) {
            try {
                UserAuth userAuth = new UserAuth();
                userAuth.Email = username;
                userAuth.Password = password;
                userAuth.TypeId = typeId;
                if (await userFilesService.checkIfAuthorized(userAuth)) {
                    userFilesService.createUserRecord(userFiles);
                    return Ok();
                }
                else {
                    return Unauthorized();
                }
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }

        [HttpPut("image/{id}")]
        public async Task<IActionResult> ModifyUserImage(Guid id, UserFiles userFiles, string username, string password, Guid typeId) {
            if (id != userFiles.Id) {
                return BadRequest("Invalid request sent");
            }
            try {
                UserAuth userAuth = new UserAuth();
                userAuth.Email = username;
                userAuth.Password = password;
                userAuth.TypeId = typeId;
                if (await userFilesService.checkIfAuthorized(userAuth)) {
                    userFilesService.ModifyUserImage(userFiles);
                    return Ok();
                }
                else {
                    return Unauthorized();
                }
            }
            catch (Exception exception) {
                return NotFound(exception.Message);
            }
        }

        [HttpPut("transcript/{id}")]
        public async Task<IActionResult> ModifyUserTranscript(Guid id,UserFiles userFiles, string username, string password, Guid typeId) {
            if (id != userFiles.Id || userFiles == null) {
                return BadRequest("Invalid request sent");
            }
            try {
                UserAuth userAuth = new UserAuth();
                userAuth.Email = username;
                userAuth.Password = password;
                userAuth.TypeId = typeId;
                if (await userFilesService.checkIfAuthorized(userAuth)) {
                    userFilesService.ModifyUserTranscript(userFiles);
                    return Ok();
                }
                else {
                    return Unauthorized();
                }
            }
            catch (Exception exception) {
                return NotFound(exception.Message);
            }
        }

        // DELETE: api/UserFiles/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUserFiles(Guid id, string username, string password, Guid typeId) {
            if (_context.UserFiles == null) {
                return NotFound();
            }
            try {
                UserAuth userAuth = new UserAuth();
                userAuth.Email = username;
                userAuth.Password = password;
                userAuth.TypeId = typeId;
                if (await userFilesService.checkIfAuthorized(userAuth)) {
                    var response = userFilesService.DeleteUserFilesById(id);
                    return Ok(response);
                }
                else {
                    return Unauthorized();
                }
            }
            catch (Exception e) {
                return BadRequest(e);
            }
        }
    }
}