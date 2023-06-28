BEGIN TRAN

IF EXISTS (SELECT NULL FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[BenefitMap]') AND name = 'QuotesIntegrationApi_BenefiCode')
BEGIN
  PRINT 'Renaming column ''QuotesIntegrationApi_BenefiCode'''
	EXEC sp_rename 'dbo.BenefitMap.QuotesIntegrationApi_BenefiCode', 'QuotesIntegrationApi_BenefitCode', 'COLUMN';
END

SELECT * FROM [dbo].[BenefitMap]

IF NOT EXISTS (SELECT NULL FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[BenefitMap]') AND name = 'QuotesIntegrationApi_WaitingPeriod')
BEGIN
  PRINT 'Creating column ''QuotesIntegrationApi_WaitingPeriod'''
	ALTER TABLE
		dbo.BenefitMap
	ADD
		QuotesIntegrationApi_WaitingPeriod NVARCHAR(2) NULL DEFAULT('')
END

SELECT * FROM [dbo].[BenefitMap]

IF NOT EXISTS (SELECT NULL FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[BenefitMap]') AND name = 'QuotesIntegration_ClaimExtender')
BEGIN
  PRINT 'Creating column ''QuotesIntegration_ClaimExtender'''
	ALTER TABLE
		dbo.BenefitMap
	ADD
		QuotesIntegration_ClaimExtender NVARCHAR(1) NOT NULL DEFAULT('')
END

SELECT * FROM [dbo].[BenefitMap]

ROLLBACK

UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='', QuotesIntegration_ClaimExtender='Y' WHERE QuoteOrPolicy_BenefitCode='CILS'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='', QuotesIntegration_ClaimExtender='Y' WHERE QuoteOrPolicy_BenefitCode='CILSA'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='', QuotesIntegration_ClaimExtender='Y' WHERE QuoteOrPolicy_BenefitCode='CILSAFIP'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='', QuotesIntegration_ClaimExtender='Y' WHERE QuoteOrPolicy_BenefitCode='CILSFIP'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='14', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOP14'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='14', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOPFIP14'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='14', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='CI14'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='14', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIP14'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='14', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPFIP14'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='14', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPWOP14'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='3', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='LIADULTNRA3'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='30', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOP30'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='30', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOPFIP30'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='30', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='CI30'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='30', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIP30'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='30', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPFIP30'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='30', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPWOP30'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='7', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOP7'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='7', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOPFIP7'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='7', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='CI7'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='7', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIP7'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='7', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPFIP7'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='7', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPWOP7'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='75', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIP75'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='90', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOP90'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='90', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='BOPFIP90'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='90', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='CI90'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='90', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIP90'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='90', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPFIP90'
UPDATE [dbo].[BenefitMap] SET QuotesIntegrationApi_WaitingPeriod='90', QuotesIntegration_ClaimExtender='' WHERE QuoteOrPolicy_BenefitCode='TIPWOP90'