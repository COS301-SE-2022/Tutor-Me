using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Entities;
using Microsoft.AspNetCore.Authorization;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private IUserService userService;
        private IMapper mapper;
        private TutorMeContext _context;

        public UsersController(IUserService userService, IMapper mapper)
        {
            this.userService = userService;
            this.mapper = mapper;
        }

        [Authorize]
        [HttpGet]
        public IActionResult GetAllUsers()
        {
            try {
                var users = userService.GetAllUsers();
                return Ok(users);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("tutors")]
        public IActionResult GetAllTutors() {
            try {
                var users = userService.GetAllTutors();
                return Ok(users);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("tutees")]
        public IActionResult GetAllTutees() {
            try {
                var users = userService.GetAllTutees();
                return Ok(users);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("admins")]
        public IActionResult GetAllAdmins() {
            try {
                var users = userService.GetAllAdmins();
                return Ok(users);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetUserById(Guid id)
        {
            try {
                var user = userService.GetUserById(id);
                return Ok(user);
            }
            catch (Exception exception) {
                if(exception.Message == "User not found") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message);
            }
        }

        [HttpPost]
        public IActionResult RegisterUser(IUser user)
        {
            try {
                var userId = userService.RegisterUser(user);
                return Ok(userId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPut("bio/{id}")]
        public IActionResult UpdateBioByUserId(Guid id, string bio) {
            try {
                var user = userService.updateUserBio(id, bio);
                return Ok(user);
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }

        [Authorize]
        [HttpPut("validate/{id}")]
        public IActionResult ValidateUser(Guid id, bool isValidated) {
            try {
                var user = userService.updateValidated(id, isValidated);
                return Ok(user);
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }

        [Authorize]
        [HttpPut("rating/{id}")]
        public IActionResult UpdateRatingByUserId(Guid id, int rating, int numberOfReviews) {
            try {
                var user = userService.updateUserRating(id, rating, numberOfReviews);
                return Ok(user);
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }

        [Authorize]
        [HttpPut("{id}")]
        public IActionResult UpdateUser(Guid id, IUser user)
        {
            if (id != user.UserId)
            {
                return BadRequest();
            }
            try
            {
                var returnedUser = userService.UpdateUser(user);
                return Ok(returnedUser);
            }
            catch (Exception e)
            {
                return Conflict(e.Message);
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteUserById(Guid id) {
            try {
                userService.DeleteUserById(id);
                return Ok();
            }
            catch (Exception e) {
                return Conflict(e.Message);
            }
        }
    }
}