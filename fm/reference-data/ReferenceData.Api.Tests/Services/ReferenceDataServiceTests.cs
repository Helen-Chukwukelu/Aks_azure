using System;
using System.Collections.Generic;
using System.Threading.Tasks;

using Fmi.ReferenceData.Models;

using Microsoft.VisualStudio.TestTools.UnitTesting;

using ReferenceData.Api.Tests.Mocks;

using Shouldly;

namespace ReferenceData.Api.Services.Tests
{
    [TestClass()]
    public class ReferenceDataServiceTests
    {
        private readonly ReferenceDataService _service;

        public ReferenceDataServiceTests()
        {
            Entities.ReferenceDataDbContext? context = ReferenceDataDbMock.Create();
            _service = new ReferenceDataService(context);
        }

        [TestMethod()]
        public async Task GetOccupationsTest()
        {
            IEnumerable<Occupation>? result = await _service.GetOccupations();
            result.ShouldContain(o => o.Description.Equals("Software Engineer"));
            result.ShouldContain(o => o.Description.Equals("Accountant"));
        }

        [TestMethod()]
        public async Task GetOccupationsFilteredTest()
        {
            IEnumerable<Occupation>? result = await _service.GetOccupations("soft");
            result.ShouldContain(o => o.Description.Equals("Software Engineer"));
            result.ShouldNotContain(o => o.Description.Equals("Accountant"));
        }

        [TestMethod()]
        public async Task GetOccupationsFilteredTest_notfound()
        {
            IEnumerable<Occupation>? result = await _service.GetOccupations("no-such-occupation");
            result.ShouldBeEmpty();
        }

        [TestMethod()]
        public async Task GetOccupationTest()
        {
            Occupation result = await _service.GetOccupation(new Guid("3e0429b0-0214-4c18-8906-60a12064ec24"));
            result.ShouldNotBeNull();
            result.Description.ShouldBe("Software Engineer");
        }

        [TestMethod()]
        public async Task GetOccupationTest_notfound()
        {
            Occupation result = await _service.GetOccupation(new Guid("aaaaaaaa-0214-4c18-8906-60a12064ec24"));
            result.ShouldBeNull();
        }

        [TestMethod()]
        public async Task GetEducationLevelsTest()
        {
            IEnumerable<EducationLevel>? result = await _service.GetEducationLevels();
            result.ShouldContain(o => o.Description.Equals("3yr degree"));
        }

        [TestMethod()]
        public async Task GetEducationLevelTest()
        {
            EducationLevel result = await _service.GetEducationLevel(3);
            result.Description.ShouldBe("3yr degree");
        }


        [TestMethod()]
        public async Task GetEducationLevelTest_notfound()
        {
            EducationLevel result = await _service.GetEducationLevel(999);
            result.ShouldBeNull();
        }

        [TestMethod()]
        public async Task GetIndustriesTest()
        {
            IEnumerable<Industry>? result = await _service.GetIndustries();
            result.ShouldContain(o => o.Description.Equals("Agriculture"));
        }

        [TestMethod()]
        public async Task GetBanksTest()
        {
            IEnumerable<Bank>? result = await _service.GetBanks();
            result.ShouldContain(o => o.BankName.Equals("ABSA Bank"));
        }

        [TestMethod()]
        public async Task GetNationalitiesTest()
        {
            IEnumerable<Nationality>? result = await _service.GetNationalities();
            result.ShouldContain(o => o.NationalityName.Equals("Afghan"));
        }

        [TestMethod()]
        public async Task GetInsuranceCompaniesTest()
        {
            IEnumerable<InsuranceCompany>? result = await _service.GetInsuranceCompanies();
            result.ShouldContain(o => o.Name.Equals("Sanlam"));
        }

        [TestMethod()]
        public async Task GetBenefitMapTest()
        {
            IEnumerable<BenefitMap>? result = await _service.GetBenefitMap();
            result.ShouldContain(o => o.BenefitKnownAs.Equals("Fixed Policy Fee"));
        }

        [TestMethod()]
        public async Task GetUnderwritingRequirementsMapTest()
        {
            IEnumerable<UnderwritingRequirementsMap>? result = await _service.GetUnderwritingRequirementsMap();
            result.ShouldContain(o => o.Description.Equals("Blood Pressure Test (3 BPT)"));
        }

        #region Bank Branches
        [TestMethod()]
        public async Task GetBankBranchesByBankNameTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches("ABSA Bank");
            result.ShouldContain(o => o.BranchName.Equals("CITRUSDAL,K.P."));
            result.ShouldNotContain(o => o.BranchName.Equals("PORT ELIZABETH, K.P."));
        }

        [TestMethod()]
        public async Task GetBankBranchesByBankNameTest_notfound()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches("null Bank");
            result.ShouldBeNull();
        }

        [TestMethod]
        public async Task GetBankBranchesByBankIdAndFilterTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches(10, "K.P.");
            result.ShouldContain(o => o.BranchName.Equals("CITRUSDAL,K.P."));
            result.ShouldNotContain(o => o.BranchName.Equals("PORT ELIZABETH, K.P."));
        }

        [TestMethod]
        public async Task GetBankBranchesByBankIdAndEmptyFilterTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches(10, null);
            result.ShouldContain(o => o.BranchName.Equals("CITRUSDAL,K.P."));
            result.ShouldNotContain(o => o.BranchName.Equals("PORT ELIZABETH, K.P."));
        }

        [TestMethod]
        public async Task GetBankBranchesByBankIdAndInvalidFilterTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches(10, "This is an invalid filter");
            result.ShouldBeEmpty();
        }

        [TestMethod]
        public async Task GetBankBranchesByInvalidBankIdAndValidFilterTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches(1990, "A");
            result.ShouldBeEmpty();
        }

        [TestMethod]
        public async Task GetBankBranchTest()
        {
            BankBranches? result = await _service.GetBankBranch(3012);
            result.BranchName.ShouldBe("CITRUSDAL,K.P.");
        }

        [TestMethod]
        public async Task GetBankBranchTest_notfound()
        {
            BankBranches? result = await _service.GetBankBranch(32767);
            result.ShouldBeNull();
        }

        [TestMethod]
        public async Task GetBankBranchesByBankIdTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches(10);
            result.ShouldContain(o => o.BranchName.Equals("CITRUSDAL,K.P."));
            result.ShouldNotContain(o => o.BranchName.Equals("PORT ELIZABETH, K.P."));
        }

        [TestMethod]
        public async Task GetBankBranchesByInvlidBankIdTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches(32767);
            result.ShouldBeEmpty();
        }

        [TestMethod]
        public async Task GetAllBankBranchesTest()
        {
            IEnumerable<BankBranches>? result = await _service.GetBankBranches();
            result.ShouldContain(o => o.BranchName.Equals("CITRUSDAL,K.P."));
            result.ShouldContain(o => o.BranchName.Equals("PORT ELIZABETH, K.P."));
        }
        #endregion
    }
}