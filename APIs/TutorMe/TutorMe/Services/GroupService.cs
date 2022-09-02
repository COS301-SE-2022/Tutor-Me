using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IGroupService
    {
        IEnumerable<Group> GetAllGroups();
        Group GetGroupById(Guid id);
        Guid createGroup(IGroup group);
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
        public Guid createGroup(IGroup group)
        {
            if (_context.Group.Where(e => e.ModuleId == group.ModuleId && e.UserId == group.UserId).Any()) {
                throw new KeyNotFoundException("This Group already exists, Please log in");
            }
            var newGroup = new Group();
            newGroup.GroupId = Guid.NewGuid();
            newGroup.UserId = group.UserId;
            newGroup.ModuleId = group.ModuleId;
            newGroup.Description = group.Description;
            
            _context.Group.Add(newGroup);
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