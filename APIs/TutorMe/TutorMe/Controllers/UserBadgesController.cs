using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;
using TutorMe.Services;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserBadgesController : ControllerBase
    {
        private readonly TutorMeContext _context;
        private IUserBadgeService UserBadgeService;

        public UserBadgesController(TutorMeContext context, IUserBadgeService UserBadgeService) {
            _context = context;
            this.UserBadgeService = UserBadgeService;
        }

        // GET: api/UserBadges
        [HttpGet]
        public IActionResult GetUserBadgeById(Guid id)
        {
            try {
                var userBadge = UserBadgeService.GetUserBadgeById(id);
                return Ok(userBadge);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        // GET: api/UserBadges/5
        [HttpGet("user/{id}")]
        public IActionResult GetUsersBadgesByUserId(Guid id)
        {
            try {
                var userBadges = UserBadgeService.GetUsersBadgesByUserId(id);
                return Ok(userBadges);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        // POST: api/UserBadges
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public IActionResult createUserBadge(IUserBadge userBadge)
        {
            try {
                var userBadgeId = UserBadgeService.createUserBadge(userBadge);
                return Ok(userBadgeId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        // DELETE: api/UserBadges/5
        [HttpDelete("{id}")]
        public IActionResult DeleteUserBadgeById(Guid id)
        {
            try {
                var userBadgeId = UserBadgeService.deleteUserBadgeById(id);
                return Ok(userBadgeId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpPut("{id}")]
        public IActionResult updatePointAchieved(Guid id, int pointAchieved) {
            try {
                var userBadgeId = UserBadgeService.updatePointAchieved(id, pointAchieved);
                return Ok(userBadgeId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}
