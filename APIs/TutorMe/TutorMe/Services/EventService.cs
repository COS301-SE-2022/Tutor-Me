using TutorMe.Data;
using TutorMe.Models;
using Microsoft.EntityFrameworkCore;
using TutorMe.Entities;

namespace TutorMe.Services {
    public interface IEventService {
        IEnumerable<Event> GetUserEvents(Guid id);
        bool CreateUserEvent(IEvent eventInput);
        bool DeleteUserEvent(Guid id);
        bool UpdateEventDate(Guid id, string newDate);
        bool UpdateEventVideoLink(Guid id, string newVideoLink);
    }
    public class EventService : IEventService {
        private readonly TutorMeContext _context;

        public EventService(TutorMeContext context) {
            _context = context;
        }

        public IEnumerable<Event> GetUserEvents(Guid id) {
            return _context.Event.Where(e => e.UserId == id);
        }

        public bool CreateUserEvent(IEvent eventInput) {
            var newEvent = new Event();
            newEvent.EventId = Guid.NewGuid();
            newEvent.UserId = eventInput.UserId;
            newEvent.DateOfEvent = eventInput.DateOfEvent;
            newEvent.GroupId = eventInput.GroupId;
            newEvent.VideoLink = eventInput.VideoLink;
            _context.Event.Add(newEvent);
            _context.SaveChanges();
            return true;
        }

        public bool DeleteUserEvent(Guid id) {
            var Event = _context.Event.Find(id);
            if (Event != null) {
                _context.Event.Remove(Event);
                return true;
            }
            else {
                return false;
            }
        }

        public bool UpdateEventDate(Guid id, string newDate) {
            var Userevent = _context.Event.Find(id);
            if(Userevent != null){
                Userevent.DateOfEvent = newDate;
                _context.SaveChanges();
                return true;
            }
            else{
                return false;
            }
        }

        public bool UpdateEventVideoLink(Guid id, string newVideoLink) {
            var Userevent = _context.Event.Find(id);
            if (Userevent != null){
                Userevent.VideoLink = newVideoLink;
                _context.SaveChanges();
                return true;
            }
            else {
                return false;
            }
        }
    }
}
