using TutorMe.Models;
using TutorMe.Services;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Entities;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : ControllerBase {
        private IUserAuthenticationService userService;
        private IMapper mapper;
        private TutorMeContext _context;

        public AuthenticationController(IUserAuthenticationService userService, IMapper mapper)
        {
            this.userService = userService;
            this.mapper = mapper;
        }

        /// <summary>This method is used to login a user then return a user object </summary>
        /// <param name="userDetails">UserLogIn object (check entities)</param>
        /// <returns>returns user object</returns>
        [HttpPost("/login")]
        public IActionResult LogInUser(UserLogIn userDetails)
        {
            try
            {
                var user = userService.LogInUser(userDetails);
                return Ok(user);
            }
            catch (Exception e)
            {
                return Unauthorized(e.Message);
            }
        }

        /// <summary> This method is used to update the user email </summary>
        /// <param name="id">The user id</param>
        /// <param name="emailEntity">UserEmail object (check entities)</param>
        /// <returns>return user object</returns>
        [HttpPut("email/{id}")]
        public IActionResult UpdateEmailByUserId(Guid id, UserEmail emailEntity) {
            try {
                var user = userService.UpdateEmailByUserId(id, emailEntity);
                return Ok(user);
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }

        /// <summary> This method is used to update the user password </summary>
        /// <param name="id"> The user ID </param>
        /// <param name="passedObject">The IAuthPassword object (check entities)</param>
        /// <returns> The user object </returns>
        [HttpPut("password/{id}")]
        public IActionResult UpdatePassword(Guid id, IAuthPassword passedObject) {
            if (id != passedObject.UserId) {
                return BadRequest("Id's do not match");
            }
            try {
                var user = userService.UpdatePassword(id, passedObject);
                return Ok(user);
            }
            catch (Exception e) {
                return BadRequest(e.Message);
            }
        }
    }
}