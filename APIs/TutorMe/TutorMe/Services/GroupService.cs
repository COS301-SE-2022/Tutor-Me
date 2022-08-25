using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IGroupService
    {
        IEnumerable<Group> GetAllGroups();
        Group GetGroupById(Guid id);
        Guid createGroup(Group group);
        bool deleteGroupById(Guid id);
    }
    public class GroupServices : IGroupService
    {

        private TutorMeContext _context;
        public GroupServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<Group> GetAllGroups()
        {
            return _context.Group;
        }

        public Group GetGroupById(Guid id)
        {
            var group = _context.Group.Find(id);
            if (group == null)
            {
                throw new KeyNotFoundException("Group not found");
            }
            return group;
        }
        public Guid createGroup(Group group)
        {
            //TODO: will allow multiple instances of groups till I plan and see if the owner field willl work
            //if (_context.Group.Where(e => e.ModuleId == group.ModuleId && e.TuteeId == group.TuteeId && e.TutorId == group.TutorId).Any())
            //{
            //    throw new KeyNotFoundException("This Group already exists, Please log in");
            //}
            //Group.Password = BCrypt.Net.BCrypt.HashPassword(Group.Password, "ThisWillBeAGoodPlatformForBothGroupsAndTuteesToConnectOnADailyBa5e5");
            group.GroupId = Guid.NewGuid();
            _context.Group.Add(group);
            _context.SaveChanges();
            return group.GroupId;
        }

        public bool deleteGroupById(Guid id)
        {
            var group = _context.Group.Find(id);
            if (group == null)
            {
                throw new KeyNotFoundException("Group not found");
            }
            _context.Group.Remove(group);
            _context.SaveChanges();
            return true;
        }
    }
}