using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IGroupMemberService
    {
        IEnumerable<GroupMember> GetAllGroupMembers();
        GroupMember GetGroupMemberById(Guid id);
        Guid createGroupMember(IGroupMember groupMember);
        bool deleteGroupMemberById(Guid id);
        IEnumerable<User> GetGroupTutees(Guid id);
        IEnumerable<Group> GetUserGroups(Guid id);
    }
    public class GroupMemberServices : IGroupMemberService
    {

        private TutorMeContext _context;
        public GroupMemberServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<GroupMember> GetAllGroupMembers()
        {
            return _context.GroupMember.ToList();
        }

        public GroupMember GetGroupMemberById(Guid id)
        {
            var groupMember = _context.GroupMember.Find(id);
            if (groupMember == null)
            {
                throw new KeyNotFoundException("GroupMember not found");
            }
            return groupMember;
        }
        public Guid createGroupMember(IGroupMember groupMember)
        {
            if (_context.GroupMember.Where(e => e.UserId == groupMember.UserId && e.GroupId == groupMember.GroupId).Any())
            {
                throw new KeyNotFoundException("This GroupMember already exists, Please log in");
            }
            var newUserGroup = new GroupMember();
            newUserGroup.GroupMemberId = Guid.NewGuid();
            newUserGroup.GroupId = groupMember.GroupId;
            newUserGroup.UserId = groupMember.UserId;
            _context.GroupMember.Add(newUserGroup);
            _context.SaveChanges();
            return groupMember.GroupMemberId;
        }

        public bool deleteGroupMemberById(Guid id)
        {
            var groupMember = _context.GroupMember.Find(id);
            if (groupMember == null)
            {
                throw new KeyNotFoundException("GroupMember not found");
            }
            _context.GroupMember.Remove(groupMember);
            _context.SaveChanges();
            return true;
        }

        public IEnumerable<User> GetGroupTutees(Guid id) {
            var tuteeId = _context.UserType.FirstOrDefault(e => e.Type == "Tutee").UserTypeId;
            if (tuteeId == null) {
                throw new KeyNotFoundException("Tutee User type not found");
            }
            var groupMembers = _context.GroupMember.Include(e=>e.User).Where(e => e.GroupId == id);
            var tutees = new List<User>();
            foreach(GroupMember user in groupMembers) {
                if (user.User.UserTypeId == tuteeId) {
                    tutees.Add(user.User);
                }
            }
            return tutees;
        }

        public IEnumerable<Group> GetUserGroups(Guid id) {
            var groupMembers = _context.GroupMember.Include(e=>e.Group).Where(e => e.UserId == id);
            if (groupMembers == null) {
                throw new KeyNotFoundException("User Module Record not found.");
            }
            var users = new List<Group>();
            foreach (GroupMember item in groupMembers) {
                users.Add(item.Group);
            }
            return users;
        }
    }
}