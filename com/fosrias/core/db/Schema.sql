USE [master]
GO
/****** Object:  Database [Content Manager]    Script Date: 10/03/2010 16:56:08 ******/
CREATE DATABASE [Content Manager] ON  PRIMARY 
( NAME = N'Content Manager', FILENAME = N'G:\Microsoft SQL Server\Default Instance\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\Content Manager.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Content Manager_log', FILENAME = N'G:\Microsoft SQL Server\Default Instance\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\Content Manager_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Content Manager] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Content Manager].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Content Manager] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [Content Manager] SET ANSI_NULLS OFF
GO
ALTER DATABASE [Content Manager] SET ANSI_PADDING OFF
GO
ALTER DATABASE [Content Manager] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [Content Manager] SET ARITHABORT OFF
GO
ALTER DATABASE [Content Manager] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [Content Manager] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [Content Manager] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [Content Manager] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [Content Manager] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [Content Manager] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [Content Manager] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [Content Manager] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [Content Manager] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [Content Manager] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [Content Manager] SET  DISABLE_BROKER
GO
ALTER DATABASE [Content Manager] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [Content Manager] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [Content Manager] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [Content Manager] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [Content Manager] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [Content Manager] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [Content Manager] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [Content Manager] SET  READ_WRITE
GO
ALTER DATABASE [Content Manager] SET RECOVERY FULL
GO
ALTER DATABASE [Content Manager] SET  MULTI_USER
GO
ALTER DATABASE [Content Manager] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [Content Manager] SET DB_CHAINING OFF
GO
USE [Content Manager]
GO
/****** Object:  Table [dbo].[sites]    Script Date: 10/03/2010 16:56:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sites](
	[id] [bigint] IDENTITY(10000001,1) NOT NULL,
	[url] [varchar](250) NOT NULL,
	[title] [varchar](50) NOT NULL,
	[description] [text] NOT NULL,
	[tags] [text] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
 CONSTRAINT [PK_sites] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[site_items_buffer]    Script Date: 10/03/2010 16:56:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[site_items_buffer](
	[id] [bigint] NOT NULL,
	[lft] [bigint] NOT NULL,
	[rgt] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[site_items]    Script Date: 10/03/2010 16:56:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[site_items](
	[id] [bigint] IDENTITY(100000001,1) NOT NULL,
	[parent_id] [bigint] NULL,
	[lft] [int] NOT NULL,
	[rgt] [int] NOT NULL,
	[content_id] [bigint] NOT NULL,
	[type] [varchar](max) NOT NULL,
	[sort_order] [int] NOT NULL,
	[url_fragment] [varchar](max) NOT NULL,
	[browser_title] [varchar](max) NULL,
	[name] [varchar](max) NOT NULL,
	[description] [varchar](max) NOT NULL,
	[tags] [varchar](max) NULL,
	[is_active] [bit] NOT NULL,
	[is_menu_item] [bit] NOT NULL,
	[menu_separator] [varchar](6) NOT NULL,
	[is_deleted] [bit] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
 CONSTRAINT [PK_site_items] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[site_item_types]    Script Date: 10/03/2010 16:56:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[site_item_types](
	[code] [varchar](10) NOT NULL,
	[label] [varchar](50) NOT NULL,
	[sort_order] [int] NOT NULL,
 CONSTRAINT [PK_site_item_types] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[site_item_contents]    Script Date: 10/03/2010 16:56:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[site_item_contents](
	[id] [bigint] IDENTITY(10000001,1) NOT NULL,
	[site_item_id] [bigint] NOT NULL,
	[text] [varchar](max) NULL,
	[is_html_format] [bit] NOT NULL,
	[link] [varchar](max) NULL,
	[file_name] [varchar](max) NULL,
	[file_location] [varchar](max) NULL,
	[file_type] [varchar](max) NULL,
	[file_size] [int] NULL,
	[file_content] [varbinary](max) NULL,
	[revision] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[inheritance_type] [varchar](max) NOT NULL,
 CONSTRAINT [PK_site_item_contents] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF_sites_tags]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[sites] ADD  CONSTRAINT [DF_sites_tags]  DEFAULT ('') FOR [tags]
GO
/****** Object:  Default [DF_site_items_lft]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_items] ADD  CONSTRAINT [DF_site_items_lft]  DEFAULT ((0)) FOR [lft]
GO
/****** Object:  Default [DF_site_items_rgt]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_items] ADD  CONSTRAINT [DF_site_items_rgt]  DEFAULT ((0)) FOR [rgt]
GO
/****** Object:  Default [DF_site_items_content_id]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_items] ADD  CONSTRAINT [DF_site_items_content_id]  DEFAULT ((0)) FOR [content_id]
GO
/****** Object:  Default [DF_site_items_isActive]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_items] ADD  CONSTRAINT [DF_site_items_isActive]  DEFAULT ((0)) FOR [is_active]
GO
/****** Object:  Default [DF_site_items_isMenuItem]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_items] ADD  CONSTRAINT [DF_site_items_isMenuItem]  DEFAULT ((0)) FOR [is_menu_item]
GO
/****** Object:  Default [DF_site_items_menuSeparator]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_items] ADD  CONSTRAINT [DF_site_items_menuSeparator]  DEFAULT ('NONE') FOR [menu_separator]
GO
/****** Object:  Default [DF_site_items_is_deleted]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_items] ADD  CONSTRAINT [DF_site_items_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
/****** Object:  Default [DF_site_item_types_sort_order]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_item_types] ADD  CONSTRAINT [DF_site_item_types_sort_order]  DEFAULT ((0)) FOR [sort_order]
GO
/****** Object:  Default [DF_site_item_contents_site_item_id]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_item_contents] ADD  CONSTRAINT [DF_site_item_contents_site_item_id]  DEFAULT ((0)) FOR [site_item_id]
GO
/****** Object:  Default [DF_site_item_contents_is_html_format]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_item_contents] ADD  CONSTRAINT [DF_site_item_contents_is_html_format]  DEFAULT ((0)) FOR [is_html_format]
GO
/****** Object:  Default [DF_site_item_contents_revision]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_item_contents] ADD  CONSTRAINT [DF_site_item_contents_revision]  DEFAULT ((1)) FOR [revision]
GO
/****** Object:  Default [DF_site_item_contents_inheritance_type]    Script Date: 10/03/2010 16:56:09 ******/
ALTER TABLE [dbo].[site_item_contents] ADD  CONSTRAINT [DF_site_item_contents_inheritance_type]  DEFAULT ('BASE') FOR [inheritance_type]
GO
