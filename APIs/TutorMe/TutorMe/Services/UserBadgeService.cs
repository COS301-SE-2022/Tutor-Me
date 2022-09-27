using TutorMe.Data;
using TutorMe.Entities;
using TutorMe.Models;

namespace TutorMe.Services {

    public interface IUserBadgeService {
        UserBadge GetUserBadgeById(Guid id);
        IEnumerable<UserBadge> GetUsersBadgesByUserId(Guid id);
        Guid createUserBadge(IUserBadge userBadge);
        bool deleteUserBadgeById(Guid id);
        bool updatePointAchieved(Guid id, int pointAchieved);
    }
    public class UserBadgeService : IUserBadgeService {
        private TutorMeContext _context;
        public UserBadgeService(TutorMeContext context) {
            _context = context;
        }

        public UserBadge GetUserBadgeById(Guid id) {
            var userBadge = _context.UserBadge.Find(id);
            if (userBadge == null) {
                throw new KeyNotFoundException("UserBadge not found");
            }
            return userBadge;
        }

        public IEnumerable<UserBadge> GetUsersBadgesByUserId(Guid id) {
            var userBadges = _context.UserBadge.Where(e => e.UserId == id).ToList();
            if (userBadges == null) {
                throw new KeyNotFoundException("UserBadge not found");
            }
            return userBadges;
        }

        public Guid createUserBadge(IUserBadge userBadge) {
            var newUserBadge = new UserBadge();
            newUserBadge.UserBadgeId = Guid.NewGuid();
            newUserBadge.UserId = userBadge.UserId;
            newUserBadge.BadgeId = userBadge.BadgeId;
            newUserBadge.pointAchieved = userBadge.pointAchieved;
            _context.UserBadge.Add(newUserBadge);
            _context.SaveChanges();
            return newUserBadge.UserBadgeId;
        }

        public bool deleteUserBadgeById(Guid id) {
            var userBadge = _context.UserBadge.Find(id);
            if (userBadge == null) {
                throw new KeyNotFoundException("UserBadge not found");
            }
            _context.UserBadge.Remove(userBadge);
            _context.SaveChanges();
            return true;
        }

        public bool updatePointAchieved(Guid id, int pointAchieved) {
            var userBadge = _context.UserBadge.Find(id);
            if (userBadge == null) {
                throw new KeyNotFoundException("UserBadge not found");
            }
            userBadge.pointAchieved = pointAchieved;
            _context.SaveChanges();
            return true;
        }
    }
}
