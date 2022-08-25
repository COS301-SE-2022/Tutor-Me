using TutorMe.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;

namespace TutorMe.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RequestsController : ControllerBase
    {
        private IRequestService requestService;
        private IMapper mapper;
        private TutorMeContext _context;

        public RequestsController(IRequestService requestService, IMapper mapper)
        {
            this.requestService = requestService;
            this.mapper = mapper;
        }

        [HttpGet]
        public IActionResult GetAllRequests()
        {
            var requests = requestService.GetAllRequests();
            return Ok(requests);
        }

        [HttpGet("{id}")]
        public IActionResult GetRequestById(Guid id)
        {
            var request = requestService.GetRequestById(id);
            return Ok(request);
        }

        [HttpPost]
        public IActionResult createRequest(Request request)
        {
            var requestId = requestService.createRequest(request);
            return Ok(requestId);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteRequest(Guid id)
        {
            var request = requestService.deleteRequestById(id);
            return Ok(request);
        }

        [HttpGet("tutor/{id}")]
        public IActionResult GetRequestByTutorById(Guid id)
        {
            var request = requestService.GetRequestByTutorById(id);
            return Ok(request);
        }

        [HttpGet("tutee/{id}")]
        public IActionResult GetRequestByTuteeById(Guid id)
        {
            var request = requestService.GetRequestByTuteeById(id);
            return Ok(request);
        }

        [HttpGet("accept/{id}")]
        public IActionResult AcceptRequestById(Guid id) {
            var request = requestService.AcceptRequestById(id);
            return Ok(request);
        }

        [HttpGet("reject/{id}")]
        public IActionResult RejectRequestById(Guid id) {
            var request = requestService.RejectRequestById(id);
            return Ok(request);
        }
    }
}