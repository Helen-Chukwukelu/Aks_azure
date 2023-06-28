IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UnderwritingRequirementsMap]') AND type in (N'U'))
DROP TABLE [dbo].[UnderwritingRequirementsMap]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UnderwritingRequirementsMap](
	[Id] [uniqueidentifier] NOT NULL,
	[LegacyPkMedicalId] [int] NULL,
	[Description] [nvarchar](255) NOT NULL,
	[LegacyCode] [nvarchar](50) NOT NULL,
	[K2Code] [nvarchar](50) NOT NULL,
	[AURACode] [nvarchar](50) NOT NULL,
	[QuoteRequirementCode] [nvarchar](50) NOT NULL,
	[QuoteRequirementName] [nvarchar](255) NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
	[SubCategory] [nvarchar](255) NOT NULL,
	[FilePath] [nvarchar](255) NOT NULL,
	[HalfCostsApply] [bit] NOT NULL,
	[UWTypes] [nvarchar](1024) NOT NULL,
	[DefaultUWType] [nvarchar](50) NOT NULL,
	[SetOops] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_UnderwritingRequirementsMap] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/* *****************************************************
 * The API would populate the data if the table is empty
/* *****************************************************
