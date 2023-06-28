using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("0.0")]
    [Route("api/v{version:apiVersion}/educationlevel")]
    [ApiController]
    public class EducationLevelController : ControllerBase
    {
        private readonly IReferenceDataService _service;

        /// <summary>
        /// QuoteController constructor
        /// </summary>
        /// <param name="logger"></param>
        /// <param name="config"></param>
        /// <param name="service"></param>
        public EducationLevelController(IReferenceDataService service)
        {
            _service = service;
        }

        /// <summary>
        /// List of education level
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<IActionResult> Get()
            => Ok(await _service.GetEducationLevels());

        /// <summary>
        /// Get a specific education level by id
        /// </summary>
        /// <returns></returns>
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
            => Ok(await _service.GetEducationLevel(id));
    }
}
