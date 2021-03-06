
/****** Object:  Table [dbo].[aspnet_starterkits_Projects]    Script Date: 11/8/2004 9:21:34 PM ******/
CREATE TABLE [dbo].[aspnet_starterkits_Projects] (
	[ProjectId] [int] IDENTITY (1, 1) NOT NULL ,
	[ProjectName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProjectDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProjectCreationDate] [datetime] NOT NULL ,
	[ProjectDisabled] [bit] NOT NULL ,
	[ProjectEstimateDuration] [decimal](18, 0) NOT NULL ,
	[ProjectCompletionDate] [datetime] NOT NULL ,
	[ProjectCreatorId] [uniqueidentifier] NOT NULL ,
	[ProjectManagerId] [uniqueidentifier] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[aspnet_starterkits_ProjectCategories]    Script Date: 11/8/2004 9:21:35 PM ******/
CREATE TABLE [dbo].[aspnet_starterkits_ProjectCategories] (
	[CategoryId] [int] IDENTITY (1, 1) NOT NULL ,
	[CategoryName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProjectId] [int] NOT NULL ,
	[ParentCategoryId] [int] NULL ,
	[CategoryAbbreviation] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CategoryEstimateDuration] [decimal](18, 0) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[aspnet_starterkits_ProjectMembers]    Script Date: 11/8/2004 9:21:35 PM ******/
CREATE TABLE [dbo].[aspnet_starterkits_ProjectMembers] (
	[UserId] [uniqueidentifier] NOT NULL ,
	[ProjectId] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[aspnet_starterkits_TimeEntry]    Script Date: 11/8/2004 9:21:35 PM ******/
CREATE TABLE [dbo].[aspnet_starterkits_TimeEntry] (
	[TimeEntryId] [int] IDENTITY (1, 1) NOT NULL ,
	[TimeEntryCreated] [datetime] NOT NULL ,
	[TimeEntryDuration] [decimal](18, 0) NOT NULL ,
	[TimeEntryDescription] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CategoryId] [int] NOT NULL ,
	[TimeEntryDate] [datetime] NULL ,
	[TimeEntryCreatorId] [uniqueidentifier] NOT NULL ,
	[TimeEntryUserId] [uniqueidentifier] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[aspnet_starterkits_Projects] WITH NOCHECK ADD 
	CONSTRAINT [PK_IssueTracker_Projects] PRIMARY KEY  CLUSTERED 
	(
		[ProjectId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[aspnet_starterkits_ProjectCategories] WITH NOCHECK ADD 
	CONSTRAINT [PK_IssueTracker_ProjectCategories] PRIMARY KEY  CLUSTERED 
	(
		[CategoryId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[aspnet_starterkits_ProjectMembers] WITH NOCHECK ADD 
	CONSTRAINT [PK_aspnet_starterkits_ProjectMembers] PRIMARY KEY  CLUSTERED 
	(
		[UserId],
		[ProjectId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[aspnet_starterkits_TimeEntry] WITH NOCHECK ADD 
	CONSTRAINT [PK_TimeTracker_TimeEntry] PRIMARY KEY  CLUSTERED 
	(
		[TimeEntryId]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[aspnet_starterkits_Projects] ADD 
	CONSTRAINT [DF_IssueTracker_Projects_ProjectCreationDate] DEFAULT (getdate()) FOR [ProjectCreationDate],
	CONSTRAINT [DF_IssueTracker_Projects_ProjectDisabled] DEFAULT (0) FOR [ProjectDisabled],
	CONSTRAINT [DF_IssueTracker_Projects_ProjectDuration] DEFAULT (0) FOR [ProjectEstimateDuration],
	CONSTRAINT [DF_IssueTracker_Projects_ProjectCompletionDate] DEFAULT (getdate()) FOR [ProjectCompletionDate]
GO

 CREATE  UNIQUE  INDEX [UniqueProjectName] ON [dbo].[aspnet_starterkits_Projects]([ProjectName]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[aspnet_starterkits_ProjectCategories] ADD 
	CONSTRAINT [DF_IssueTracker_ProjectCategories_ParentCategoryId] DEFAULT (0) FOR [ParentCategoryId],
	CONSTRAINT [DF_IssueTracker_ProjectCategories_CategoryEstimateDuration] DEFAULT (0) FOR [CategoryEstimateDuration]
GO

 CREATE  UNIQUE  INDEX [UniqueNamePerProject] ON [dbo].[aspnet_starterkits_ProjectCategories]([CategoryName], [ProjectId]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[aspnet_starterkits_TimeEntry] ADD 
	CONSTRAINT [DF_TimeTracker_TimeEntry_TimeEntryEntered] DEFAULT (getdate()) FOR [TimeEntryCreated],
	CONSTRAINT [DF_TimeTracker_TimeEntry_TimeEntryDuration] DEFAULT (0) FOR [TimeEntryDuration],
	CONSTRAINT [DF_TimeTracker_TimeEntry_CategoryId] DEFAULT (0) FOR [CategoryId]
GO

 CREATE  INDEX [CategoryIDIndex] ON [dbo].[aspnet_starterkits_TimeEntry]([CategoryId]) ON [PRIMARY]
GO

 CREATE  INDEX [CreatorId] ON [dbo].[aspnet_starterkits_TimeEntry]([TimeEntryCreatorId]) ON [PRIMARY]
GO

 CREATE  INDEX [EntryUserId] ON [dbo].[aspnet_starterkits_TimeEntry]([TimeEntryUserId]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[aspnet_starterkits_Projects] ADD 
	CONSTRAINT [FK_IssueTracker_Projects_aspnet_Users] FOREIGN KEY 
	(
		[ProjectCreatorId]
	) REFERENCES [dbo].[aspnet_Users] (
		[UserId]
	),
	CONSTRAINT [FK_IssueTracker_Projects_aspnet_Users1] FOREIGN KEY 
	(
		[ProjectManagerId]
	) REFERENCES [dbo].[aspnet_Users] (
		[UserId]
	)
GO

ALTER TABLE [dbo].[aspnet_starterkits_ProjectCategories] ADD 
	CONSTRAINT [FK_IssueTracker_ProjectCategories_IssueTracker_Projects] FOREIGN KEY 
	(
		[ProjectId]
	) REFERENCES [dbo].[aspnet_starterkits_Projects] (
		[ProjectId]
	)
GO

ALTER TABLE [dbo].[aspnet_starterkits_ProjectMembers] ADD 
	CONSTRAINT [FK_IssueTracker_ProjectMembers_aspnet_Users] FOREIGN KEY 
	(
		[UserId]
	) REFERENCES [dbo].[aspnet_Users] (
		[UserId]
	),
	CONSTRAINT [FK_IssueTracker_ProjectMembers_IssueTracker_Projects] FOREIGN KEY 
	(
		[ProjectId]
	) REFERENCES [dbo].[aspnet_starterkits_Projects] (
		[ProjectId]
	)
GO

ALTER TABLE [dbo].[aspnet_starterkits_TimeEntry] ADD 
	CONSTRAINT [FK_TimeTracker_TimeEntry_aspnet_Users] FOREIGN KEY 
	(
		[TimeEntryUserId]
	) REFERENCES [dbo].[aspnet_Users] (
		[UserId]
	),
	CONSTRAINT [FK_TimeTracker_TimeEntry_IssueTracker_ProjectCategories] FOREIGN KEY 
	(
		[CategoryId]
	) REFERENCES [dbo].[aspnet_starterkits_ProjectCategories] (
		[CategoryId]
	)
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_CreateNewProject    Script Date: 11/8/2004 9:21:35 PM ******/








CREATE       PROCEDURE aspnet_starterkits_CreateNewProject
 @ProjectCreatorUserName  NVARCHAR(256),
 @ProjectCompletionDate		DATETIME,
 @ProjectDescription 	  NVARCHAR(1000),
 @ProjectEstimateDuration DECIMAL,
 @ProjectManagerUserName  NVARCHAR(256),
 @ProjectName		  NVARCHAR(256)

AS
DECLARE @ProjectCreatorId UNIQUEIDENTIFIER 
SELECT @ProjectCreatorId = UserId FROM aspnet_users WHERE Username = @ProjectCreatorUserName
DECLARE @ProjectManagerId UNIQUEIDENTIFIER
SELECT @ProjectManagerId = UserId FROM aspnet_users WHERE Username = @ProjectManagerUserName

IF NOT EXISTS( SELECT ProjectId  FROM aspnet_starterkits_Projects WHERE LOWER(ProjectName) = LOWER(@ProjectName))
BEGIN
	INSERT aspnet_starterkits_Projects 
	(
		ProjectCreatorId,
		ProjectCompletionDate,
		ProjectDescription,
		ProjectEstimateDuration,
		ProjectManagerId,
		ProjectName
	) 
	VALUES
	(
		@ProjectCreatorId,		
		@ProjectCompletionDate,
		@ProjectDescription,
		@ProjectEstimateDuration,
		@ProjectManagerId,
		@ProjectName
	)
 RETURN @@IDENTITY
END
ELSE
 RETURN 1









GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_DeleteProject    Script Date: 11/8/2004 9:21:35 PM ******/





CREATE PROCEDURE aspnet_starterkits_DeleteProject
	@ProjectIdToDelete	INT
AS
UPDATE aspnet_starterkits_Projects SET ProjectDisabled = 1 WHERE ProjectId = @ProjectIdToDelete




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_UpdateProject    Script Date: 11/8/2004 9:21:35 PM ******/








CREATE     PROCEDURE aspnet_starterkits_UpdateProject
 @ProjectId		 Int,
 @ProjectCompletionDate DATETIME,
 @ProjectDescription 	  NVARCHAR(1000),
 @ProjectEstimateDuration DECIMAL,
 @ProjectManagerUserName  NVARCHAR(256),
 @ProjectName		  NVARCHAR(256)
AS
DECLARE @ProjectIdFound INT
SELECT @ProjectIdFound = ProjectId  FROM aspnet_starterkits_Projects WHERE ProjectId = @ProjectId
IF (@ProjectIdFound IS NOT NULL)
BEGIN
	DECLARE @ProjectManagerId UNIQUEIDENTIFIER
	SELECT @ProjectManagerId = UserId FROM aspnet_users WHERE Username = @ProjectManagerUserName

	UPDATE aspnet_starterkits_Projects SET
		ProjectCompletionDate=@ProjectCompletionDate,
		ProjectDescription = @ProjectDescription,
		ProjectEstimateDuration=@ProjectEstimateDuration,
		ProjectManagerId =@ProjectManagerId,
		ProjectName = @ProjectName
	WHERE
		ProjectId = @ProjectId
	RETURN 0
END
ELSE
	RETURN 1







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_AddUserToProject    Script Date: 11/8/2004 9:21:35 PM ******/







CREATE   PROCEDURE aspnet_starterkits_AddUserToProject
  @MemberUserName NVARCHAR (256),	
	@ProjectId Int 
AS
DECLARE @UserId UNIQUEIDENTIFIER
SELECT @UserId = UserId
	FROM aspnet_users 
where lower(UserName) = lower(@MemberUserName)

IF NOT EXISTS (SELECT UserId FROM aspnet_starterkits_ProjectMembers WHERE UserId = @UserId AND ProjectId = @ProjectId)
BEGIN
	INSERT aspnet_starterkits_ProjectMembers
	(
		UserId,
		ProjectId
	)
	VALUES
	(
		@UserId,
		@ProjectId
	)
/* RETURN @@IDENTITY*/
END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_CreateNewCategory    Script Date: 11/8/2004 9:21:35 PM ******/









CREATE     PROCEDURE aspnet_starterkits_CreateNewCategory
  @CategoryName NVARCHAR(256),
  @ProjectId INT,
/*  @ParentCategoryId INT,*/
  @CategoryAbbreviation  NVARCHAR(256),
  @CategoryEstimateDuration DECIMAL
AS
IF NOT EXISTS(SELECT CategoryId FROM aspnet_starterkits_ProjectCategories WHERE ProjectId = @ProjectId AND CategoryName = @CategoryName /*AND ParentCategoryId = @ParentCategoryId*/)
BEGIN
	INSERT aspnet_starterkits_ProjectCategories
	(
		CategoryName,
		ProjectId,
	/*	ParentCategoryId,*/
		CategoryAbbreviation,
		CategoryEstimateDuration
	)
	VALUES
	(
		@CategoryName,
		@ProjectId,
		/*@ParentCategoryId,*/
		@CategoryAbbreviation,
		@CategoryEstimateDuration
	)
	RETURN @@IDENTITY
END








GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_DeleteCategory    Script Date: 11/8/2004 9:21:35 PM ******/





CREATE PROCEDURE aspnet_starterkits_DeleteCategory
	@CategoryIdToDelete Int
AS
DELETE 
	aspnet_starterkits_ProjectCategories
WHERE
	CategoryId = @CategoryIdToDelete




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetProjectMember    Script Date: 11/8/2004 9:21:35 PM ******/






CREATE  PROCEDURE aspnet_starterkits_GetProjectMember
	@ProjectId INT 
AS

SELECT
 Members.UserName
From 
 aspnet_starterkits_ProjectMembers
INNER JOIN aspnet_users Members ON aspnet_starterkits_ProjectMembers.UserId = Members.UserId
WHERE
 ProjectId=@ProjectId
SET QUOTED_IDENTIFIER OFF 





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_RemoveUserFromProject    Script Date: 11/8/2004 9:21:35 PM ******/

CREATE    PROCEDURE aspnet_starterkits_RemoveUserFromProject
  @UserName NVARCHAR (256),	
	@ProjectId Int 
AS
DECLARE @UserId UNIQUEIDENTIFIER
SELECT @UserId = UserId
	FROM aspnet_users 
where lower(UserName) = lower(@UserName)

delete from aspnet_starterkits_ProjectMembers where UserId=@UserId AND ProjectId=@ProjectId



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_UpdateCategories    Script Date: 11/8/2004 9:21:35 PM ******/











CREATE      PROCEDURE aspnet_starterkits_UpdateCategories
 @CategoryId		 	INT,
 @CategoryAbbreviation 	  	NVARCHAR(1000),
 @CategoryEstimateDuration 	DECIMAL,
 @CategoryName  		NVARCHAR(256),
 @ProjectId			INT
AS
DECLARE @CategoryIdFound INT
SELECT @CategoryIdFound = CategoryId  FROM aspnet_starterkits_ProjectCategories WHERE CategoryId = @CategoryId
IF (@CategoryIdFound IS NOT NULL)
BEGIN
	UPDATE aspnet_starterkits_ProjectCategories SET
		CategoryAbbreviation = @CategoryAbbreviation,
		CategoryEstimateDuration=@CategoryEstimateDuration,
		CategoryName =@CategoryName,
		ProjectId = @ProjectId
	WHERE
		CategoryId = @CategoryId
	RETURN 0
END
ELSE
	RETURN 1










GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_CreateNewTimeEntry    Script Date: 11/8/2004 9:21:35 PM ******/







CREATE           PROCEDURE aspnet_starterkits_CreateNewTimeEntry
 @CategoryId		    INT,
 @TimeEntryCreatorUserName  NVARCHAR(256),
 @TimeEntryDescription      NVARCHAR(1000),
 @TimeEntryEstimateDuration DECIMAL,
 @TimeEntryEnteredDate	    DATETIME,
 @TimeEntryUserName         NVARCHAR(256)
AS
DECLARE @TimeEntryCreatorId UNIQUEIDENTIFIER 
DECLARE @TimeEntryUserId UNIQUEIDENTIFIER 

SELECT @TimeEntryCreatorId = UserId FROM aspnet_users WHERE Username = @TimeEntryCreatorUserName
SELECT @TimeEntryUserId = UserId FROM aspnet_users WHERE Username = @TimeEntryUserName

IF EXISTS( SELECT categoryid  FROM aspnet_starterkits_ProjectCategories WHERE CategoryId=@CategoryId)
BEGIN
	INSERT  aspnet_starterkits_TimeEntry 
	(
		TimeEntryDuration,
		TimeEntryDescription,
		CategoryId,
		TimeEntryCreatorId,
		TimeEntryDate,
		TimeEntryUserId
	) 
	VALUES
	(
		@TimeEntryEstimateDuration,	
		@TimeEntryDescription,
		@CategoryId,
		@TimeEntryCreatorId,
		@TimeEntryEnteredDate,
		@TimeEntryUserId
	)
 RETURN @@IDENTITY
END
ELSE
 RETURN 1









GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_DeleteTimeEntry    Script Date: 11/8/2004 9:21:35 PM ******/








CREATE   PROCEDURE aspnet_starterkits_DeleteTimeEntry
	@TimeentryIdToDelete Int
AS
DELETE 
	aspnet_starterkits_TimeEntry 
WHERE
	TimeEntryId = @TimeentryIdToDelete







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetAllCategories    Script Date: 11/8/2004 9:21:35 PM ******/





CREATE    PROCEDURE aspnet_starterkits_GetAllCategories
AS
SELECT
	category.*,
	sum (TimeEntryDuration) as CategoryActualDuration
FROM 
	aspnet_starterkits_ProjectCategories  as category
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON category.CategoryId = timeEntry.CategoryId
GROUP BY 
 category.CategoryId,
 category.CategoryName,
 category.ParentCategoryId,
 category.ProjectId,
 category.CategoryAbbreviation,
 category.CategoryEstimateDuration

ORDER BY
 category.CategoryId ASC







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetAllProjects    Script Date: 11/8/2004 9:21:35 PM ******/











CREATE      PROCEDURE aspnet_starterkits_GetAllProjects
AS
SELECT
	
	aspnet_starterkits_Projects.*,
	Managers.UserName ProjectManagerDisplayName,
	Creators.UserName ProjectCreatorDisplayName,
	sum (TimeEntryDuration) as ProjectActualDuration
FROM 
	aspnet_starterkits_Projects 
	INNER JOIN aspnet_users AS Managers ON Managers.UserId = aspnet_starterkits_Projects.ProjectManagerId	
	INNER JOIN aspnet_users AS Creators ON Creators.UserId = aspnet_starterkits_Projects.ProjectCreatorId	
	LEFT JOIN aspnet_starterkits_Projectcategories AS cat ON aspnet_starterkits_Projects.ProjectId= cat.ProjectId
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON cat.CategoryId = timeEntry.CategoryId
WHERE
	ProjectDisabled = 0
group by 
	aspnet_starterkits_Projects.ProjectId,
	aspnet_starterkits_Projects.ProjectName,
	aspnet_starterkits_Projects.ProjectDescription,
	aspnet_starterkits_Projects.ProjectCreationDate,
	aspnet_starterkits_Projects.ProjectDisabled,
	aspnet_starterkits_Projects.ProjectEstimateDuration,
	aspnet_starterkits_Projects.ProjectCompletionDate,
	aspnet_starterkits_Projects.ProjectCreatorId,
	aspnet_starterkits_Projects.ProjectManagerId,
	Managers.UserName,
	Creators.UserName

ORDER BY 
	ProjectName ASC










GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetAllTimeEntriesByProjectIdandUser    Script Date: 11/8/2004 9:21:35 PM ******/









CREATE       PROCEDURE aspnet_starterkits_GetAllTimeEntriesByProjectIdandUser
 @ProjectId int,
 @TimeEntryUserName nvarchar(256)
AS

DECLARE @TimeEntryUserId UNIQUEIDENTIFIER
SELECT @TimeEntryUserId = UserId FROM aspnet_users WHERE UserName = @TimeEntryUserName

SELECT	
	aspnet_starterkits_TimeEntry.*,
	Creators.UserName TimeEntryCreatorDisplayName,
	TEUserName.UserName TimeEntryUserName
FROM 
	aspnet_starterkits_TimeEntry 
	INNER JOIN aspnet_users AS Creators ON Creators.UserId = aspnet_starterkits_TimeEntry.TimeEntryCreatorId	
	INNER JOIN aspnet_users AS TEUserName ON TEUserName.UserId = aspnet_starterkits_TimeEntry.TimeEntryCreatorId	
	INNER JOIN aspnet_starterkits_ProjectCategories AS Category ON Category.CategoryId = aspnet_starterkits_TimeEntry.CategoryId
WHERE
	aspnet_starterkits_TimeEntry.TimeEntryUserId = @TimeEntryUserId AND
	Category.ProjectId = @ProjectId

ORDER BY 
	TimeEntryId ASC








GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetAllTimeEntriesByProjectIdandUserAndDate    Script Date: 11/8/2004 9:21:35 PM ******/









CREATE  PROCEDURE aspnet_starterkits_GetAllTimeEntriesByProjectIdandUserAndDate
 @TimeEntryUserName nvarchar(256),
 @StartingDate 		datetime,
 @EndDate		datetime
AS

DECLARE @TimeEntryUserId UNIQUEIDENTIFIER
SELECT @TimeEntryUserId = UserId FROM aspnet_users WHERE UserName = @TimeEntryUserName

SELECT	
	aspnet_starterkits_TimeEntry.*,
	Creators.UserName TimeEntryCreatorDisplayName,
	TEUserName.UserName TimeEntryUserName
FROM 
	aspnet_starterkits_TimeEntry 
	INNER JOIN aspnet_users AS Creators ON Creators.UserId = aspnet_starterkits_TimeEntry.TimeEntryCreatorId	
	INNER JOIN aspnet_users AS TEUserName ON TEUserName.UserId = aspnet_starterkits_TimeEntry.TimeEntryCreatorId	
WHERE
	aspnet_starterkits_TimeEntry.TimeEntryUserId = @TimeEntryUserId 
	AND
	aspnet_starterkits_TimeEntry.TimeEntryDate BETWEEN  @StartingDate And @EndDate
ORDER BY 
	TimeEntryId ASC






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetCategoriesByProjectId    Script Date: 11/8/2004 9:21:35 PM ******/






CREATE      PROCEDURE aspnet_starterkits_GetCategoriesByProjectId
	@ProjectId Int 
AS
SELECT
	category.*,
	sum (TimeEntryDuration) as CategoryActualDuration
FROM 
	aspnet_starterkits_ProjectCategories  as category
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON category.CategoryId = timeEntry.CategoryId
WHERE
	ProjectId = @ProjectId

GROUP BY 
 category.CategoryId,
 category.CategoryName,
 category.ParentCategoryId,
 category.ProjectId,
 category.CategoryAbbreviation,
 category.CategoryEstimateDuration

ORDER BY
 category.CategoryId ASC







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetCategoryById    Script Date: 11/8/2004 9:21:35 PM ******/




CREATE    PROCEDURE aspnet_starterkits_GetCategoryById
	@CategoryId Int 
AS
SELECT
	category.*,
	sum (TimeEntryDuration) as CategoryActualDuration
FROM 
	aspnet_starterkits_ProjectCategories  as category
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON category.CategoryId = timeEntry.CategoryId
WHERE
	category.CategoryId = @CategoryId
GROUP BY 
 category.CategoryId,
 category.CategoryName,
 category.ParentCategoryId,
 category.ProjectId,
 category.CategoryAbbreviation,
 category.CategoryEstimateDuration

ORDER BY
	CategoryName






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetCategoryByNameAndProjectId    Script Date: 11/8/2004 9:21:35 PM ******/





CREATE    PROCEDURE aspnet_starterkits_GetCategoryByNameAndProjectId
	@CategoryName nvarchar(256),
	@ProjectId	int 
AS
SELECT
	category.*,
	sum (TimeEntryDuration) as CategoryActualDuration
FROM 
	aspnet_starterkits_ProjectCategories  as category
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON category.CategoryId = timeEntry.CategoryId
WHERE
	category.CategoryName = @CategoryName and 
	category.ProjectId = @ProjectId
GROUP BY 
 category.CategoryId,
 category.CategoryName,
 category.ParentCategoryId,
 category.ProjectId,
 category.CategoryAbbreviation,
 category.CategoryEstimateDuration

ORDER BY
	CategoryName







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetProjectById    Script Date: 11/8/2004 9:21:35 PM ******/










CREATE      PROCEDURE aspnet_starterkits_GetProjectById
 @ProjectId INT
AS
SELECT
	
	aspnet_starterkits_Projects.*,
	Managers.UserName ProjectManagerDisplayName,
	Creators.UserName ProjectCreatorDisplayName,
	sum (TimeEntryDuration) as ProjectActualDuration
FROM 
	aspnet_starterkits_Projects 
	INNER JOIN aspnet_users AS Managers ON Managers.UserId = aspnet_starterkits_Projects.ProjectManagerId	
	INNER JOIN aspnet_users AS Creators ON Creators.UserId = aspnet_starterkits_Projects.ProjectCreatorId	
	LEFT JOIN aspnet_starterkits_Projectcategories AS cat ON aspnet_starterkits_Projects.ProjectId= cat.ProjectId
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON cat.CategoryId = timeEntry.CategoryId
WHERE
	aspnet_starterkits_Projects.ProjectId = @ProjectId 
	AND ProjectDisabled = 0

group by 
	aspnet_starterkits_Projects.ProjectId,
	aspnet_starterkits_Projects.ProjectName,
	aspnet_starterkits_Projects.ProjectDescription,
	aspnet_starterkits_Projects.ProjectCreationDate,
	aspnet_starterkits_Projects.ProjectDisabled,
	aspnet_starterkits_Projects.ProjectEstimateDuration,
	aspnet_starterkits_Projects.ProjectCompletionDate,
	aspnet_starterkits_Projects.ProjectCreatorId,
	aspnet_starterkits_Projects.ProjectManagerId,
	Managers.UserName,
	Creators.UserName

ORDER BY 
	ProjectName ASC







GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetProjectByManagerUserName    Script Date: 11/8/2004 9:21:35 PM ******/









CREATE    PROCEDURE aspnet_starterkits_GetProjectByManagerUserName
	@ProjectManagerUserName NVarChar(255) 
AS
DECLARE @UserId UNIQUEIDENTIFIER
SELECT @UserId = UserId FROM aspnet_users WHERE Username = @ProjectManagerUserName

SELECT
	
	aspnet_starterkits_Projects.*,
	Managers.UserName ProjectManagerDisplayName,
	Creators.UserName ProjectCreatorDisplayName,
	sum (TimeEntryDuration) as ProjectActualDuration
FROM 
	aspnet_starterkits_Projects 
	INNER JOIN aspnet_users AS Managers ON Managers.UserId = aspnet_starterkits_Projects.ProjectManagerId	
	INNER JOIN aspnet_users AS Creators ON Creators.UserId = aspnet_starterkits_Projects.ProjectCreatorId	
	LEFT JOIN aspnet_starterkits_Projectcategories AS cat ON aspnet_starterkits_Projects.ProjectId= cat.ProjectId
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON cat.CategoryId = timeEntry.CategoryId
WHERE
	aspnet_starterkits_Projects.ProjectManagerId = @UserId
	AND ProjectDisabled = 0

group by 
	aspnet_starterkits_Projects.ProjectId,
	aspnet_starterkits_Projects.ProjectName,
	aspnet_starterkits_Projects.ProjectDescription,
	aspnet_starterkits_Projects.ProjectCreationDate,
aspnet_starterkits_Projects.ProjectDisabled,
aspnet_starterkits_Projects.ProjectEstimateDuration,
aspnet_starterkits_Projects.ProjectCompletionDate,
aspnet_starterkits_Projects.ProjectCreatorId,
aspnet_starterkits_Projects.ProjectManagerId,
Managers.UserName,
Creators.UserName


ORDER BY 
	ProjectName ASC








GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetProjectByUserName    Script Date: 11/8/2004 9:21:35 PM ******/



CREATE     PROCEDURE aspnet_starterkits_GetProjectByUserName
	@UserName NVarChar(255) 
AS
DECLARE @UserId UNIQUEIDENTIFIER
SELECT @UserId = UserId FROM aspnet_users WHERE Username = @UserName

SELECT
	
	aspnet_starterkits_Projects.*,
	Managers.UserName ProjectManagerDisplayName,
	Creators.UserName ProjectCreatorDisplayName,
	sum (TimeEntryDuration) as ProjectActualDuration
FROM 
	aspnet_starterkits_Projects 
	INNER JOIN aspnet_users AS Managers ON Managers.UserId = aspnet_starterkits_Projects.ProjectManagerId	
	INNER JOIN aspnet_users AS Creators ON Creators.UserId = aspnet_starterkits_Projects.ProjectCreatorId	
	INNER JOIN aspnet_starterkits_ProjectMembers AS Members ON 	aspnet_starterkits_Projects.ProjectId = Members.ProjectId
	LEFT JOIN aspnet_starterkits_Projectcategories AS cat ON aspnet_starterkits_Projects.ProjectId= cat.ProjectId
	left JOIN aspnet_starterkits_TimeEntry as timeEntry 	ON cat.CategoryId = timeEntry.CategoryId
WHERE
	Members.UserId =@UserId
	AND ProjectDisabled = 0

group by 
	aspnet_starterkits_Projects.ProjectId,
	aspnet_starterkits_Projects.ProjectName,
	aspnet_starterkits_Projects.ProjectDescription,
	aspnet_starterkits_Projects.ProjectCreationDate,
aspnet_starterkits_Projects.ProjectDisabled,
aspnet_starterkits_Projects.ProjectEstimateDuration,
aspnet_starterkits_Projects.ProjectCompletionDate,
aspnet_starterkits_Projects.ProjectCreatorId,
aspnet_starterkits_Projects.ProjectManagerId,
Managers.UserName,
Creators.UserName


ORDER BY 
	ProjectName ASC










GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetTimeEntryById    Script Date: 11/8/2004 9:21:35 PM ******/










create PROCEDURE aspnet_starterkits_GetTimeEntryById
 @TimeEntryId int
AS

SELECT	
	aspnet_starterkits_TimeEntry.*,
	Creators.UserName TimeEntryCreatorDisplayName,
	TEUserName.UserName TimeEntryUserName
FROM 
	aspnet_starterkits_TimeEntry 
	INNER JOIN aspnet_users AS Creators ON Creators.UserId = aspnet_starterkits_TimeEntry.TimeEntryCreatorId	
	INNER JOIN aspnet_users AS TEUserName ON TEUserName.UserId = aspnet_starterkits_TimeEntry.TimeEntryCreatorId	
WHERE
	aspnet_starterkits_TimeEntry.TimeEntryId = @TimeEntryId 




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetTimeEntryUserReport    Script Date: 11/8/2004 9:21:35 PM ******/




create PROCEDURE aspnet_starterkits_GetTimeEntryUserReport
 @ProjectId Int 
AS 
SELECT
 category.categoryId AS CategoryId, 
 Users.UserName AS UserName,
 SUM  (timeentryDuration) AS Duration
FROM
 aspnet_starterkits_TimeEntry AS timeEntry
 INNER JOIN aspnet_starterkits_ProjectCategories AS category 	ON category.CategoryId = timeEntry.CategoryId
 INNER JOIN aspnet_users AS Users ON timeEntry.TimeEntryUserId=Users.UserId
WHERE 
 category.ProjectId = @ProjectId 
GROUP BY
category.categoryId,
 Users.UserName
ORDER BY 
 category.categoryId




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetTimeEntryUserReportByCategoryId    Script Date: 11/8/2004 9:21:35 PM ******/





Create  PROCEDURE aspnet_starterkits_GetTimeEntryUserReportByCategoryId
 @CategoryId Int 
AS 
SELECT
 category.categoryId AS CategoryId, 
 Users.UserName AS UserName,
 SUM  (timeentryDuration) AS Duration
FROM
 aspnet_starterkits_TimeEntry AS timeEntry
 INNER JOIN aspnet_starterkits_ProjectCategories AS category 	ON category.CategoryId = timeEntry.CategoryId
 INNER JOIN aspnet_users AS Users ON timeEntry.TimeEntryUserId=Users.UserId
WHERE 
 category.categoryId =@CategoryId  
GROUP BY
category.categoryId,
 Users.UserName
ORDER BY 
 category.categoryId





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_GetTimeEntryUserReportByUser    Script Date: 11/8/2004 9:21:35 PM ******/








CREATE     PROCEDURE aspnet_starterkits_GetTimeEntryUserReportByUser
 @UserName NVARCHAR(256)
AS 
DECLARE @UserId AS UNIQUEIDENTIFIER

SELECT @UserId=UserId FROM aspnet_users WHERE UserName=@UserName

SELECT
 @UserName as UserName,
 SUM  (timeentryDuration) AS TotalDuration
FROM
 aspnet_starterkits_TimeEntry 
WHERE 
 aspnet_starterkits_TimeEntry.TimeEntryUserId=@UserId





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.aspnet_starterkits_UpdateTimeEntry    Script Date: 11/8/2004 9:21:35 PM ******/








CREATE           PROCEDURE aspnet_starterkits_UpdateTimeEntry
 @CategoryId		    INT,
 @TimeEntryId		    INT,
 @TimeEntryDescription      NVARCHAR(1000),
 @TimeEntryEstimateDuration DECIMAL,
 @TimeEntryEnteredDate	    DATETIME,
 @TimeEntryUserName         NVARCHAR(256)
AS

DECLARE @TimeEntryUserId UNIQUEIDENTIFIER 
SELECT @TimeEntryUserId = UserId FROM aspnet_users WHERE Username = @TimeEntryUserName

IF EXISTS( SELECT categoryid  FROM aspnet_starterkits_ProjectCategories WHERE CategoryId=@CategoryId)
BEGIN
UPDATE aspnet_starterkits_TimeEntry SET
		TimeEntryDuration=@TimeEntryEstimateDuration,
		TimeEntryDescription=@TimeEntryDescription,
		CategoryId=@CategoryId,
		TimeEntryDate=@TimeEntryEnteredDate,
		TimeEntryUserId=@TimeEntryUserId
	WHERE
		TimeEntryId = @TimeEntryId
	RETURN 0
END
ELSE
 RETURN 1










GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

