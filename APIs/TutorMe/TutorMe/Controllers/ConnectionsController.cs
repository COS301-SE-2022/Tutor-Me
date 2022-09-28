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
    public class ConnectionsController : ControllerBase
    {
        private IConnectionService connectionService;
        private IMapper mapper;
        private TutorMeContext _context;

        public ConnectionsController(IConnectionService connectionService, IMapper mapper)
        {
            this.connectionService = connectionService;
            this.mapper = mapper;
        }
        
        [Authorize]
        [HttpGet]
        public IActionResult GetAllConnections()
        {
            try {
                var connections = connectionService.GetAllConnections();
                return Ok(connections);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetConnectionById(Guid id)
        {
            try {
                var connection = connectionService.GetConnectionsByUserId(id);
                if (connection == null) {
                    return NotFound();
                }
                return Ok(connection);
            }
            catch (Exception exception) {
                if(exception.Message == "Connection not found") {
                    return NotFound();
                }
                return BadRequest(exception.Message);
            }
        }
        
        [Authorize]
        [HttpDelete("{id}")]
        public IActionResult DeleteConnection(Guid id)
        {
            try {
                var connection = connectionService.deleteConnectionById(id);
                return Ok(connection);
            }
            catch (Exception exception) {
                if(exception.Message == "Connection not found") {
                    return NotFound();
                }
                return BadRequest(exception.Message);
            }
        }
        
        [Authorize]
        [HttpGet("users/{id}")]
        public IActionResult GetUserConnectionObjectsById(Guid id, Guid userType) { 
            try {
                var connections = connectionService.GetUserConnectionObjectById(id, userType);
                return Ok(connections);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

    }
}