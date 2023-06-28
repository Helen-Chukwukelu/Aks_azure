using System.Collections.Generic;
using System.Text.Json;

using EntityFrameworkCoreMock;

using Fmi.ReferenceData.Models;

using Microsoft.EntityFrameworkCore;

using ReferenceData.Api.Entities;

namespace ReferenceData.Api.Tests.Mocks
{

    internal static class ReferenceDataDbMock
    {
        private static readonly string _banks_json = "[{\"bankId\": 10,\"bankName\": \"ABSA Bank\",\"displayOrder\": 3,\"bankCode\": \"632005\"},{\"bankId\": 19,\"bankName\": \"African Bank\",\"displayOrder\": 0,\"bankCode\": \"430000\"}]";
        private static readonly string _occupations_json = "[{\"occupationId\": \"3e0429b0-0214-4c18-8906-60a12064ec24\",\"code\": 31804,\"description\": \"Software Engineer\",\"rating\": 4,\"set\": 11,\"manual_Duties\": \"N\",\"event_Class\": \"E1\",\"displayOrder\": 0},{\"occupationId\": \"8bcb41cb-fe61-4694-9352-7e501b6f4898\",\"code\": 31802,\"description\": \"PHP Software Engineer\",\"rating\": 3,\"set\": 11,\"manual_Duties\": \"N\",\"event_Class\": \"E999\",\"displayOrder\": 0},{\"occupationId\": \"c11bd700-3cd7-4037-bf4c-8aae5cd77032\",\"code\": 31188,\"description\": \"Test dummy\",\"rating\": 1,\"set\": 11,\"manual_Duties\": \"N\",\"event_Class\": \"E1\",\"displayOrder\": 0},{\"occupationId\": \"4ee06b7a-b1b3-4524-b2d7-b7d7f738c8e3\",\"code\": 30749,\"description\": \"Accountant\",\"rating\": 1,\"set\": 11,\"manual_Duties\": \"N\",\"event_Class\": \"E1\",\"displayOrder\": 0}]";
        private static readonly string _educationLevels_json = "[{\"id\": 3,\"description\": \"3yr degree\",\"sortOrder\": 5,\"displayOrder\": 0},{\"id\": 7,\"description\": \"3yr diploma or B-Tech\",\"sortOrder\": 4,\"displayOrder\": 0},{\"id\": 4,\"description\": \"4yr + degree\",\"sortOrder\": 6,\"displayOrder\": 0}]";
        private static readonly string _industry_json = "[{\"id\": 2,\"description\": \"Agriculture\",\"displayOrder\": 0},{\"id\": 3,\"description\": \"Agroprocessing\",\"displayOrder\": 0},{\"id\": 1,\"description\": \"Arts,Crafts and Entertainment\",\"displayOrder\": 0}]";
        private static readonly string _nationalities_json = "[{\"nationalityId\": 1,\"nationalityName\": \"Afghan\",\"displayOrder\": 0},{\"nationalityId\": 2,\"nationalityName\": \"Albanian\",\"displayOrder\": 0},{\"nationalityId\": 3,\"nationalityName\": \"Algerian\",\"displayOrder\": 0},{\"nationalityId\": 4,\"nationalityName\": \"American\",\"displayOrder\": 0}]";
        private static readonly string _insuranceCompany_json = "[{\"id\": 5,\"name\": \"Sanlam\",\"displayOrder\": 0},{\"id\": 6,\"name\": \"Hollard\",\"displayOrder\": 0},{\"id\": 7,\"name\": \"PPS\",\"displayOrder\": 0}]";
        private static readonly string _benefitMap_json = "[{\"id\": \"2ece45d5-a205-ec11-b563-281878db514c\",\"benefitCategory\": \"Charges\",\"benefitGroup\": \"Policy Fee\",\"benefitKnownAs\": \"Fixed Policy Fee\",\"quoteOrPolicy_BenefitCode\": \"ADMIN\",\"comboBenefit\": \"N\",\"quotesIntegrationApi_BenefitCode\": \"ADMIN\",\"quotesIntegrationApi_WaitingPeriod\": \"\",\"quotesIntegration_ClaimExtender\": \" \",\"aurA_ProductCode\": \"n/a\",\"aurA_BenefitType\": \"n/a\",\"aurA_SendForOtherFMIPolicies\": \"No\",\"aurA_SendForCurrentDCA\": \"No\",\"relevantAmountField\": \"n/a\"},{\"id\": \"2fce45d5-a205-ec11-b563-281878db514c\",\"benefitCategory\": \"Income Protection\",\"benefitGroup\": \"Business Overhead Protector\",\"benefitKnownAs\": \"Business Overhead Protector - 14 day waiting period\",\"quoteOrPolicy_BenefitCode\": \"BOP14\",\"comboBenefit\": \"N\",\"quotesIntegrationApi_BenefitCode\": \"BOP\",\"quotesIntegrationApi_WaitingPeriod\": \"14\",\"quotesIntegration_ClaimExtender\": \" \",\"aurA_ProductCode\": \"BOP14\",\"aurA_BenefitType\": \"Base\",\"aurA_SendForOtherFMIPolicies\": \"Yes\",\"aurA_SendForCurrentDCA\": \"Yes\",\"relevantAmountField\": \"Cover Amount\"}]";
        private static readonly string _underwritingRequirementsMap_json = "[{\"id\": \"ac79ebbb-6e40-4b1e-aad5-054845ac3b1c\",\"legacyPkMedicalId\": 121,\"description\": \"Blood Pressure Test (3 BPT)\",\"category\": \"Medicals\",\"subCategory\": \"\",\"quoteRequirementCode\": \"\",\"quoteRequirementName\": \"\",\"legacyCode\": \"3BPT\",\"k2Code\": \"3BPT\",\"auraCode\": \"3_BPT\",\"defaultUWType\": \"NURSE\",\"setOops\": true,\"isActive\": false}]";
        private static readonly string _bankbranches_json = "[{\"bankBranchId\":3012,\"bankId\":10,\"branchName\":\"CITRUSDAL,K.P.\",\"branchCode\":\"334411\"},{\"bankBranchId\":3013,\"bankId\":10,\"branchName\":\"BREDASDORP,K.P.\",\"branchCode\":\"334412\"},{\"bankBranchId\":3014,\"bankId\":10,\"branchName\":\"HEIDELBERG,K.P.\",\"branchCode\":\"334413\"},{\"bankBranchId\":3015,\"bankId\":10,\"branchName\":\"WILLOWMORE,K.P.\",\"branchCode\":\"334414\"},{\"bankBranchId\":3016,\"bankId\":10,\"branchName\":\"JOUBERTINA,K.P.\",\"branchCode\":\"334415\"},{\"bankBranchId\":3017,\"bankId\":10,\"branchName\":\"UITENHAGE 3\",\"branchCode\":\"334416\"},{\"bankBranchId\":3018,\"bankId\":10,\"branchName\":\"CAPE ROAD PE\",\"branchCode\":\"334417\"},{\"bankBranchId\":3019,\"bankId\":10,\"branchName\":\"SOMERSET-OOS,K.P.\",\"branchCode\":\"334418\"},{\"bankBranchId\":3020,\"bankId\":10,\"branchName\":\"QUEENSTOWN,K.P.\",\"branchCode\":\"334420\"},{\"bankBranchId\":3347,\"bankId\":19,\"branchName\":\"JOHANNESBURG\",\"branchCode\":\"491005\"},{\"bankBranchId\":3348,\"bankId\":19,\"branchName\":\"PORT ELIZABETH, K.P.\",\"branchCode\":\"491017\"},{\"bankBranchId\":3349,\"bankId\":19,\"branchName\":\"BISHO\",\"branchCode\":\"491019\"},{\"bankBranchId\":3350,\"bankId\":19,\"branchName\":\"QUEENSTOWN\",\"branchCode\":\"491020\"},{\"bankBranchId\":3351,\"bankId\":19,\"branchName\":\"UMTATA\",\"branchCode\":\"491021\"},{\"bankBranchId\":3352,\"bankId\":19,\"branchName\":\"PHUTHADITJHABA\",\"branchCode\":\"491033\"},{\"bankBranchId\":3353,\"bankId\":19,\"branchName\":\"BOTSHABELO\",\"branchCode\":\"491034\"},{\"bankBranchId\":999,\"bankId\":1,\"branchName\":\"MOORREESBURG, C.P.\",\"branchCode\":\"50311\"}]";

