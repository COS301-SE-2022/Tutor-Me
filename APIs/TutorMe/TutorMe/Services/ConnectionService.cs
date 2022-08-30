using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IConnectionService
    {
        IEnumerable<Connection> GetAllConnections();
        IEnumerable<Connection> GetConnectionsByUserId(Guid id);
        Connection GetConnectionById(Guid id);
        Guid createConnection(Connection connection);
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
        public Guid createConnection(Connection connection)
        {
            if (_context.Connection.Where(e => e.ModuleId == connection.ModuleId && e.TuteeId == connection.TuteeId && e.TutorId == connection.TutorId).Any())
            {
                throw new KeyNotFoundException("This Connection already exists, Please log in");
            }
            //Connection.Password = BCrypt.Net.BCrypt.HashPassword(Connection.Password, "ThisWillBeAGoodPlatformForBothConnectionsAndTuteesToConnectOnADailyBa5e5");
            connection.ConnectionId = Guid.NewGuid();
            _context.Connection.Add(connection);
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