using TutorMe.Models;
using TutorMe.Entities;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using TutorMe.Data;
using TutorMe.Services;
using Microsoft.AspNetCore.Authorization;

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

        [Authorize]
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

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetRequestById(Guid id)
        {
            try {
                var request = requestService.GetRequestById(id);
                return Ok(request);
            }
            catch (Exception exception) {
                if(exception.Message == "Request not found") {
                    return NotFound(exception.Message);
                }
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
        [HttpPost]
        public IActionResult createRequest(IRequest request)
        {
            try {
                var requestId = requestService.createRequest(request);
                return Ok(requestId);
            }
            catch (Exception exception) {
                return BadRequest(exception.Message);
            }
        }

        [Authorize]
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

        [Authorize]
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

        [Authorize]
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

        [Authorize]
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

        [Authorize]
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