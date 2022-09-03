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
        Connection GetConnectionById(Guid id);
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
            return _context.Connection;
        }

        public Connection GetConnectionById(Guid id)
        {
            var connection = _context.Connection.Find(id);
            return connection;
        }

        public IEnumerable<Connection> GetConnectionsByUserId(Guid id) {
            var connections = _context.Connection.Where(e => e.TuteeId == id || e.TutorId == id);
            return connections;
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

        public bool deleteConnectionById(Guid id)
        {
            var connection = _context.Connection.Find(id);
            if (connection == null)
            {
                throw new KeyNotFoundException("Connection not found");
            }
            _context.Connection.Remove(connection);
            _context.SaveChanges();
            return true;
        }
    }
}