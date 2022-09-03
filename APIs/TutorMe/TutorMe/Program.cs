using TutorMe.Data;
using Microsoft.EntityFrameworkCore;
using TutorMe.Services;
using AutoMapper;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
//builder.Services.AddScoped<IUserTypeService, UserTypeServices>();
builder.Services.AddScoped<IUserService, UserServices>();
builder.Services.AddScoped<IConnectionService, ConnectionServices>();
builder.Services.AddScoped<IUserTypeService, UserTypeServices>();
builder.Services.AddScoped<IRequestService, RequestServices>();
builder.Services.AddScoped<IModuleService,ModuleServices>();
builder.Services.AddScoped<IInstitutionService, InstitutionServices>();
builder.Services.AddScoped<IGroupMemberService, GroupMemberServices>();
builder.Services.AddScoped<IGroupService, GroupServices>();
builder.Services.AddScoped<IUserAuthenticationService, UserAuthenticationServices>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
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

app.UseAuthorization();

app.MapControllers();

app.Run();
