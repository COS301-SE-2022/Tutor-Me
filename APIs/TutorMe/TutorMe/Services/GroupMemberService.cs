using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IGroupMemberService
    {
        IEnumerable<GroupMember> GetAllGroupMembers();
        GroupMember GetGroupMemberById(Guid id);
        Guid createGroupMember(GroupMember groupMember);
        bool deleteGroupMemberById(Guid id);
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
            return _context.GroupMember;
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
        public Guid createGroupMember(GroupMember groupMember)
        {
            if (_context.GroupMember.Where(e => e.UserId == groupMember.UserId && e.GroupId == groupMember.GroupId).Any())
            {
                throw new KeyNotFoundException("This GroupMember already exists, Please log in");
            }
            //GroupMember.Password = BCrypt.Net.BCrypt.HashPassword(GroupMember.Password, "ThisWillBeAGoodPlatformForBothGroupMembersAndTuteesToConnectOnADailyBa5e5");
            groupMember.GroupMemberId = Guid.NewGuid();
            _context.GroupMember.Add(groupMember);
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
    }
}