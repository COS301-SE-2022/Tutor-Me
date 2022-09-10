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