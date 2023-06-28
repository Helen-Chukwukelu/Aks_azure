
using Fmi.Core.Startup;

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using Prometheus;

using ReferenceData.Api.Entities;
using ReferenceData.Api.Services;
using ReferenceData.Configuration;

namespace ReferenceData.Api
{
    public class Startup
    {
        private readonly IWebHostEnvironment _environment;
        private readonly IConfiguration _configuration;

        public Startup(IConfiguration configuration, IWebHostEnvironment environment)
        {
            _configuration = configuration;
            _environment = environment;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            ReferenceDataConfiguration config = services.ConfigureFmiServices<ReferenceDataConfiguration>(
                _configuration,
                true,
                new[] { 0.0m, 1.0m },
                0m);

            ConnectionStrings connectionStrings = config.ConnectionStrings;
            services.AddSingleton(connectionStrings);

            _ = services
                .AddDbContext<ReferenceDataDbContext>(options => options.UseSqlServer(config.ConnectionStrings.ReferenceData))
                .AddTransient<IReferenceDataService, ReferenceDataService>();

            if (_environment.IsStaging() || _environment.IsProduction())
            {
                AddDependencyHealthChecks(services);
            }
        }

        private static void AddDependencyHealthChecks(IServiceCollection services)
            => _ = services.AddHealthChecks().ForwardToPrometheus();

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ReferenceDataConfiguration configuration)
            => app.ConfigureFmi(
                 env,
                 configuration,
                 true,
                 new[] { 0.0m, 1.0m });
    }
}
