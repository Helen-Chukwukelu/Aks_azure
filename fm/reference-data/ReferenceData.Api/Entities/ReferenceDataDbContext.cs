using System;

using Fmi.ReferenceData.Models;

using Microsoft.EntityFrameworkCore;

namespace ReferenceData.Api.Entities
{
    public partial class ReferenceDataDbContext : DbContext
    {
        public ReferenceDataDbContext()
        {
        }

        public ReferenceDataDbContext(DbContextOptions<ReferenceDataDbContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:Collation", "SQL_Latin1_General_CP1_CI_AS");

            #region Bank
            modelBuilder.Entity<Bank>(entity =>
            {
                entity.HasKey(c => new { c.BankId });

                entity.Property(e => e.BankId).ValueGeneratedNever();

                entity.Property(e => e.BankName)
                    .IsRequired()
                    .HasMaxLength(35)
                    .IsUnicode(false);

                entity.Property(e => e.BankCode)
                    .IsRequired(false)
                    .HasMaxLength(6)
                    .IsUnicode(false);

                entity.Property(e => e.DisplayOrder).HasDefaultValueSql("((0))");
            });
            #endregion

            #region BankBranch
            modelBuilder.Entity<BankBranches>(entity =>
            {
                entity.HasKey(c => new { c.BankBranchId });
            });
            #endregion

            #region BenefitMap
            modelBuilder.Entity<BenefitMap>(entity =>
            {
                entity.ToTable("BenefitMap");

                entity.HasKey(c => new { c.Id });

                entity.Property(e => e.Id).HasDefaultValueSql("(newsequentialid())");

                entity.Property(e => e.AURA_BenefitType)
                    .HasMaxLength(50)
                    .HasColumnName("AURA_BenefitType");

                entity.Property(e => e.AURA_ProductCode)
                    .HasMaxLength(50)
                    .HasColumnName("AURA_ProductCode");

                entity.Property(e => e.AURA_SendForCurrentDCA)
                    .HasMaxLength(50)
                    .HasColumnName("AURA_SendForCurrentDCA");

                entity.Property(e => e.AURA_SendForOtherFMIPolicies)
                    .HasMaxLength(50)
                    .HasColumnName("AURA_SendForOtherFMIPolicies");

                entity.Property(e => e.BenefitCategory).HasMaxLength(150);

                entity.Property(e => e.BenefitGroup).HasMaxLength(255);

                entity.Property(e => e.BenefitKnownAs).HasMaxLength(255);

                entity.Property(e => e.ComboBenefit)
                    .IsRequired()
                    .HasMaxLength(1)
                    .IsFixedLength(true);

                entity.Property(e => e.QuoteOrPolicy_BenefitCode)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("QuoteOrPolicy_BenefitCode");

                entity.Property(e => e.QuotesIntegrationApi_BenefitCode)
                    .HasMaxLength(50)
                    .HasColumnName("QuotesIntegrationApi_BenefitCode");

                entity.Property(e => e.QuotesIntegrationApi_WaitingPeriod)
                    .HasMaxLength(2)
                    .HasColumnName("QuotesIntegrationApi_WaitingPeriod");

                entity.Property(e => e.QuotesIntegration_ClaimExtender)
                    .IsRequired()
                    .HasMaxLength(1)
                    .HasColumnName("QuotesIntegration_ClaimExtender")
                    .IsFixedLength(true);

                entity.Property(e => e.RelevantAmountField).HasMaxLength(150);
            });
            #endregion

            #region EducationLevel
            modelBuilder.Entity<EducationLevel>(entity =>
            {
                entity.ToTable("EducationLevel");

                entity.HasKey(c => new { c.Id });

                entity.Property(e => e.Description).IsRequired();

                entity.Property(e => e.DisplayOrder).HasDefaultValueSql("((0))");
            });
            #endregion

            #region Industry
            modelBuilder.Entity<Industry>(entity =>
            {
                entity.ToTable("Industry");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Description)
              .IsRequired()
              .HasMaxLength(100)
              .IsUnicode(false);

                entity.Property(e => e.DisplayOrder).HasDefaultValueSql("((0))");
            });
            #endregion

            #region InsuranceCompany
            modelBuilder.Entity<InsuranceCompany>(entity =>
            {
                entity.ToTable("InsuranceCompany");

                entity.HasKey(c => new { c.Id });

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.DisplayOrder).HasDefaultValueSql("((0))");

                entity.Property(e => e.Name)
              .IsRequired()
              .HasMaxLength(100)
              .IsUnicode(false);
            });
            #endregion

            #region Nationality
            modelBuilder.Entity<Nationality>(entity =>
            {
                entity.HasKey(c => new { c.NationalityId });

                entity.Property(e => e.DisplayOrder).HasDefaultValueSql("((0))");

                entity.Property(e => e.NationalityName)
              .IsRequired()
              .HasMaxLength(50)
              .IsUnicode(false);
            });
            #endregion

            #region Occupation
            modelBuilder.Entity<Occupation>(entity =>
            {
                entity.HasKey(c => new { c.OccupationId });

                entity.Property(e => e.DisplayOrder).HasDefaultValueSql("((0))");

                entity.Property(e => e.Event_Class).HasColumnName("Event_Class");

                entity.Property(e => e.Manual_Duties).HasColumnName("Manual_Duties");
            });
            #endregion

            #region UnderwritingRequirementsMap
            modelBuilder.Entity<UnderwritingRequirementsMap>(entity =>
            {
                entity.ToTable("UnderwritingRequirementsMap");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.AURACode)
              .IsRequired()
              .HasMaxLength(50)
              .HasColumnName("AURACode");

                entity.Property(e => e.DefaultUWType)
              .IsRequired()
              .HasMaxLength(50)
              .HasColumnName("DefaultUWType");

                entity.Property(e => e.Description)
              .IsRequired()
              .HasMaxLength(255);

                entity.Property(e => e.FilePath)
              .IsRequired()
              .HasMaxLength(255);

                entity.Property(e => e.K2Code)
              .IsRequired()
              .HasMaxLength(50)
              .HasColumnName("K2Code");

                entity.Property(e => e.LegacyCode)
              .IsRequired()
              .HasMaxLength(50);

                entity.Property(e => e.UWTypes)
              .IsRequired()
              .HasMaxLength(1024)
              .HasColumnName("UWTypes")
              .HasConversion(
                  v => string.Join(',', v),
                  v => v.Split(',', StringSplitOptions.RemoveEmptyEntries));
            });
            #endregion

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

        public virtual DbSet<Occupation> Occupations { get; set; }
        public virtual DbSet<EducationLevel> EducationLevels { get; set; }
        public virtual DbSet<Industry> Industry { get; set; }
        public virtual DbSet<Bank> Banks { get; set; }
        public virtual DbSet<BankBranches> BankBranches { get; set; }
        public virtual DbSet<Nationality> Nationalities { get; set; }
        public virtual DbSet<InsuranceCompany> InsuranceCompany { get; set; }
        public virtual DbSet<BenefitMap> BenefitMap { get; set; }
        public virtual DbSet<UnderwritingRequirementsMap> UnderwritingRequirementsMap { get; set; }
    }
}