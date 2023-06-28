using System.Collections.Generic;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

using Serilog;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/nationalities")]
    [ApiController]
    public class NationalitiesController : ControllerBase
    {
        private readonly ILogger _logger;
        private readonly IReferenceDataService _referenceDataService;

        public NationalitiesController(ILogger logger, IReferenceDataService referenceDataService)
        {
            _logger = logger;
            _referenceDataService = referenceDataService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            _logger.Information("Getting list of nationalities.");
            IEnumerable<Fmi.ReferenceData.Models.Nationality> result = await _referenceDataService.GetNationalities();
            return Ok(result);
        }
    }
}