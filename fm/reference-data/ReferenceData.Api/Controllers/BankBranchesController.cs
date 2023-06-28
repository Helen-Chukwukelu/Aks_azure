using System.Collections.Generic;
using System.Threading.Tasks;

using Datadog.Trace;

using Fmi.ReferenceData.Models;

using Microsoft.AspNetCore.Mvc;

using ReferenceData.Api.Services;

namespace ReferenceData.Api.Controllers
{

    [ApiVersion("1.0")]
    [Route("api/v{version:apiVersion}/bankbranches")]
    [ApiController]
    public class BankBranchesController : ControllerBase
    {
        private readonly IReferenceDataService _referenceDataService;

        public BankBranchesController(IReferenceDataService referenceDataService)
        {
            _referenceDataService = referenceDataService;
        }

        [HttpGet("/api/v{version:apiVersion}/bank/branches")]
        public async Task<ActionResult<IEnumerable<BankBranches>>> GetBankBranchesListAsync([FromQuery] string bankName)
        {
            if (string.IsNullOrEmpty(bankName))
            {
                using Scope scope = Tracer.Instance.StartActive("Fetch all bank branches");
                IEnumerable<BankBranches> bankList = await _referenceDataService.GetBankBranches();
                return bankList == null
                    ? NotFound()
                    : Ok(bankList);
            }
            else if (int.TryParse(bankName, out var bankId))
            {
                using Scope scope = Tracer.Instance.StartActive("Fetch all branches for a bank by bankId");
                IEnumerable<BankBranches> bankList = await _referenceDataService.GetBankBranches(bankId);
                return bankList == null
                    ? NotFound()
                    : Ok(bankList);

            }
            else
            {
                using Scope scope = Tracer.Instance.StartActive("Fetch all branches for a bank by name");
                IEnumerable<BankBranches> bankList = await _referenceDataService.GetBankBranches(bankName);
                return bankList == null
                    ? NotFound()
                    : Ok(bankList);
            }

        }

        [HttpGet("/api/v{version:apiVersion}/bank/{bankIdOrName}/branches")]
        public async Task<ActionResult<IEnumerable<BankBranches>>> FilterBankBranchesForBankIdAsync(string bankIdOrName, [FromQuery] string filter)
        {
            if (int.TryParse(bankIdOrName, out var bankId))
            {
                if (string.IsNullOrEmpty(filter))
                {
                    using Scope scope = Tracer.Instance.StartActive("Fetch all branches for a bank by bankName");
                    IEnumerable<BankBranches> bankList = await _referenceDataService.GetBankBranches(bankId);
                    return bankList == null
                        ? NotFound()
                        : Ok(bankList);
                }
                else
                {
                    using Scope scope = Tracer.Instance.StartActive("Fetch filtered branches for a bank by filter and bankName");
                    IEnumerable<BankBranches> bankList = await _referenceDataService.GetBankBranches(bankId, filter);
                    return bankList == null
                        ? NotFound()
                        : Ok(bankList);
                }
            }
            else
            {
                if (string.IsNullOrEmpty(filter))
                {
                    using Scope scope = Tracer.Instance.StartActive("Fetch all branches for a bank by bankName");
                    IEnumerable<BankBranches> bankList = await _referenceDataService.GetBankBranches(bankIdOrName);
                    return bankList == null
                        ? NotFound()
                        : Ok(bankList);
                }
                else
                {
                    using Scope scope = Tracer.Instance.StartActive("Fetch filtered branches for a bank by filter and bankName");
                    IEnumerable<BankBranches> bankList = await _referenceDataService.GetBankBranches(bankIdOrName, filter);
                    return bankList == null
                        ? NotFound()
                        : Ok(bankList);
                }
            }
        }

        [HttpGet("/api/v{version:apiVersion}/bank/{bankId}/branches/{bankBranchId}")]
        public async Task<ActionResult<BankBranches>> GetBankBranchAsync(int bankBranchId)
        {
            using Scope scope = Tracer.Instance.StartActive("Get a specific bank branch");
            BankBranches bank = await _referenceDataService.GetBankBranch(bankBranchId);
            return bank == null
                ? NotFound()
                : Ok(bank);
        }
    }
}