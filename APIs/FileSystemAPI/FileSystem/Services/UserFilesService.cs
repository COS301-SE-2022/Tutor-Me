using Microsoft.EntityFrameworkCore;
using FileSystem.Data;
using FileSystem.Models;
using FileSystem.Entities;
using System.Net.Http;
using System.Text;
using Newtonsoft.Json;

namespace FileSystem.Services {
    public interface IUserFilesService {

        Task<byte[]> GetImageByUserId(Guid id);
        Task<byte[]> GetTranscriptByUserId(Guid id);
        bool ModifyUserImage(UserFiles imageInput);
        bool ModifyUserTranscript(UserFiles transcript);
        Guid createUserRecord(IUserFiles userFile);
        bool DeleteUserFilesById(Guid id);
        Task<bool> checkIfAuthorized(UserAuth userAuth);


    }
    public class UserFilesService : IUserFilesService {

        private FilesContext _context;
        private static readonly HttpClient client = new HttpClient();
        public UserFilesService(FilesContext context) {
            _context = context;
        }

        public async Task<byte[]> GetImageByUserId(Guid id) {
            var record = _context.UserFiles.FirstOrDefault(e => e.Id == id);
            if (record == null) {
                return null;
            }
            AESEncryper encryper = new AESEncryper();
            if (record.UserImage == null) {
                return null;
            }
            return encryper.Decrypt(record.UserImage, record.ImageKey, record.ImageIV);
            
        }

        public async Task<byte[]> GetTranscriptByUserId(Guid id) {
            var record = _context.UserFiles.FirstOrDefault(e => e.Id == id);
            if (record == null) {
                return null;
            }
            AESEncryper encryper = new AESEncryper();
            if (record.UserTranscript == null) {
                return null;
            }
            return encryper.Decrypt(record.UserTranscript, record.TranscriptKey, record.TranscriptIV);
        }
        public Guid createUserRecord(IUserFiles userFileInput) {
            if (_context.UserFiles.Where(e => e.Id == userFileInput.Id).Any()) {
                throw new KeyNotFoundException("This user files already exists");
            }
            UserFiles userFile = new UserFiles();
            userFile.Id = userFileInput.Id;
            userFile.UserImage = userFileInput.UserImage;
            userFile.UserTranscript = userFileInput.UserTranscript;
            //encrypt the user image and transcript
            if (userFile.UserImage != null) {
                AESEncryper encryper = new AESEncryper();
                IEncryptedData encryptedData = encryper.Encrypt(userFile.UserImage);
                userFile.UserImage = encryptedData.data;
                userFile.ImageKey = encryptedData.key;
                userFile.ImageIV = encryptedData.iv;
            }
            if (userFile.UserTranscript != null) {
                AESEncryper encryper = new AESEncryper();
                IEncryptedData encryptedData = encryper.Encrypt(userFile.UserTranscript);
                userFile.UserTranscript = encryptedData.data;
                userFile.TranscriptKey = encryptedData.key;
                userFile.TranscriptIV = encryptedData.iv;
            }
            _context.UserFiles.Add(userFile);
            _context.SaveChanges();
            return userFile.Id;
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

        public bool ModifyUserImage(UserFiles imageInput) {
            var userFile = _context.UserFiles.Find(imageInput.Id);
            if (userFile == null) {
                throw new KeyNotFoundException("user files not found");
            }
            if (imageInput.UserImage != null) {
                AESEncryper encryper = new AESEncryper();
                IEncryptedData encryptedData = encryper.Encrypt(imageInput.UserImage);
                userFile.UserImage = encryptedData.data;
                userFile.ImageKey = encryptedData.key;
                userFile.ImageIV = encryptedData.iv;
            }
            _context.UserFiles.Update(userFile);
            _context.SaveChanges();
            return true;
        }

        public bool ModifyUserTranscript(UserFiles transcript) {
            var userFile = _context.UserFiles.Find(transcript.Id);
            if (userFile == null) {
                throw new KeyNotFoundException("user files not found");
            }
            if (transcript.UserTranscript != null) {
                AESEncryper encryper = new AESEncryper();
                IEncryptedData encryptedData = encryper.Encrypt(transcript.UserTranscript);
                userFile.UserTranscript = encryptedData.data;
                userFile.TranscriptKey = encryptedData.key;
                userFile.TranscriptIV = encryptedData.iv;
            }
            _context.UserFiles.Update(userFile);
            _context.SaveChanges();
            return true;
        }

        public async Task<bool> checkIfAuthorized(UserAuth userAuth) {
            //check if the user is authorized to access the file
            var url = "http://tutormeapi-dev.us-east-1.elasticbeanstalk.com/login";
            var content = new StringContent(JsonConvert.SerializeObject(userAuth), Encoding.UTF8, "application/json");
            //var content = new Dictionary<string, string> {
            //    { "email", userAuth.Email },
            //    { "password", userAuth.Password },
            //    { "typeId", userAuth.TypeId.ToString() }
            //};
            var response = client.PostAsync(url, content).Result;
            if (response.StatusCode == System.Net.HttpStatusCode.OK) {
                return true;
            }
            else {
                return false;
            }
        }
    }
}