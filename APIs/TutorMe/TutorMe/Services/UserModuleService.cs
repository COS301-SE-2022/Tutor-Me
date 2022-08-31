using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;

namespace TutorMe.Services {

    public interface IUserModuleService {
        IEnumerable<UserModule> GetAllUserModules();
        //TODO: Fix this function
        IEnumerable<Module> GetUserModulesByUserId(Guid id);
        UserModule GetUserModuleById(Guid id);
        Guid createUserModule(IUserModule userModule);
        bool deleteUserModuleById(Guid id);
    }
    public class UserModuleServices: IUserModuleService {
        private TutorMeContext _context;
        public UserModuleServices(TutorMeContext context) {
            _context = context;
        }

        public IEnumerable<UserModule> GetAllUserModules() {
            return _context.UserModule;
        }

        public UserModule GetUserModuleById(Guid id) {
            var userModule = _context.UserModule.Find(id);
            if (userModule == null) {
                throw new KeyNotFoundException("UserModule not found");
            }
            return userModule;
        }
        public Guid createUserModule(IUserModule userModuleInput) {
            if (_context.UserModule.Where(e => e.UserId == userModuleInput.UserId && e.ModuleId == userModuleInput.ModuleId).Any()) {
                throw new KeyNotFoundException("This UserModule already exists");
            }
            var userModule = new UserModule();
            userModule.UserModuleId = Guid.NewGuid();
            userModule.UserId = userModuleInput.UserId;
            userModule.ModuleId = userModuleInput.ModuleId;
            _context.UserModule.Add(userModule);
            _context.SaveChanges();
            return userModule.UserModuleId;
        }

        public IEnumerable<Module> GetUserModulesByUserId(Guid id) {
            var userModules = _context.UserModule.Include(e=>e.Module).Where(e => e.UserId == id);
            if(userModules == null) {
                throw new KeyNotFoundException("User Module Record not found.");
            }
            var modules = new List<Module>();
            foreach (UserModule item in userModules) {
                modules.Add(item.Module);
            }
            return modules;
        }

        public bool deleteUserModuleById(Guid id) {
            var userModule = _context.UserModule.Find(id);
            if (userModule == null) {
                throw new KeyNotFoundException("UserModule not found");
            }
            _context.Connection.Where(e => e.ModuleId == userModule.ModuleId).ToList().ForEach(e => _context.Connection.Remove(e));
            _context.GroupMember.Where(e => e.Group.ModuleId == userModule.ModuleId).ToList().ForEach(e => _context.GroupMember.Remove(e));
            _context.UserModule.Remove(userModule);
            _context.SaveChanges();
            return true;
        }
    }
}
