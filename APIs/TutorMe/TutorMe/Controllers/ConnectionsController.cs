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
        
        /// <summary> Gets all the connection in the database </summary>
        /// <returns>A list of connections</returns>
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

        /// <summary> Returns one conection by their id </summary>
        /// <param name="id"> The connections's ID</param>
        /// <returns>returns a connection</returns>
        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetConnectionById(Guid id)
        {
            try {
                var connection = connectionService.GetConnectionsByUserId(id);
                if (connection == null) {
                    return NotFound("Connection not found");
                }
                return Ok(connection);
            }
            catch (Exception exception) {
                if(exception.Message == "No connections found for user") {
                    return NotFound();
                }
                return BadRequest(exception.Message);
            }
        }
        
        /// <summary> Deletes a user connecion by the connection id </summary>
        /// <param name="id"> The connection id </param>
        /// <returns>return a boolean</returns>
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
        
        /// <summary> Returns a list of users connected to the specified user </summary>
        /// <param name="id"> The user's id </param>
        /// <param name="userType"> The usertype id of the user </param>
        /// <returns>a list of users</returns>
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