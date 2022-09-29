using FileSystem.Entities;
using System.Security.Cryptography;
namespace FileSystem.Services {
    public class AESEncryper {

        AesCryptoServiceProvider cryptProvider;
        public AESEncryper() {
            cryptProvider = new AesCryptoServiceProvider();
            cryptProvider.KeySize = 256;
            cryptProvider.BlockSize = 128;
            cryptProvider.Padding = PaddingMode.PKCS7;
            cryptProvider.Mode = CipherMode.CBC;
            cryptProvider.GenerateKey();
            
        }

        public IEncryptedData Encrypt(byte[] data, byte[] key = null, byte[] iv = null) {
            
            ICryptoTransform encryptor = cryptProvider.CreateEncryptor();
            IEncryptedData encryptedData = new IEncryptedData();
            if (key != null) {
                cryptProvider.Key = key;
                cryptProvider.IV = iv;
            }
            encryptedData.data = encryptor.TransformFinalBlock(data, 0, data.Length);
            encryptedData.key = cryptProvider.Key;
            encryptedData.iv = cryptProvider.IV;
            return encryptedData;

        }

        public byte[] Decrypt(byte[] data, byte[] key = null, byte[] iv = null) {
            if (key != null) {
                cryptProvider.Key = key;
                cryptProvider.IV = iv;
            }
            cryptProvider.Key = key;
            cryptProvider.IV = iv;
            ICryptoTransform decryptor = cryptProvider.CreateDecryptor();
            return decryptor.TransformFinalBlock(data, 0, data.Length);
        }

        public byte[] getKey() {
            return cryptProvider.Key;
        }

        public byte[] getIV() {
            return cryptProvider.IV;
        }
}
}
