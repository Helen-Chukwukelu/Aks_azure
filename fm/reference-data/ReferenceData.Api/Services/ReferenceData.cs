using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using Fmi.ReferenceData.Models;

using Microsoft.EntityFrameworkCore;

using ReferenceData.Api.Entities;

namespace ReferenceData.Api.Services
{
    public class ReferenceDataService : IReferenceDataService
    {
        private readonly ReferenceDataDbContext _context;

        public ReferenceDataService(ReferenceDataDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Occupation>> GetOccupations() => await _context.Occupations.Where(o => o.Rating < 6 && o.Event_Class != "E999")
              .OrderBy(i => i.Description)
              .ToListAsync();

        public async Task<IEnumerable<Occupation>> GetOccupations(string filter)
        {
            filter = filter.ToLower();

            return await _context.Occupations.Where(o =>
                o.Description.ToLower().Contains(filter)
                && o.Rating < 6
                && o.Event_Class != "E999")
                .OrderBy(i => i.Description)
                .ToListAsync();
        }

        public async Task<Occupation> GetOccupation(Guid id)
            => await _context.Occupations.FirstOrDefaultAsync(o => o.OccupationId == id);

        public async Task<IEnumerable<EducationLevel>> GetEducationLevels()
            => await _context.EducationLevels.OrderBy(i => i.Description).ToListAsync();

        public async Task<EducationLevel> GetEducationLevel(int id)
            => await _context.EducationLevels.FirstOrDefaultAsync(o => o.Id == id);

        public async Task<IEnumerable<Industry>> GetIndustries()
            => await _context.Industry.OrderBy(i => i.Description).ToListAsync();

        public async Task<IEnumerable<Bank>> GetBanks()
            => await _context.Banks.OrderBy(i => i.BankName).ToListAsync();

        public async Task<IEnumerable<Nationality>> GetNationalities()
            => await _context.Nationalities.OrderBy(i => i.DisplayOrder).ToListAsync();

        public async Task<IEnumerable<InsuranceCompany>> GetInsuranceCompanies()
            => await _context.InsuranceCompany.OrderBy(i => i.DisplayOrder).ToListAsync();

        public async Task<IEnumerable<BenefitMap>> GetBenefitMap()
          => await _context.BenefitMap.ToListAsync();

        public async Task<IEnumerable<UnderwritingRequirementsMap>> GetUnderwritingRequirementsMap()
          => await _context.UnderwritingRequirementsMap.ToListAsync().ConfigureAwait(false);



        public async Task<IEnumerable<BankBranches>> GetBankBranches(string bankName)
        {
            Bank bank = await _context.Banks.FirstOrDefaultAsync(b => b.BankName == bankName);
            return bank == null
                ? null
                : (IEnumerable<BankBranches>) await _context.BankBranches.Where(b => b.BankId == bank.BankId).Distinct().ToListAsync();
        }

        public async Task<IEnumerable<BankBranches>> GetBankBranches(int bankId, string filter)
          => string.IsNullOrEmpty(filter)
                    ? await _context.BankBranches.Where(b => b.BankId == bankId).ToListAsync()
                    : await _context.BankBranches.Where(b => b.BankId == bankId && b.BranchName.Contains(filter)).Distinct().ToListAsync();

        public async Task<IEnumerable<BankBranches>> GetBankBranches(string bankName, string filter)
        {
            Bank bank = await _context.Banks.FirstOrDefaultAsync(b => b.BankName == bankName);
            return bank == null
                ? null
                : (IEnumerable<BankBranches>) await _context.BankBranches.Where(b => b.BranchName.Contains(filter)).ToListAsync();
        }

        public async Task<BankBranches> GetBankBranch(int bankBranchId)
          => await _context.BankBranches.Where(b => b.BankBranchId == bankBranchId).FirstOrDefaultAsync();

        public async Task<IEnumerable<BankBranches>> GetBankBranches(int bankId)
          => await _context.BankBranches.Where(b => b.BankId == bankId).Distinct().ToListAsync();

        public async Task<IEnumerable<BankBranches>> GetBankBranches()
            => await _context.BankBranches.Distinct().ToListAsync();


    }
}