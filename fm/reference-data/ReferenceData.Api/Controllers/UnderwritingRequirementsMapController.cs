using System.Collections.Generic;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

using Serilog;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/underwritingrequirementsmap")]
    [ApiController]
    public class UnderwritingRequirementsMapController : ControllerBase
    {
        private readonly ILogger _logger;
        private readonly IReferenceDataService _referenceDataService;

        public UnderwritingRequirementsMapController(ILogger logger, IReferenceDataService referenceDataService)
        {
            _logger = logger;
            _referenceDataService = referenceDataService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            _logger.Debug("Getting Underwriting Requirements mapping list.");
            IEnumerable<Fmi.ReferenceData.Models.UnderwritingRequirementsMap> underwritingRequirementsMapList =
                await _referenceDataService.GetUnderwritingRequirementsMap().ConfigureAwait(false);
            return Ok(underwritingRequirementsMapList);
        }
    }
}