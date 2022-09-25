using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services {
    public interface IBadgeService {
        IEnumerable<Badge> GetAllBadges();
        Badge GetBadgeById(Guid id);
        Guid createBadge(Badge badge);
        bool deleteBadgeById(Guid id);
        bool updateBadgePoints(Guid id, int points);
        bool updateBadgePointsToAchieve(Guid id, int pointsToAchieve);
        bool updateBadgeName(Guid id, string name);
        bool updateBadgeDescription(Guid id, string description);
        bool updateBadgeImage(Guid id, string image);


    }
    public class BadgeService : IBadgeService {

        private TutorMeContext _context;
        public BadgeService(TutorMeContext context) {
            _context = context;
        }
        public IEnumerable<Badge> GetAllBadges() {
            return _context.Badge;
        }

        public Badge GetBadgeById(Guid id) {
            var badge = _context.Badge.Find(id);
            if (badge == null) {
                throw new KeyNotFoundException("Badge not found");
            }
            return badge;
        }

        public Guid createBadge(Badge badge) {
            if (_context.Badge.Where(e => e.Name == badge.Name).Any()) {
                throw new KeyNotFoundException("This Badge already exists, Please log in");
            }
            badge.BadgeId = Guid.NewGuid();
            _context.Badge.Add(badge);
            _context.SaveChanges();
            return badge.BadgeId;
        }

        public bool deleteBadgeById(Guid id) {
            var badge = _context.Badge.Find(id);
            if (badge == null) {
                throw new KeyNotFoundException("Badge not found");
            }
            _context.Badge.Remove(badge);
            _context.SaveChanges();
            return true;
        }

        public bool updateBadgePoints(Guid id, int points) {
            var badge = _context.Badge.Find(id);
            if (badge == null) {
                throw new KeyNotFoundException("Badge not found");
            }
            badge.Points = points;
            _context.SaveChanges();
            return true;
        }

        public bool updateBadgePointsToAchieve(Guid id, int pointsToAchieve) {
            var badge = _context.Badge.Find(id);
            if (badge == null) {
                throw new KeyNotFoundException("Badge not found");
            }
            badge.PointsToAchieve = pointsToAchieve;
            _context.SaveChanges();
            return true;
        }

        public bool updateBadgeName(Guid id, string name) {
            var badge = _context.Badge.Find(id);
            if (badge == null) {
                throw new KeyNotFoundException("Badge not found");
            }
            badge.Name = name;
            _context.SaveChanges();
            return true;
        }

        public bool updateBadgeDescription(Guid id, string description) {
            var badge = _context.Badge.Find(id);
            if (badge == null) {
                throw new KeyNotFoundException("Badge not found");
            }
            badge.Description = description;
            _context.SaveChanges();
            return true;
        }

        public bool updateBadgeImage(Guid id, string image) {
            var badge = _context.Badge.Find(id);
            if (badge == null) {
                throw new KeyNotFoundException("Badge not found");
            }
            badge.Image = image;
            _context.SaveChanges();
            return true;
        }
    }
}
