using Microsoft.EntityFrameworkCore;
using FileSystem.Data;
using FileSystem.Models;
using FileSystem.Entities;

namespace FileSystem.Services {
    public interface IUserFilesService {

        IEnumerable<byte[]> GetImageByUserId(Guid id);
        IEnumerable<byte[]> GetTranscriptByUserId(Guid id);
        bool ModifyUserImage(UserFiles imageInput);
        bool ModifyUserTranscript(UserFiles transcript);
        Guid createUserRecord(UserFiles userFile);
        bool DeleteUserFilesById(Guid id);


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

        //public bool ModifyUserFiles(UserFiles userFilesInput) {
        //    var userFile = _context.UserFiles.Find(userFilesInput.Id);
        //    if (userFile == null) {
        //        userFile.Id = userFilesInput.Id;
        //        userFile.UserImage = userFilesInput.UserImage;
        //        userFile.UserTranscript = userFile.UserTranscript;
        //        _context.UserFiles.Add(userFile);
        //        _context.SaveChanges();
        //        return true;
        //    }
        //    else {
        //        userFile.UserImage = userFilesInput.UserImage;
        //        userFile.UserTranscript = userFile.UserTranscript;
        //        _context.UserFiles.Update(userFile);
        //        _context.SaveChanges();
        //        return true;

        //    }
        //}

        public bool DeleteUserFilesById(Guid id) {
            var userFile = _context.UserFiles.Find(id);
            if (userFile == null) {
                throw new KeyNotFoundException("user files not found");
            }
            _context.UserFiles.Remove(userFile);

            
            _context.SaveChanges();
            return true;
        }

        public bool ModifyUserImage(UserFiles imageInput) {
            var userFile = _context.UserFiles.Find(imageInput.Id);
            if (userFile == null) {
                throw new KeyNotFoundException("user files not found");
            }
            userFile.UserImage = imageInput.UserImage;
            _context.UserFiles.Update(userFile);
            _context.SaveChanges();
            return true;
        }

        public bool ModifyUserTranscript(UserFiles transcript) {
            var userFile = _context.UserFiles.Find(transcript.Id);
            if (userFile == null) {
                throw new KeyNotFoundException("user files not found");
            }
            userFile.UserTranscript = transcript.UserTranscript;
            _context.UserFiles.Update(userFile);
            _context.SaveChanges();
            return true;
        }
    }
}