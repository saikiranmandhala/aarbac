USE [__DBNAME__]
GO
/****** Object:  Table [dbo].[Rbac]    Script Date: 11/6/2017 7:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rbac](
	[RbacId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Description] [varchar](4000) NULL,
	[ConnectionString] [image] NOT NULL,
	[Password] [image] NOT NULL,
	[MetaDataRbac] [image] NOT NULL,
	[MetaDataEntitlements] [image] NULL,
	[Version] [int] NOT NULL,
 CONSTRAINT [PK_Rbac] PRIMARY KEY CLUSTERED 
(
	[RbacId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RbacRole]    Script Date: 11/6/2017 7:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RbacRole](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RbacId] [int] NOT NULL,
	[Name] [varchar](500) NULL,
	[Description] [varchar](5000) NULL,
	[MetaDataRbac] [image] NULL,
	[MetaDataEntitlements] [image] NULL,
	[Version] [int] NULL,
 CONSTRAINT [PK_RbacRole] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RbacUser]    Script Date: 11/6/2017 7:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RbacUser](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](500) NOT NULL,
	[Password] [image] NOT NULL,
	[FullName] [varchar](500) NULL,
	[Email] [varchar](500) NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_RbacUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RbacUserParameter]    Script Date: 11/6/2017 7:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RbacUserParameter](
	[ParameterId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [image] NOT NULL,
	[Value] [image] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_RbacUserParameter] PRIMARY KEY CLUSTERED 
(
	[ParameterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[RbacRole]  WITH CHECK ADD  CONSTRAINT [FK_RbacRole_Rbac] FOREIGN KEY([RbacId])
REFERENCES [dbo].[Rbac] ([RbacId])
GO
ALTER TABLE [dbo].[RbacRole] CHECK CONSTRAINT [FK_RbacRole_Rbac]
GO
ALTER TABLE [dbo].[RbacUser]  WITH CHECK ADD  CONSTRAINT [FK_RbacUser_RbacRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[RbacRole] ([RoleId])
GO
ALTER TABLE [dbo].[RbacUser] CHECK CONSTRAINT [FK_RbacUser_RbacRole]
GO
ALTER TABLE [dbo].[RbacUserParameter]  WITH CHECK ADD  CONSTRAINT [FK_RbacUserParameter_RbacUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[RbacUser] ([UserId])
GO
ALTER TABLE [dbo].[RbacUserParameter] CHECK CONSTRAINT [FK_RbacUserParameter_RbacUser]
GO


CREATE TABLE [dbo].[RbacLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Query] [varchar](max) NOT NULL,
	[ParsedQuery] [varchar](max) NULL,
	[Parsed] [bit] NOT NULL,
	[Errors] [varchar](max) NULL,
	[RoleId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Source] [varchar](2000) NULL,
	[ElapsedTimeParseQuery] [bigint] NULL,
	[ElapsedTimeConditionsNRelations] [bigint] NULL,
	[ElapsedTimeApplyPermission] [bigint] NULL,
	[ElapsedTimeApplyParameters] [bigint] NULL,
 CONSTRAINT [PK_RbacLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[RbacLog]  WITH CHECK ADD  CONSTRAINT [FK_RbacLog_RbacRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[RbacRole] ([RoleId])
GO

ALTER TABLE [dbo].[RbacLog] CHECK CONSTRAINT [FK_RbacLog_RbacRole]
GO

ALTER TABLE [dbo].[RbacLog]  WITH CHECK ADD  CONSTRAINT [FK_RbacLog_RbacUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[RbacUser] ([UserId])
GO

ALTER TABLE [dbo].[RbacLog] CHECK CONSTRAINT [FK_RbacLog_RbacUser]
GO


