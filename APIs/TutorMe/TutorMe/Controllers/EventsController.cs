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
            try 
                {
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

        [Authorize]
        [HttpPut("date/{id}")]
        public IActionResult UpdateEventDate(Guid id, string newDate) {
            try {
                eventService.UpdateEventDate(id, newDate);
                return Ok();
            }
            catch (Exception e) {
                return Conflict(e.Message);
            }
        }

        [Authorize]
        [HttpPut("time/{id}")]
        public IActionResult UpdateEventTime(Guid id, string newTime) {
            try {
                eventService.UpdateEventTime(id, newTime);
                return Ok();
            }
            catch (Exception e) {
                return Conflict(e.Message);
            }
        }

        [Authorize]
        [HttpPut("videoLink/{id}")]
        public IActionResult UpdateEventVideoLink(Guid id, string newVideoLink) {
            try {
                eventService.UpdateEventVideoLink(id, newVideoLink);
                return Ok();
            }
            catch (Exception e) {
                return Conflict(e.Message);
            }
        }

        [Authorize]
        [HttpPut("title/{id}")]
        public IActionResult UpdateEventTitle(Guid id, string newTitle) {
            try {
                eventService.UpdateEventTitle(id, newTitle);
                return Ok();
            }
            catch (Exception e) {
                return Conflict(e.Message);
            }
        }

        [Authorize]
        [HttpPut("description/{id}")]
        public IActionResult UpdateEventDescription(Guid id, string newDescription) {
            try {
                eventService.UpdateEventDescription(id, newDescription);
                return Ok();
            }
            catch (Exception e) {
                return Conflict(e.Message);
            }
        }
    }
}
