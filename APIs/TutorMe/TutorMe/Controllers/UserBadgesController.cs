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

        /// <summary> Get user badge object's Id </summary>
        /// <param name="id">the badge's Id</param>
        /// <returns> a badge object</returns>
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

        /// <summary> Get user badge records by user id </summary>
        /// <param name="id"> User's Id </param>
        /// <returns> a list of userBadge objects</returns>
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

        /// <summary> Store a new UserBadge object</summary>
        /// <param name="userBadge"> The UserBadge object (check entities)</param>
        /// <returns> The UserBadge's Id </returns>
        // POST: api/UserBadges
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

        /// <summary> Delete a UserBadge by it's Id </summary>
        /// <param name="id"> UserBadge's Id </param>
        /// <returns> A boolean </returns>
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

        /// <summary> Update the points achieved for a badge </summary>
        /// <param name="id"> The Badges's Id</param>
        /// <param name="pointAchieved"> The Point achieved </param>
        /// <returns> A boolean </returns>
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
