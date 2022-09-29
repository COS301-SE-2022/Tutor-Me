using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IConnectionService
    {
        IEnumerable<Connection> GetAllConnections();
        IEnumerable<Connection> GetConnectionsByUserId(Guid id);
        IEnumerable<User> GetUserConnectionObjectById(Guid id, Guid userType);
        // Connection GetConnectionById(Guid id);
        Guid createConnection(IConnection connection);
        bool deleteConnectionById(Guid id);
    }
    public class ConnectionServices : IConnectionService
    {

        private TutorMeContext _context;
        public ConnectionServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<Connection> GetAllConnections()
        {
            return _context.Connection.ToList();
        }

        // public Connection GetConnectionById(Guid id)
        // {
        //     var connection = _context.Connection.Find(id);
        //     return connection;
        // }

        public IEnumerable<Connection> GetConnectionsByUserId(Guid id) {
            var connections = _context.Connection.Where(e => e.TuteeId == id || e.TutorId == id);
            if (connections == null)
            {
                throw new KeyNotFoundException("No connections found for user");
            }
            return connections.ToList();
        }
        public Guid createConnection(IConnection connection)
        {
            if (_context.Connection.Where(e => e.ModuleId == connection.ModuleId && e.TuteeId == connection.TuteeId && e.TutorId == connection.TutorId).Any())
            {
                throw new KeyNotFoundException("This Connection already exists, Please log in");
            }
            var newConnection = new Connection();
            newConnection.ConnectionId = Guid.NewGuid();
            newConnection.ModuleId = connection.ModuleId;
            newConnection.TuteeId = connection.TuteeId;
            newConnection.TutorId = connection.TutorId;
            _context.Connection.Add(newConnection);
            _context.SaveChanges();
            return connection.ConnectionId;
        }

        public bool deleteConnectionById(Guid id){
            var connection = _context.Connection.Find(id);
            if (connection == null)
            {
                throw new KeyNotFoundException("Connection not found");
            }
            _context.Connection.Remove(connection);
            _context.SaveChanges();
            return true;
        }

        public IEnumerable<User> GetUserConnectionObjectById(Guid id, Guid userType) {
            var userTypeObject = _context.UserType.FirstOrDefault(e => e.UserTypeId == userType);
            if (userTypeObject == null) {
                throw new KeyNotFoundException("User Type not found");
            }
            
            if (userTypeObject.Type == "Tutor") {
                var connections = _context.Connection.Include(e=>e.Tutee).Where(e => e.TutorId == id).ToList();
                var users = connections.Select(e => e.Tutee);
                //get unique users
                var uniqueUser = new List<User>();
                foreach(User item in users) {
                    if (!uniqueUser.Contains(item)) {
                        uniqueUser.Add(item);
                    }
                }
                return uniqueUser;
            }
            else if (userTypeObject.Type == "Tutee") {
                var connections = _context.Connection.Include(e => e.Tutor).Where(e => e.TuteeId == id).ToList();
                var users = connections.Select(e => e.Tutor);
                var uniqueUser = new List<User>();
                foreach (User item in users) {
                    if (!uniqueUser.Contains(item)) {
                        uniqueUser.Add(item);
                    }
                }
                return uniqueUser;
            }
            else {
                throw new KeyNotFoundException("User Type not found");

            }
        }

    }
}