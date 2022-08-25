﻿using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services {

    public interface IUserModuleService {
        IEnumerable<UserModule> GetAllUserModules();
        UserModule GetUserModuleById(Guid id);
        Guid createUserModule(UserModule userModule);
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
        public Guid createUserModule(UserModule userModule) {
            if (_context.UserModule.Where(e => e.UserId == userModule.UserId && e.ModuleId == userModule.ModuleId).Any()) {
                throw new KeyNotFoundException("This UserModule already exists");
            }
            userModule.UserModuleId = Guid.NewGuid();
            _context.UserModule.Add(userModule);
            _context.SaveChanges();
            return userModule.UserModuleId;
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