        public static ReferenceDataDbContext Create()
        {
            DbContextOptions<ReferenceDataDbContext>? options = new DbContextOptionsBuilder<ReferenceDataDbContext>()
                .UseInMemoryDatabase(databaseName: "InMemoryReferenceDataDatabase")
                .Options;

            var dbContextMock = new DbContextMock<ReferenceDataDbContext>(options);

            var jsonOptions = new JsonSerializerOptions
            {
                DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull,
                PropertyNameCaseInsensitive = true
            };
            jsonOptions.Converters.Add(new System.Text.Json.Serialization.JsonStringEnumConverter());

            DbSetMock<Bank>? banksMock = dbContextMock.CreateDbSetMock(x => x.Banks, JsonSerializer.Deserialize<List<Bank>>(_banks_json, jsonOptions));
            DbSetMock<BankBranches>? bankbranchesMock = dbContextMock.CreateDbSetMock(x => x.BankBranches, JsonSerializer.Deserialize<List<BankBranches>>(_bankbranches_json, jsonOptions));
            DbSetMock<Occupation>? occupationsMock = dbContextMock.CreateDbSetMock(x => x.Occupations, JsonSerializer.Deserialize<List<Occupation>>(_occupations_json, jsonOptions)?.ToArray());
            DbSetMock<EducationLevel>? educationLevelsMock = dbContextMock.CreateDbSetMock(x => x.EducationLevels, JsonSerializer.Deserialize<List<EducationLevel>>(_educationLevels_json, jsonOptions)?.ToArray());
            DbSetMock<Industry>? industryMock = dbContextMock.CreateDbSetMock(x => x.Industry, JsonSerializer.Deserialize<List<Industry>>(_industry_json, jsonOptions)?.ToArray());
            DbSetMock<Nationality>? nationalitiesMock = dbContextMock.CreateDbSetMock(x => x.Nationalities, JsonSerializer.Deserialize<List<Nationality>>(_nationalities_json, jsonOptions)?.ToArray());
            DbSetMock<InsuranceCompany>? insuranceCompanyMock = dbContextMock.CreateDbSetMock(x => x.InsuranceCompany, JsonSerializer.Deserialize<List<InsuranceCompany>>(_insuranceCompany_json, jsonOptions)?.ToArray());
            DbSetMock<BenefitMap>? benefitMapMock = dbContextMock.CreateDbSetMock(x => x.BenefitMap, JsonSerializer.Deserialize<List<BenefitMap>>(_benefitMap_json, jsonOptions)?.ToArray());
            DbSetMock<UnderwritingRequirementsMap>? urmMock = dbContextMock.CreateDbSetMock(x => x.UnderwritingRequirementsMap, JsonSerializer.Deserialize<List<UnderwritingRequirementsMap>>(_underwritingRequirementsMap_json, jsonOptions)?.ToArray());

            dbContextMock.Setup(x => x.Banks).Returns(banksMock.Object);
            dbContextMock.Setup(x => x.BankBranches).Returns(bankbranchesMock.Object);
            dbContextMock.Setup(x => x.Occupations).Returns(occupationsMock.Object);
            dbContextMock.Setup(x => x.EducationLevels).Returns(educationLevelsMock.Object);
            dbContextMock.Setup(x => x.Industry).Returns(industryMock.Object);
            dbContextMock.Setup(x => x.Nationalities).Returns(nationalitiesMock.Object);
            dbContextMock.Setup(x => x.InsuranceCompany).Returns(insuranceCompanyMock.Object);
            dbContextMock.Setup(x => x.BenefitMap).Returns(benefitMapMock.Object);
            dbContextMock.Setup(x => x.UnderwritingRequirementsMap).Returns(urmMock.Object);

            return dbContextMock.Object;

        }

    }
}
