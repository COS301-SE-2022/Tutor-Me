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

        /// <summary> Get all requests </summary>
        /// <returns> A list of request </returns>
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

        /// <summary> Get request by it's Id </summary>
        /// <param name="id"> The request's Id </param>
        /// <returns> a request object </returns>
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

        /// <summary> Store a new request </summary>
        /// <param name="request"> The request object (check entities)</param>
        /// <returns> The request's Id </returns>
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

        /// <summary> Delete a request by it's Id </summary>
        /// <param name="id"> The request's Id </param>
        /// <returns> A boolean </returns>
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

        /// <summary> Get Tutor's requests </summary>
        /// <param name="id"> The user(Tutor)'s Id</param>
        /// <returns> a lit of requests </returns>
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

        /// <summary> Get Tutee's requests </summary>
        /// <param name="id">The user(Tutee)'s Id</param>
        /// <returns> A list of requests</returns>
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

        /// <summary> A Tutor to accept a tutees's request and make a connection </summary>
        /// <param name="id"> The request's Id </param>
        /// <returns> A boolean </returns>
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

        /// <summary> Reject a tutor's request </summary>
        /// <param name="id"> The requwst's Id</param>
        /// <returns> A boolean </returns>
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