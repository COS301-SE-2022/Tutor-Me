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
        bool UpdateEventTime(Guid id, string newTime);
        bool UpdateEventTitle(Guid id, string newTitle);
        bool UpdateEventDescription(Guid id, string newDescription);
    }
    public class EventService : IEventService {
        private readonly TutorMeContext _context;

        public EventService(TutorMeContext context) {
            _context = context;
        }

        public IEnumerable<Event> GetUserEvents(Guid id) {
            return _context.Event.Where(e => e.OwnerId == id || e.UserId == id).ToArray();
        }

        public bool CreateUserEvent(IEvent eventInput) {
            var newEvent = new Event();
            newEvent.EventId = Guid.NewGuid();
            newEvent.OwnerId = eventInput.OwnerId;
            newEvent.UserId = eventInput.UserId;
            newEvent.DateOfEvent = eventInput.DateOfEvent;
            newEvent.GroupId = eventInput.GroupId;
            newEvent.VideoLink = eventInput.VideoLink;
            newEvent.TimeOfEvent = eventInput.TimeOfEvent;
            newEvent.Title = eventInput.Title;
            newEvent.Description = eventInput.Description;
            _context.Event.Add(newEvent);
            _context.SaveChanges();
            return true;
        }

        public bool DeleteUserEvent(Guid id) {
            var Event = _context.Event.Find(id);
            if (Event != null) {
                _context.Event.Remove(Event);
                _context.SaveChanges();
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

        public bool UpdateEventTime(Guid id, string newTime) {
            var Userevent = _context.Event.Find(id);
            if (Userevent != null) {
                Userevent.TimeOfEvent = newTime;
                _context.SaveChanges();
                return true;
            }
            else {
                return false;
            }
        }

        public bool UpdateEventTitle(Guid id, string newTitle) {
            var Userevent = _context.Event.Find(id);
            if (Userevent != null) {
                Userevent.Title = newTitle;
                _context.SaveChanges();
                return true;
            }
            else {
                return false;
            }
        }

        public bool UpdateEventDescription(Guid id, string newDescription) {
            var Userevent = _context.Event.Find(id);
            if (Userevent != null) {
                Userevent.Description = newDescription;
                _context.SaveChanges();
                return true;
            }
            else {
                return false;
            }
        }
    }
}
