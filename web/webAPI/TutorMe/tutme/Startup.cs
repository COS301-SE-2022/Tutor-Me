using Tutors.Repo;
using Tutors.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.InMemory;
using Microsoft.Extensions.DependencyInjection;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace TutorMe {
    public class Startup {
        public Startup(IConfiguration configuration) {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        public void ConfigureServices(IServiceCollection services) {
            services.AddCors(options => options.AddPolicy("Cors", builder => {
                builder
                .AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader();
            }));
            services.AddMvc(options => options.EnableEndpointRouting = false);
            services.AddDbContext<TutorDbContext>(opt => opt.UseInMemoryDatabase("TutorDb"));
            services.AddTransient<ITutor, TutorRepo>();
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Latest);
        }
        public void Configure(IApplicationBuilder app, IHostEnvironment env) {
            if (env.IsDevelopment()) {
                app.UseDeveloperExceptionPage();
            }
            else {
                app.UseHsts();
            }
            app.UseCors("Cors");
            app.UseHttpsRedirection();
            app.UseMvc();
        }


    }
}


/******************************
Referenced from:
* Title: Flutter-API-Back-End
* Author: Alaeddin Alhamoud
* Date: 2019
* Availability: https://github.com/Alaeddinalhamoud/Flutter-API-Back-End
*
*****************************/

