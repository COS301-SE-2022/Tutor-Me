using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IRequestService
    {
        IEnumerable<Request> GetAllRequests();
        Request GetRequestById(Guid id);
        Guid createRequest(Request request);
        bool deleteRequestById(Guid id);
        Request GetRequestByTutorById(Guid id);
        Request GetRequestByTuteeById(Guid id);
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
        public Request GetRequestByTutorById(Guid id)
        {
            var request= _context.Request.FirstOrDefault(e => e.TutorId == id);
            return request;
        }
        public Request GetRequestByTuteeById(Guid id)
        {
            var request = _context.Request.FirstOrDefault(e => e.TuteeId == id);
            return request;
        } 
        public Guid createRequest(Request request)
        {
            if (_context.Request.Where(e => e.ModuleId == request.ModuleId && e.TuteeId == request.TuteeId && e.TutorId == request.TutorId).Any())
            {
                throw new KeyNotFoundException("This Request already exists, Please log in");
            }
            request.RequestId = Guid.NewGuid();
            _context.Request.Add(request);
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