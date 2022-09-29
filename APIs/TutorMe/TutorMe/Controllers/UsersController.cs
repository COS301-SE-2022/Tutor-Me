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


        /// <summary> Get All the Users stored </summary>
        /// <returns> A list of users </returns>
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


        /// <summary> Get all the tutors </summary>
        /// <returns> A list of users </returns>
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
        /// <summary> Get all the tutees  </summary>
        /// <returns> A list of users</returns>
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

        /// <summary> Get all the admins </summary>
        /// <returns> A list of users </returns>
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

        /// <summary> Get a user by Id </summary>
        /// <param name="id"> User's Id </param>
        /// <returns> User object </returns>
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
        /// <summary> Store a new user </summary>
        /// <param name="user"> A user object </param>
        /// <returns>The User's generated Id</returns>
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

        /// <summary> Update a user's bio </summary>
        /// <param name="id"> User's Id </param>
        /// <param name="bio"> The new user's bio </param>
        /// <returns></returns>
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

        /// <summary> Verify a tutor after they upload their transcript </summary>
        /// <param name="id"> User's Id</param>
        /// <param name="isValidated"> User's verification </param>
        /// <returns> Returns a boolean </returns>
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

        /// <summary> Update the user's rating </summary>
        /// <param name="id"> User's Id </param>
        /// <param name="rating"> User's new rating </param>
        /// <param name="numberOfReviews"> User's new number of reviews </param>
        /// <returns> Returns a boolean </returns>
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

        /// <summary> Update the user object </summary>
        /// <param name="id"> User's Id </param>
        /// <param name="user"> The updated User object (check entities) </param>
        /// <returns> The updated user object </returns>
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

        /// <summary> Delete a user by their Id </summary>
        /// <param name="id"> User's Id </param>
        /// <returns> Returns a boolean </returns>
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