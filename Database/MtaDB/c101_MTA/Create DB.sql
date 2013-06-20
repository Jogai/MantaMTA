USE [master]
GO
CREATE DATABASE [C101_MTA] ON  PRIMARY 
( NAME = N'C101_MTA', FILENAME = N'c:\SentoriDatabases\C101_MTA.mdf' , SIZE = 2304KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'C101_MTA_log', FILENAME = N'c:\SentoriDatabases\C101_MTA_log.LDF' , SIZE = 576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [C101_MTA] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [C101_MTA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [C101_MTA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [C101_MTA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [C101_MTA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [C101_MTA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [C101_MTA] SET ARITHABORT OFF 
GO
ALTER DATABASE [C101_MTA] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [C101_MTA] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [C101_MTA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [C101_MTA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [C101_MTA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [C101_MTA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [C101_MTA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [C101_MTA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [C101_MTA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [C101_MTA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [C101_MTA] SET  ENABLE_BROKER 
GO
ALTER DATABASE [C101_MTA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [C101_MTA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [C101_MTA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [C101_MTA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [C101_MTA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [C101_MTA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [C101_MTA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [C101_MTA] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [C101_MTA] SET  MULTI_USER 
GO
ALTER DATABASE [C101_MTA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [C101_MTA] SET DB_CHAINING OFF 
GO
USE [C101_MTA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_cfg_localDomain](
	[cfg_localDomain_domain] [nvarchar](255) NOT NULL,
	[cfg_localDomain_name] [nvarchar](50) NULL,
	[cfg_localDomain_description] [nvarchar](250) NULL,
 CONSTRAINT [PK_c101_cfg_localDomain] PRIMARY KEY CLUSTERED 
(
	[cfg_localDomain_domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_cfg_para](
	[cfg_para_dropFolder] [nvarchar](255) NOT NULL,
	[cfg_para_queueFolder] [nvarchar](255) NOT NULL,
	[cfg_para_logFolder] [nvarchar](255) NOT NULL,
	[cfg_para_listenPorts] [nvarchar](255) NOT NULL,
	[cfg_para_retryIntervalMinutes] [int] NOT NULL,
	[cfg_para_maxTimeInQueueMinutes] [int] NOT NULL,
	[cfg_para_defaultIpGroupId] [int] NOT NULL,
	[cfg_para_clientIdleTimeout] [int] NOT NULL,
	[cfg_para_receiveTimeout] [int] NOT NULL,
	[cfg_para_sendTimeout] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_cfg_relayingPermittedIp](
	[cfg_relayingPermittedIp_ip] [varchar](45) NOT NULL,
	[cfg_relayingPermittedIp_name] [nvarchar](50) NULL,
	[cfg_relayingPermittedIp_description] [nvarchar](250) NULL,
 CONSTRAINT [PK_c101_cfg_relayingPermittedIps] PRIMARY KEY CLUSTERED 
(
	[cfg_relayingPermittedIp_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_ip_group](
	[ip_group_id] [int] NOT NULL,
	[ip_group_name] [nvarchar](50) NOT NULL,
	[ip_group_description] [nvarchar](250) NULL,
 CONSTRAINT [PK_c101_ip_group] PRIMARY KEY CLUSTERED 
(
	[ip_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_ip_groupMembership](
	[ip_group_id] [int] NOT NULL,
	[ip_ipAddress_id] [int] NOT NULL,
 CONSTRAINT [PK_c101_ip_groupMembership] PRIMARY KEY CLUSTERED 
(
	[ip_group_id] ASC,
	[ip_ipAddress_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_ip_ipAddress](
	[ip_ipAddress_id] [int] NOT NULL,
	[ip_ipAddress_ipAddress] [varchar](45) NOT NULL,
	[ip_ipAddress_hostname] [varchar](255) NULL,
	[ip_ipAddress_isInbound] [bit] NULL,
	[ip_ipAddress_isOutbound] [bit] NULL,
 CONSTRAINT [PK_c101_ip_ipAddress_id] PRIMARY KEY CLUSTERED 
(
	[ip_ipAddress_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_c101_ip_ipAddress_ipAddress] UNIQUE NONCLUSTERED 
(
	[ip_ipAddress_ipAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_mta_msg](
	[mta_msg_id] [uniqueidentifier] NOT NULL,
	[mta_send_internalId] [int] NOT NULL,
	[mta_msg_rcptTo] [nvarchar](max) NOT NULL,
	[mta_msg_mailFrom] [nvarchar](max) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_mta_queue](
	[mta_msg_id] [uniqueidentifier] NOT NULL,
	[mta_queue_queuedTimestamp] [datetime] NOT NULL,
	[mta_queue_attemptSendAfter] [datetime] NOT NULL,
	[mta_queue_isPickupLocked] [bit] NOT NULL,
	[mta_queue_dataPath] [nvarchar](max) NOT NULL,
	[ip_group_id] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_mta_send](
	[mta_send_internalId] [int] NOT NULL,
	[mta_send_id] [nvarchar](20) NULL,
 CONSTRAINT [PK_c101_mta_send] PRIMARY KEY CLUSTERED 
(
	[mta_send_internalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_mta_transaction](
	[mta_msg_id] [uniqueidentifier] NOT NULL,
	[mta_transaction_timestamp] [datetime] NOT NULL,
	[mta_transactionStatus_id] [int] NOT NULL,
	[mta_transaction_serverResponse] [nvarchar](max) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_mta_transactionStatus](
	[mta_transactionStatus_id] [int] NOT NULL,
	[mta_transactionStatus_name] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_rle_mxPattern](
	[rle_mxPattern_id] [int] NOT NULL,
	[rle_mxPattern_name] [nvarchar](50) NOT NULL,
	[rle_mxPattern_description] [nvarchar](250) NULL,
	[rle_patternType_id] [int] NOT NULL,
	[rle_mxPattern_value] [nvarchar](250) NOT NULL,
	[ip_ipAddress_id] [int] NULL,
 CONSTRAINT [PK_c101_rle_mxPattern] PRIMARY KEY CLUSTERED 
(
	[rle_mxPattern_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_rle_patternType](
	[rle_patternType_id] [int] NOT NULL,
	[rle_patternType_name] [nvarchar](50) NOT NULL,
	[rle_patternType_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_rle_rule](
	[rle_mxPattern_id] [int] NOT NULL,
	[rle_ruleType_id] [int] NOT NULL,
	[rle_rule_value] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_sm_rle_rule] PRIMARY KEY CLUSTERED 
(
	[rle_mxPattern_id] ASC,
	[rle_ruleType_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[c101_rle_ruleType](
	[rle_ruleType_id] [int] NOT NULL,
	[rle_ruleType_name] [nvarchar](50) NOT NULL,
	[rle_ruleType_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [C101_MTA] SET  READ_WRITE 
GO
