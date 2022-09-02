using Microsoft.EntityFrameworkCore;
using FileSystem.Data;
using FileSystem.Models;

namespace FileSystem.Services {
    public interface IUserFilesService {

        IEnumerable<byte[]> GetImageByUserId(Guid id);
        IEnumerable<byte[]> GetTranscriptByUserId(Guid id);
        bool ModifyUserImageById(Guid id,byte[] userFiles);
        bool ModifyUserTranscriptById(Guid id, byte[] userFiles);


    }
    public class UserFilesService : IUserFilesService {

        private FilesContext _context;
        public UserFilesService(FilesContext context) {
            _context = context;
        }

        public IEnumerable<byte[]> GetImageByUserId(Guid id) {
            return _context.UserFiles.Where(e => e.Id == id).Select(e => e.UserImage).ToList();
        }

        public IEnumerable<byte[]> GetTranscriptByUserId(Guid id) {
            return _context.UserFiles.Where(e => e.Id == id).Select(e => e.UserTranscript).ToList();
        }
        public Guid createUserRecord(UserFiles userFile) {
            if (_context.UserFiles.Where(e => e.Id == userFile.Id).Any()) {
                throw new KeyNotFoundException("This user files already exists");
            }
            //TODO: make sure the files is encrypted or encoded
            _context.UserFiles.Add(userFile);
            _context.SaveChanges();
            return userFile.Id;
        }

        public bool ModifyUserImageById(Guid id ,byte[] image) {
            var userFile = _context.UserFiles.Find(id);
            if (userFile == null) {
                throw new KeyNotFoundException("This user files does not exist");
            }
            userFile.UserImage = image;
            _context.SaveChanges();
            return true;
        }

        public bool ModifyUserTranscriptById(Guid id, byte[] file) {
            var userFile = _context.UserFiles.Find(id);
            if (userFile == null) {
                throw new KeyNotFoundException("This user files does not exist");
            }
            userFile.UserTranscript = file;
            _context.SaveChanges();
            return true;
        }

        public bool DeleteUserFilesById(Guid id) {
            var userFile = _context.UserFiles.Find(id);
            if (userFile == null) {
                throw new KeyNotFoundException("user files not found");
            }
            _context.UserFiles.Remove(userFile);
            _context.SaveChanges();
            return true;
        }
    }
}