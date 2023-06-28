using System.Collections.Generic;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

using Serilog;

namespace ReferenceData.Api.Controllers
{
    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/banks")]
    [ApiController]
    public class BanksController : ControllerBase
    {
        private readonly ILogger _logger;
        private readonly IReferenceDataService _referenceDataService;

        public BanksController(ILogger logger, IReferenceDataService referenceDataService)
        {
            _logger = logger;
            _referenceDataService = referenceDataService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            _logger.Information("Getting list of banks.");
            IEnumerable<Fmi.ReferenceData.Models.Bank> bankList = await _referenceDataService.GetBanks();
            return Ok(bankList);
        }
    }
}