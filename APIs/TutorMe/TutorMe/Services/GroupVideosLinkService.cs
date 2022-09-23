using TutorMe.Models;
using TutorMe.Data;
using TutorMe.Entities;
using Microsoft.AspNetCore.Authorization;

namespace TutorMe.Services {
    public interface IGroupVideosLinkService {
        IEnumerable<GroupVideosLink> GetAllGroupVideosLinksByGroupId(Guid id);
        Guid CreateGroupVideosLink(IGroupVideosLink groupVideosLink);
        bool DeleteGroupVideosLinkById(Guid id);
    }
    public class GroupVideosLinkService : IGroupVideosLinkService {

        private TutorMeContext _context;
        public GroupVideosLinkService(TutorMeContext context) {
            _context = context;
        }

        [Authorize]
        public IEnumerable<GroupVideosLink> GetAllGroupVideosLinksByGroupId(Guid id) {
            return _context.GroupVideosLink.Where(e => e.GroupId == id);
        }

        [Authorize]
        public Guid CreateGroupVideosLink(IGroupVideosLink groupVideosLink) {
            var newGroupVideosLink = new GroupVideosLink();
            newGroupVideosLink.GroupVideoLinkId = Guid.NewGuid();
            newGroupVideosLink.GroupId = groupVideosLink.GroupId;
            newGroupVideosLink.VideoLink = groupVideosLink.VideoLink;
            
            _context.GroupVideosLink.Add(newGroupVideosLink);
            _context.SaveChanges();
            return newGroupVideosLink.GroupVideoLinkId;
        }

        [Authorize]
        public bool DeleteGroupVideosLinkById(Guid id) {
            var groupVideosLink = _context.GroupVideosLink.Find(id);
            if (groupVideosLink == null) {
                throw new KeyNotFoundException("GroupVideosLink not found");
            }
            _context.GroupVideosLink.Remove(groupVideosLink);
            _context.SaveChanges();
            return true;
        }
    }
}
