using TutorMe.Data;
using Microsoft.EntityFrameworkCore;
using TutorMe.Services;
using AutoMapper;
using Microsoft.OpenApi.Models;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.IdentityModel.Tokens.Jwt;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddSwaggerGen(c => {
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "JWTRefreshTokens", Version = "v1" });

    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme {
        Description = "This site uses Bearer token and you have to pass" +
        "it as Bearer<<space>>Token",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement()
    {
                    {
                    new OpenApiSecurityScheme
                    {
                        Reference=new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id="Bearer"
                        },
                        Scheme="oauth2",
                        Name="Bearer",
                        In = ParameterLocation.Header
                    },
                    new List<string>()
                    }
                });
});

var jwtKey = builder.Configuration.GetValue<string>("JwtConfig:Key");
var keyBytes = Encoding.ASCII.GetBytes(jwtKey);

TokenValidationParameters tokenValidation = new TokenValidationParameters {
    IssuerSigningKey = new SymmetricSecurityKey(keyBytes),
    ValidateLifetime = true,
    ValidateAudience = false,
    ValidateIssuer = false,
    ClockSkew = TimeSpan.Zero
};

builder.Services.AddSingleton(tokenValidation);

builder.Services.AddAuthentication(authOptions =>{
    authOptions.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    authOptions.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
    .AddJwtBearer(jwtOptions => {
        jwtOptions.TokenValidationParameters = tokenValidation;
        jwtOptions.Events = new JwtBearerEvents();
        jwtOptions.Events.OnTokenValidated = async (context) =>
        {
            var ipAddress = context.Request.HttpContext.Connection.RemoteIpAddress.ToString();
            var jwtService = context.Request.HttpContext.RequestServices.GetService<IJwtService>();
            var jwtToken = context.SecurityToken as JwtSecurityToken;
            if (!await jwtService.IsTokenValid(jwtToken.RawData, ipAddress))
                context.Fail("Invalid Token Details");


        };
    });

builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
//builder.Services.AddScoped<IUserTypeService, UserTypeServices>();
builder.Services.AddScoped<IJwtService, JwtService>();
builder.Services.AddScoped<IUserService, UserServices>();
builder.Services.AddScoped<IConnectionService, ConnectionServices>();
builder.Services.AddScoped<IUserTypeService, UserTypeServices>();
builder.Services.AddScoped<IRequestService, RequestServices>();
builder.Services.AddScoped<IModuleService,ModuleServices>();
builder.Services.AddScoped<IInstitutionService, InstitutionServices>();
builder.Services.AddScoped<IGroupMemberService, GroupMemberServices>();
builder.Services.AddScoped<IGroupService, GroupServices>();
builder.Services.AddScoped<IUserModuleService, UserModuleServices>();
builder.Services.AddScoped<IUserAuthenticationService, UserAuthenticationServices>();
builder.Services.AddScoped<IEventService, EventService>();
builder.Services.AddScoped<IGroupVideosLinkService, GroupVideosLinkService>();
builder.Services.AddScoped<IBadgeService, BadgeService>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<TutorMeContext>(
    options =>
    {
        options.UseSqlServer(builder.Configuration.GetConnectionString("TutorMeDB"));
    }
);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();


//References Used for this code

//Author: AzureTeachTutorials
//Title: Asp.net Core Authentication With JWT(Json Web Token) & Refresh Tokens
//Purpose: Used to learn how to implement JWT and Refresh Tokens
//Date: 2021
//Repo: https://github.com/AzureTeachNet/AzureTeachTutorials/tree/JwtTokens%26RefreshTokens