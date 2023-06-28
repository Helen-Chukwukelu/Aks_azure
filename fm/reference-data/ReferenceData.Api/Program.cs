using Fmi.Core.Startup;

using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace ReferenceData.Api
{
    public class Program
    {
        public static void Main(string[] args) =>
            WebHost
                .CreateDefaultBuilder()
                .ConfigureFmi(serviceName: "reference-data")
                .UseStartup<Startup>()
                .Build()
                .Run();
    }
}