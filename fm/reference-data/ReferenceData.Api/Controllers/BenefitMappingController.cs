using System.Collections.Generic;
using System.Threading.Tasks;

using Fmi.ReferenceData.Models;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

using Serilog;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/benefitmapping")]
    [ApiController]
    public class BenefitMappingController : ControllerBase
    {
        private readonly ILogger _logger;
        private readonly IReferenceDataService _referenceDataService;

        public BenefitMappingController(ILogger logger, IReferenceDataService referenceDataService)
        {
            _logger = logger;
            _referenceDataService = referenceDataService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            _logger.Debug("Getting benefit mapping list.");
            IEnumerable<BenefitMap> benefitMapList = await _referenceDataService.GetBenefitMap();
            return Ok(benefitMapList);
        }
    }
}