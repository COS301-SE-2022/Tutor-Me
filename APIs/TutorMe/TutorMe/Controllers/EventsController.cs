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

        /// <summary> This method is used to get all the user's events from the database </summary>
        /// <param name="id"> The user's ID </param>
        /// <returns> All the user's events </returns>
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

        /// <summary> Store a new user event </summary>
        /// <param name="newEvent"> The event object</param>
        /// <returns>Returns a boolean</returns>
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

        /// <summary> Deletes an event </summary>
        /// <param name="id"> The event's ID </param>
        /// <returns> returns a boolean</returns>
        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteEventById(Guid id) {
            try {
                eventService.DeleteUserEvent(id);
                return Ok();
            }
            catch (Exception e) {
                if(e.Message == "Event not found") {
                    return NotFound();
                }
                return Conflict(e.Message);
            }
        }

        /// <summary> Updates the date for the event </summary>
        /// <param name="id">The event's ID</param>
        /// <param name="newDate"> The new event date</param>
        /// <returns>return a boolean</returns>
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

        /// <summary> Updates the time for the event </summary>
        /// <param name="id">The event's ID</param>
        /// <param name="newTime"> The new event time</param>
        /// <returns></returns>
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

        /// <summary> Updates the event's meeting link </summary>
        /// <param name="id"> The event's Id</param>
        /// <param name="newVideoLink"> The meeting link</param>
        /// <returns> returns a boolean </returns>
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

        /// <summary> Updates the event's title </summary>
        /// <param name="id"> The event's Id</param>
        /// <param name="newTitle"> The new event's title </param>
        /// <returns></returns>
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

        /// <summary> Updates the event's description </summary>
        /// <param name="id"> The event's Id</param>
        /// <param name="newDescription"> The new event's description </param>
        /// <returns></returns>
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
