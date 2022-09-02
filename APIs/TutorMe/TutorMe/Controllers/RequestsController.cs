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
            try {
                var requests = requestService.GetAllRequests();
                return Ok(requests);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpGet("{id}")]
        public IActionResult GetRequestById(Guid id)
        {
            try {
                var request = requestService.GetRequestById(id);
                return Ok(request);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpPost]
        public IActionResult createRequest(Request request)
        {
            try {
                var requestId = requestService.createRequest(request);
                return Ok(requestId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteRequest(Guid id)
        {
            try {
                var request = requestService.deleteRequestById(id);
                return Ok(request);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpGet("tutor/{id}")]
        public IActionResult GetRequestByTutorById(Guid id)
        {
            try {
                var request = requestService.GetRequestByTutorById(id);
                return Ok(request);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpGet("tutee/{id}")]
        public IActionResult GetRequestByTuteeById(Guid id)
        {
            try {
                var request = requestService.GetRequestByTuteeById(id);
                return Ok(request);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpGet("accept/{id}")]
        public IActionResult AcceptRequestById(Guid id) {
            try {
                var request = requestService.AcceptRequestById(id);
                return Ok(request);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [HttpGet("reject/{id}")]
        public IActionResult RejectRequestById(Guid id) {
            try { 
                var request = requestService.RejectRequestById(id);
                return Ok(request);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }
    }
}