USE [master]
GO
CREATE DATABASE [MANTA_MTA] ON  PRIMARY 
( NAME = N'MANTA_MTA', FILENAME = N'c:\SentoriDatabases\MANTA_MTA.mdf' , SIZE = 6400KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MANTA_MTA_log', FILENAME = N'c:\SentoriDatabases\MANTA_MTA_log.LDF' , SIZE = 576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MANTA_MTA] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MANTA_MTA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MANTA_MTA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MANTA_MTA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MANTA_MTA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MANTA_MTA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MANTA_MTA] SET ARITHABORT OFF 
GO
ALTER DATABASE [MANTA_MTA] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MANTA_MTA] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MANTA_MTA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MANTA_MTA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MANTA_MTA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MANTA_MTA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MANTA_MTA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MANTA_MTA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MANTA_MTA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MANTA_MTA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MANTA_MTA] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MANTA_MTA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MANTA_MTA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MANTA_MTA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MANTA_MTA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MANTA_MTA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MANTA_MTA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MANTA_MTA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MANTA_MTA] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MANTA_MTA] SET  MULTI_USER 
GO
ALTER DATABASE [MANTA_MTA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MANTA_MTA] SET DB_CHAINING OFF 
GO
USE [MANTA_MTA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_cfg_localDomain](
	[cfg_localDomain_id] [int] IDENTITY(1,1) NOT NULL,
	[cfg_localDomain_domain] [nvarchar](255) NOT NULL,
	[cfg_localDomain_name] [nvarchar](50) NULL,
	[cfg_localDomain_description] [nvarchar](250) NULL,
 CONSTRAINT [PK_man_cfg_localDomain] PRIMARY KEY CLUSTERED 
(
	[cfg_localDomain_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_cfg_para](
	[cfg_para_dropFolder] [nvarchar](255) NOT NULL,
	[cfg_para_queueFolder] [nvarchar](255) NOT NULL,
	[cfg_para_logFolder] [nvarchar](255) NOT NULL,
	[cfg_para_listenPorts] [nvarchar](255) NOT NULL,
	[cfg_para_retryIntervalMinutes] [int] NOT NULL,
	[cfg_para_maxTimeInQueueMinutes] [int] NOT NULL,
	[cfg_para_defaultIpGroupId] [int] NOT NULL,
	[cfg_para_clientIdleTimeout] [int] NOT NULL,
	[cfg_para_receiveTimeout] [int] NOT NULL,
	[cfg_para_sendTimeout] [int] NOT NULL,
	[cfg_para_returnPathDomain_id] [int] NOT NULL,
	[cfg_para_maxDaysToKeepSmtpLogs] [int] NOT NULL,
	[cfg_para_eventForwardingHttpPostUrl] [nvarchar](max) NOT NULL,
	[cfg_para_keepBounceFilesFlag] [bit] NOT NULL,
	[cfg_para_rabbitMqEnabled] [bit] NOT NULL,
	[cfg_para_rabbitMqUsername] [nvarchar](max) NOT NULL,
	[cfg_para_rabbitMqPassword] [nvarchar](max) NOT NULL,
	[cfg_para_rabbitMqHostname] [nvarchar](max) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_cfg_relayingPermittedIp](
	[cfg_relayingPermittedIp_ip] [varchar](45) NOT NULL,
	[cfg_relayingPermittedIp_name] [nvarchar](50) NULL,
	[cfg_relayingPermittedIp_description] [nvarchar](250) NULL,
 CONSTRAINT [PK_man_cfg_relayingPermittedIps] PRIMARY KEY CLUSTERED 
(
	[cfg_relayingPermittedIp_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_evn_bounceCode](
	[evn_bounceCode_id] [int] NOT NULL,
	[evn_bounceCode_name] [nvarchar](50) NOT NULL,
	[evn_bounceCode_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_evn_bounceEvent](
	[evn_event_id] [int] NOT NULL,
	[evn_bounceCode_id] [int] NOT NULL,
	[evn_bounceType_id] [int] NOT NULL,
	[evn_bounceEvent_message] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_man_evn_bounceEvent] PRIMARY KEY CLUSTERED 
(
	[evn_event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_evn_bounceRule](
	[evn_bounceRule_id] [int] NOT NULL,
	[evn_bounceRule_name] [nvarchar](50) NOT NULL,
	[evn_bounceRule_description] [nvarchar](250) NULL,
	[evn_bounceRule_executionOrder] [int] NOT NULL,
	[evn_bounceRule_isBuiltIn] [bit] NOT NULL,
	[evn_bounceRuleCriteriaType_id] [int] NOT NULL,
	[evn_bounceRule_criteria] [nvarchar](max) NOT NULL,
	[evn_bounceRule_mantaBounceType] [int] NOT NULL,
	[evn_bounceRule_mantaBounceCode] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_evn_bounceRuleCriteriaType](
	[evn_bounceRuleCriteriaType_id] [int] NOT NULL,
	[evn_bounceRuleCriteriaType_name] [nvarchar](50) NOT NULL,
	[evn_bounceRuleCriteriaType_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_evn_bounceType](
	[evn_bounceType_id] [int] NOT NULL,
	[evn_bounceType_name] [nvarchar](50) NOT NULL,
	[evn_bounceType_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_evn_event](
	[evn_event_id] [int] IDENTITY(1,1) NOT NULL,
	[evn_type_id] [int] NOT NULL,
	[evn_event_timestamp] [datetime] NOT NULL,
	[evn_event_emailAddress] [nvarchar](320) NOT NULL,
	[snd_send_id] [nvarchar](20) NOT NULL,
	[evn_event_forwarded] [bit] NOT NULL,
 CONSTRAINT [PK_man_evn_bounce] PRIMARY KEY CLUSTERED 
(
	[evn_event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_evn_type](
	[evn_type_id] [int] NOT NULL,
	[evn_type_name] [nvarchar](50) NOT NULL,
	[evn_type_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_ip_group](
	[ip_group_id] [int] IDENTITY(1,1) NOT NULL,
	[ip_group_name] [nvarchar](50) NOT NULL,
	[ip_group_description] [nvarchar](250) NULL,
 CONSTRAINT [PK_man_ip_group] PRIMARY KEY CLUSTERED 
(
	[ip_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_ip_groupMembership](
	[ip_group_id] [int] NOT NULL,
	[ip_ipAddress_id] [int] NOT NULL,
 CONSTRAINT [PK_man_ip_groupMembership] PRIMARY KEY CLUSTERED 
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
CREATE TABLE [dbo].[man_ip_ipAddress](
	[ip_ipAddress_id] [int] IDENTITY(1,1) NOT NULL,
	[ip_ipAddress_ipAddress] [varchar](45) NOT NULL,
	[ip_ipAddress_hostname] [varchar](255) NULL,
	[ip_ipAddress_isInbound] [bit] NULL,
	[ip_ipAddress_isOutbound] [bit] NULL,
 CONSTRAINT [PK_man_ip_ipAddress_id] PRIMARY KEY CLUSTERED 
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
CREATE TABLE [dbo].[man_mta_fblAddress](
	[mta_fblAddress_address] [nvarchar](320) NOT NULL,
	[mta_fblAddress_name] [nvarchar](50) NOT NULL,
	[mta_fblAddress_description] [nvarchar](250) NULL,
 CONSTRAINT [PK_man_mta_fblAddress] PRIMARY KEY CLUSTERED 
(
	[mta_fblAddress_address] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_mta_msg](
	[mta_msg_id] [uniqueidentifier] NOT NULL,
	[mta_send_internalId] [int] NOT NULL,
	[mta_msg_rcptTo] [nvarchar](max) NOT NULL,
	[mta_msg_mailFrom] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_man_mta_msg] PRIMARY KEY NONCLUSTERED 
(
	[mta_msg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_mta_queue](
	[mta_msg_id] [uniqueidentifier] NOT NULL,
	[mta_queue_queuedTimestamp] [datetime] NOT NULL,
	[mta_queue_attemptSendAfter] [datetime] NOT NULL,
	[mta_queue_isPickupLocked] [bit] NOT NULL,
	[mta_queue_dataPath] [nvarchar](max) NOT NULL,
	[ip_group_id] [int] NOT NULL,
	[mta_send_internalId] [int] NOT NULL,
 CONSTRAINT [PK_man_mta_queue] PRIMARY KEY CLUSTERED 
(
	[mta_msg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_mta_send](
	[mta_send_internalId] [int] NOT NULL,
	[mta_send_id] [nvarchar](20) NOT NULL,
	[mta_sendStatus_id] [int] NOT NULL,
	[mta_send_createdTimestamp] [datetime] NOT NULL,
	[mta_send_messages] [int] NOT NULL,
	[mta_send_accepted] [int] NOT NULL,
	[mta_send_rejected] [int] NOT NULL,
 CONSTRAINT [PK_man_mta_send] PRIMARY KEY CLUSTERED 
(
	[mta_send_internalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[man_mta_sendMeta](
	[mta_send_internalId] [int] NOT NULL,
	[mta_sendMeta_name] [nvarchar](max) NOT NULL,
	[mta_sendMeta_value] [nvarchar](max) NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_man_mta_sendMeta] ON [dbo].[man_mta_sendMeta] 
(
	[mta_send_internalId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_mta_sendStatus](
	[mta_sendStatus_id] [int] NOT NULL,
	[mta_sendStatus_name] [nvarchar](50) NOT NULL,
	[mta_sendStatus_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_mta_transaction](
	[mta_msg_id] [uniqueidentifier] NOT NULL,
	[ip_ipAddress_id] [int] NULL,
	[mta_transaction_timestamp] [datetime] NOT NULL,
	[mta_transactionStatus_id] [int] NOT NULL,
	[mta_transaction_serverResponse] [nvarchar](max) NOT NULL,
	[mta_transaction_serverHostname] [nvarchar](max) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_mta_transactionStatus](
	[mta_transactionStatus_id] [int] NOT NULL,
	[mta_transactionStatus_name] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_rle_mxPattern](
	[rle_mxPattern_id] [int] IDENTITY(1,1) NOT NULL,
	[rle_mxPattern_name] [nvarchar](50) NOT NULL,
	[rle_mxPattern_description] [nvarchar](250) NULL,
	[rle_patternType_id] [int] NOT NULL,
	[rle_mxPattern_value] [nvarchar](250) NOT NULL,
	[ip_ipAddress_id] [int] NULL,
 CONSTRAINT [PK_man_rle_mxPattern] PRIMARY KEY CLUSTERED 
(
	[rle_mxPattern_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_rle_patternType](
	[rle_patternType_id] [int] NOT NULL,
	[rle_patternType_name] [nvarchar](50) NOT NULL,
	[rle_patternType_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[man_rle_rule](
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
CREATE TABLE [dbo].[man_rle_ruleType](
	[rle_ruleType_id] [int] NOT NULL,
	[rle_ruleType_name] [nvarchar](50) NOT NULL,
	[rle_ruleType_description] [nvarchar](250) NULL
) ON [PRIMARY]

GO
CREATE CLUSTERED INDEX [IX_man_mta_transaction] ON [dbo].[man_mta_transaction]
(
	[mta_msg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [BounceGroupingIndex] ON [dbo].[man_mta_transaction]
(
	[mta_transactionStatus_id] ASC
)
INCLUDE ( 	[mta_msg_id],
	[ip_ipAddress_id],
	[mta_transaction_timestamp],
	[mta_transaction_serverResponse],
	[mta_transaction_serverHostname]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [mta_msg_id] ON [dbo].[man_mta_msg] 
(
	[mta_msg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SendInternalID] ON [dbo].[man_mta_msg] 
(
	[mta_send_internalId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [AttemptSendAfter] ON [dbo].[man_mta_queue] 
(
	[mta_queue_attemptSendAfter] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141117-122722] ON [dbo].[man_mta_queue] 
(
	[mta_queue_attemptSendAfter] ASC,
	[mta_queue_isPickupLocked] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[man_evn_event] ADD  CONSTRAINT [DF_man_evn_event_evn_event_forwarded]  DEFAULT ((0)) FOR [evn_event_forwarded]
GO
ALTER TABLE [dbo].[man_mta_send] ADD  CONSTRAINT [DF_man_mta_send_mta_send_messages]  DEFAULT ((0)) FOR [mta_send_messages]
GO
ALTER TABLE [dbo].[man_mta_send] ADD  CONSTRAINT [DF_man_mta_send_mta_send_accepted]  DEFAULT ((0)) FOR [mta_send_accepted]
GO
ALTER TABLE [dbo].[man_mta_send] ADD  CONSTRAINT [DF_man_mta_send_mta_send_rejected]  DEFAULT ((0)) FOR [mta_send_rejected]
GO
USE [master]
GO
ALTER DATABASE [MANTA_MTA] SET  READ_WRITE 
GO
