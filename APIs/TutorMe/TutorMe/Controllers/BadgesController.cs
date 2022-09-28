using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;
using TutorMe.Services;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BadgesController : ControllerBase
    {
        private readonly TutorMeContext _context;
        private IBadgeService _badgeService;

        public BadgesController(TutorMeContext context, IBadgeService badgeService) {
            _context = context;
            _badgeService = badgeService;
        }

        /// <summary> This method is used to get all badges from the database </summary>
        /// <param>None</param>
        // GET:api/Badges
        [HttpGet]
        public IActionResult GetAllBadges()
        {
            try {
                    var badges =  _badgeService.GetAllBadges();
                    return Ok(badges);
            }
            catch (Exception ex) {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// This method is used to get a badge by its id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        // GET: api/Badges/5
        [HttpGet("{id}")]
        public IActionResult GetBadgeById(Guid id)
        {
            try {
                var badge = _badgeService.GetBadgeById(id);
                return Ok(badge);
            }
            catch (Exception ex)
            {   if(ex.Message == "Badge not found")
                    return NotFound();
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// This method is used to create a badge
        /// </summary>
        /// <param name="badge">badge object to be added</param>
        /// <returns>Badge ID</returns>
        // POST: api/Badges
        [Authorize]
        [HttpPost]
        public IActionResult PostBadge(Badge badge)
        {
            try {
                var badgeId = _badgeService.createBadge(badge);
                return Ok(badgeId);
            }
            catch (Exception ex) {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>Delete a badge using the badgeId </summary>
        /// <param name="id">The badge ID</param>
        /// <returns></returns>
        // DELETE: api/Badges/5
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBadge(Guid id)
        {
            try { 
                var badge = _badgeService.deleteBadgeById(id);
                return Ok(badge);
            }
            catch (Exception ex) {
                if(ex.Message == "Badge not found")
                    return NotFound();
                return BadRequest(ex.Message);
            }
        }

        /// <summary> Update the points for a badge </summary>
        /// <param name="id">the id for the badge</param>
        /// <param name="points">the new point for the badge</param>
        /// <returns></returns>
        // PUT: api/Badges/5
        [Authorize]
        [HttpPut("{id}/points")]
        public IActionResult updateBadgePoints(Guid id, int points) {
            try {
                var badge = _badgeService.updateBadgePoints(id, points);
                return Ok(badge);
            }
            catch (Exception ex) {
                if(ex.Message == "Badge not found")
                    return NotFound();
                return BadRequest(ex.Message);
            }
        }

        /// <summary> Updates the point to achieve for the badge </summary>
        /// <param name="id">The badge ID</param>
        /// <param name="pointsToAchieve">The new point to achieve the badge</param>
        /// <returns></returns>
        // PUT: api/pointsToAchieve/5
        [Authorize]
        [HttpPut("{id}/pointsToAchieve")]
        public IActionResult updateBadgePointsToAchieve(Guid id, int pointsToAchieve) {
            try {
                var badge = _badgeService.updateBadgePointsToAchieve(id, pointsToAchieve);
                return Ok(badge);
            }
            catch (Exception ex) {
                if(ex.Message == "Badge not found")
                    return NotFound();
                return BadRequest(ex.Message);
            }
        }

        /// <summary> Update the name of the badge </summary>
        /// <param name="id">The badge ID</param>
        /// <param name="name">The new badge name</param>
        /// <returns></returns>
        // PUT: api/name/5
        [Authorize]
        [HttpPut("{id}/name")]
        public IActionResult updateBadgeName(Guid id, string name) {
            try {
                var badge = _badgeService.updateBadgeName(id, name);
                return Ok(badge);
            }
            catch (Exception ex) {
                if(ex.Message == "Badge not found")
                    return NotFound();
                return BadRequest(ex.Message);
            }
        }

        /// <summary> Updates the description for the badge </summary>
        /// <param name="id">The badge id</param>
        /// <param name="description"> The new description for the badge</param>
        /// <returns></returns>
        // PUT: api/description/5
        [Authorize]
        [HttpPut("{id}/description")]
        public IActionResult updateBadgeDescription(Guid id, string description) {
            try {
                var badge = _badgeService.updateBadgeDescription(id, description);
                return Ok(badge);
            }
            catch (Exception ex) {
                if(ex.Message == "Badge not found")
                    return NotFound();
                return BadRequest(ex.Message);
            }
        }

        /// <summary> Updates the location of the badge </summary>
        /// <param name="id"> The badge ID</param>
        /// <param name="image">The new badge image path</param>
        /// <returns></returns>
        // PUT: api/image/5
        [Authorize]
        [HttpPut("{id}/image")]
        public IActionResult updateBadgeImage(Guid id, string image) {
            try {
                var badge = _badgeService.updateBadgeImage(id, image);
                return Ok(badge);
            }
            catch (Exception ex) {
                if(ex.Message == "Badge not found")
                    return NotFound();
                return BadRequest(ex.Message);
            }
        }
    }
}
