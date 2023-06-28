using System;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/occupation")]
    [ApiController]
    public class OccupationController : ControllerBase
    {
        private readonly IReferenceDataService _service;

        /// <summary>
        /// OccupationController constructor
        /// </summary>
        /// <param name="logger"></param>
        /// <param name="config"></param>
        /// <param name="service"></param>
        public OccupationController(IReferenceDataService service)
        {
            _service = service;
        }

        /// <summary>
        /// Get a list of occupations
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<IActionResult> Get()
            => Ok(await _service.GetOccupations());

        /// <summary>
        /// Get a filtered list of occupations
        /// </summary>
        /// <param name="filter">Where description contains filter</param>
        /// <returns></returns>
        [HttpGet("{filter}")]
        public async Task<IActionResult> Get(string filter)
        {
            if (Guid.TryParse(filter, out Guid guidOutput))
            {
                return Ok(await _service.GetOccupation(guidOutput));
            }
            else
            {
                return Ok(await _service.GetOccupations(filter));
            }
        }
    }
}
