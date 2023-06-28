using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/industry")]
    [ApiController]
    public class IndustryController : ControllerBase
    {
        private readonly IReferenceDataService _service;

        /// <summary>
        /// OccupationController constructor
        /// </summary>
        /// <param name="logger"></param>
        /// <param name="config"></param>
        /// <param name="service"></param>
        public IndustryController(IReferenceDataService service)
        {
            _service = service;
        }

        /// <summary>
        /// Get a list of occupations
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<IActionResult> Get()
            => Ok(await _service.GetIndustries());
    }
}

