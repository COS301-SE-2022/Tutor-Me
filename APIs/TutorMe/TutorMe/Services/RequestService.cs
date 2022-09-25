using TutorMe.Data;
using TutorMe.Models;
using TutorMe.Entities;

namespace TutorMe.Services
{
    public interface IRequestService
    {
        IEnumerable<Request> GetAllRequests();
        Request GetRequestById(Guid id);
        Guid createRequest(IRequest request);
        bool deleteRequestById(Guid id);
        IEnumerable<Request> GetRequestByTutorById(Guid id);
        IEnumerable<Request> GetRequestByTuteeById(Guid id);
        bool AcceptRequestById(Guid id);
        bool RejectRequestById(Guid id);
    }
    public class RequestServices : IRequestService
    {

        private TutorMeContext _context;
        public RequestServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<Request> GetAllRequests()
        {
            return _context.Request.ToList();
        }

        public Request GetRequestById(Guid id)
        {
            var request = _context.Request.Find(id);
            if (request == null)
            {
                throw new KeyNotFoundException("Request not found");
            }
            return request;
        }
        public IEnumerable<Request> GetRequestByTutorById(Guid id)
        {
            var request = _context.Request.Where(e => e.TutorId == id).ToList();
            return request;
        }
        public IEnumerable<Request> GetRequestByTuteeById(Guid id)
        {
            var request = _context.Request.Where(e => e.TuteeId == id).ToList();
            return request;
        } 
        public Guid createRequest(IRequest request)
        {
            if (_context.Request.Where(e => e.ModuleId == request.ModuleId && e.TuteeId == request.TuteeId && e.TutorId == request.TutorId).Any())
            {
                throw new KeyNotFoundException("This Request already exists, Please log in");
            }
            var newRequest = new Request();
            newRequest.RequestId = Guid.NewGuid();
            newRequest.TuteeId = request.TuteeId;
            newRequest.TutorId = request.TutorId;
            newRequest.ModuleId = request.ModuleId;
            newRequest.DateCreated = DateTime.Now.ToString();
            _context.Request.Add(newRequest);
            _context.SaveChanges();
            return request.RequestId;
        }

        public bool deleteRequestById(Guid id) {
            var request = _context.Request.Find(id);
            if (request == null)
            {
                throw new KeyNotFoundException("Request not found");
            }
            _context.Request.Remove(request);
            _context.SaveChanges();
            return true;
        }

        public bool AcceptRequestById(Guid id){
            var request = _context.Request.Find(id);
            if (request == null)
            {
                throw new KeyNotFoundException("Request not found");
            }
            Connection connection = new Connection();
            connection.ConnectionId = Guid.NewGuid();
            connection.ModuleId = request.ModuleId;
            connection.TuteeId = request.TuteeId;
            connection.TutorId = request.TutorId;
            _context.Connection.Add(connection);
            _context.Request.Remove(request);
            _context.SaveChanges();
            return true;
        }

        public bool RejectRequestById(Guid id) {
            var request = _context.Request.Find(id);
            if (request == null) {
                throw new KeyNotFoundException("Request record not found");
            }
            _context.Request.Remove(request);
            _context.SaveChanges();
            return true;
        }
    }
}