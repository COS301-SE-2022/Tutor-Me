using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using TutorMe.Entities;

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

        [HttpGet("{id}")]
        public IActionResult GetUserById(Guid id)
        {
            try {
                var user = userService.GetUserById(id);
                return Ok(user);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpPost]
        public IActionResult RegisterUser(User user)
        {
            try {
                var userId = userService.RegisterUser(user);
                return Ok(userId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
        
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

        
        [HttpPut("{id}")]
        public IActionResult UpdateUser(Guid id, User user)
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

        
    }
}