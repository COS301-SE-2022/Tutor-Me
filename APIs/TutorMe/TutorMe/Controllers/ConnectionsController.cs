using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;

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

        [HttpGet]
        public IActionResult GetAllConnections()
        {
            var connections = connectionService.GetAllConnections();
            return Ok(connections);
        }

        [HttpGet("{id}")]
        public IActionResult GetConnectionById(Guid id)
        {
            var connection = connectionService.GetConnectionById(id);
            return Ok(connection);
        }

        [HttpPost]
        public IActionResult createConnection(Connection connection)
        {
            var connectionId = connectionService.createConnection(connection);
            return Ok(connectionId);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteConnection(Guid id)
        {
            var connection = connectionService.deleteConnectionById(id);
            return Ok(connection);
        }
    }
}