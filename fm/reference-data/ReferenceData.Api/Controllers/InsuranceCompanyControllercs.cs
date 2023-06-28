using System.Collections.Generic;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

using Serilog;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/insurance-company")]
    [ApiController]
    public class InsuranceCompanyController : ControllerBase
    {
        private readonly ILogger _logger;
        private readonly IReferenceDataService _referenceDataService;

        public InsuranceCompanyController(ILogger logger, IReferenceDataService referenceDataService)
        {
            _logger = logger;
            _referenceDataService = referenceDataService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            _logger.Information("Getting list of InsuranceCompanies.");
            IEnumerable<Fmi.ReferenceData.Models.InsuranceCompany> insuranceCompanies = await _referenceDataService.GetInsuranceCompanies();
            return Ok(insuranceCompanies);
        }
    }
}