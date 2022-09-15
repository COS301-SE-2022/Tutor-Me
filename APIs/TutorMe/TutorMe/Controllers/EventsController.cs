using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
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
    public class EventsController : ControllerBase
    {
        private readonly TutorMeContext _context;
        private IEventService eventService;

        public EventsController(TutorMeContext context, IEventService eventService)
        {
            _context = context;
            this.eventService = eventService;
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetAllUserEvent(Guid id) {
            try {
                var UserEvents = eventService.GetUserEvents(id);
                return Ok(UserEvents);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPost]
        public IActionResult CreateUserEvent(IEvent newEvent) {
            try {
                var userId = eventService.CreateUserEvent(newEvent);
                return Ok(userId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteEventById(Guid id) {
            try {
                eventService.DeleteUserEvent(id);
                return Ok();
            }
            catch (Exception e) {
                return Conflict(e.Message);
            }
        }
    }
}
