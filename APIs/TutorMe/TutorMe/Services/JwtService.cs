using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using System.Security.Claims;
using System.Security.Cryptography;
using TutorMe.Models;
using TutorMe.Data;
using TutorMe.Entities;

namespace TutorMe.Services {
    public interface IJwtService {
        Task<AuthResponse> GetTokenAsync(UserLogIn authRequest, string ipAddress);
        Task<AuthResponse> GetRefreshTokenAsync(string ipAddress, Guid userId, string userName);
        Task<bool> IsTokenValid(string accessToken, string ipAddress);
    }
    public class JwtService : IJwtService {
        private readonly TutorMeContext _context;
        private readonly IConfiguration _configuration;
        private IUserAuthenticationService _userAuthenticationService;

        public JwtService(TutorMeContext context, IConfiguration configuration, IUserAuthenticationService userAuthenticationService) {
            _context = context;
            _configuration = configuration;
            _userAuthenticationService = userAuthenticationService;
        }
        
        public async Task<AuthResponse> GetRefreshTokenAsync(string ipAddress, Guid userId, string userName) {
            var refreshToken = GenerateRefreshToken();
            var accessToken = GenerateToken(userName);
            return await SaveTokenDetails(ipAddress, userId, accessToken, refreshToken);
        }

        public async Task<AuthResponse> GetTokenAsync(UserLogIn authRequest, string ipAddress) {
            try {
                var user = _userAuthenticationService.LogInUser(authRequest);
                if (user == null) {
                    return await Task.FromResult<AuthResponse>(null);
                }
                string tokenString = GenerateToken(user.Email);
                string refreshToken = GenerateRefreshToken();
                return await SaveTokenDetails(ipAddress, user.UserId, tokenString, refreshToken);
            }
            catch (Exception e) {
                return await Task.FromResult<AuthResponse>(null);
            }
            

        }

        private async Task<AuthResponse> SaveTokenDetails(string ipAddress, Guid userId, string tokenString, string refreshToken) {
            var userRefreshToken = new UserRefreshToken {
                CreatedDate = DateTime.UtcNow,
                ExpirationDate = DateTime.UtcNow.AddMinutes(10080),
                IpAddress = ipAddress,
                IsInvalidated = false,
                RefreshToken = refreshToken,
                Token = tokenString,
                UserId = userId
            };
            await _context.UserRefreshToken.AddAsync(userRefreshToken);
            await _context.SaveChangesAsync();
            return new AuthResponse { Token = tokenString, RefreshToken = refreshToken, IsSuccess = true };
        }

        private string GenerateRefreshToken() {
            var byteArray = new byte[64];
            using (var cryptoProvider = new RNGCryptoServiceProvider()) {
                cryptoProvider.GetBytes(byteArray);

                return Convert.ToBase64String(byteArray);
            }
        }

        private string GenerateToken(string userName) {
            var jwtKey = _configuration.GetValue<string>("JwtConfig:Key");
            var keyBytes = Encoding.ASCII.GetBytes(jwtKey);

            var tokenHandler = new JwtSecurityTokenHandler();

            var descriptor = new SecurityTokenDescriptor() {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.NameIdentifier, userName)

                }),
                Expires = DateTime.UtcNow.AddSeconds(300),

                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(keyBytes),
               SecurityAlgorithms.HmacSha256)
            };

            var token = tokenHandler.CreateToken(descriptor);
            string tokenString = tokenHandler.WriteToken(token);
            return tokenString;
        }

        public async Task<bool> IsTokenValid(string accessToken, string ipAddress) {
            var isValid = _context.UserRefreshToken.FirstOrDefault(x => x.Token == accessToken
            && x.IpAddress == ipAddress) != null;
            return await Task.FromResult(isValid);
        }
    }
}
