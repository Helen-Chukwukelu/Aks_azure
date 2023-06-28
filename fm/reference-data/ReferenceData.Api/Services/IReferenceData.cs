using System;
using System.Collections.Generic;
using System.Threading.Tasks;

using Fmi.ReferenceData.Models;

using Microsoft.AspNetCore.Mvc;

namespace ReferenceData.Api.Services
{
    public interface IReferenceDataService
    {
        Task<IEnumerable<Occupation>> GetOccupations();
        Task<IEnumerable<Occupation>> GetOccupations([FromQuery] string filter);
        Task<Occupation> GetOccupation(Guid id);

        Task<IEnumerable<EducationLevel>> GetEducationLevels();
        Task<EducationLevel> GetEducationLevel(int id);

        Task<IEnumerable<Industry>> GetIndustries();

        Task<IEnumerable<Bank>> GetBanks();

        Task<IEnumerable<Nationality>> GetNationalities();

        Task<IEnumerable<InsuranceCompany>> GetInsuranceCompanies();

        Task<IEnumerable<BenefitMap>> GetBenefitMap();

        Task<IEnumerable<UnderwritingRequirementsMap>> GetUnderwritingRequirementsMap();


        Task<IEnumerable<BankBranches>> GetBankBranches(string bankName);

        Task<IEnumerable<BankBranches>> GetBankBranches(string bankName, string filter);

        Task<IEnumerable<BankBranches>> GetBankBranches(int bankId, string filter);

        Task<BankBranches> GetBankBranch(int bankBranchId);

        Task<IEnumerable<BankBranches>> GetBankBranches(int bankId);

        Task<IEnumerable<BankBranches>> GetBankBranches();

    }
}
