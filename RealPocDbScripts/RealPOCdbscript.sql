IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'realpoc') BEGIN EXEC('CREATE SCHEMA realpoc') END
GO 




---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------FUNCTIONS-------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------




IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'FUNCTION' AND ROUTINE_NAME='GET_SUBSTRING_BY_INDEX') DROP FUNCTION realpoc.GET_SUBSTRING_BY_INDEX
GO
CREATE FUNCTION realpoc.GET_SUBSTRING_BY_INDEX(@full_string nvarchar(max), @substring_index int, @split_string nvarchar(100)) RETURNS nvarchar(max)
AS
BEGIN
	DECLARE			@i			int,
					@index 		int,
					@substring		nvarchar(max)

	IF ISNULL(@full_string, '') = '' OR @substring_index <= 0 RETURN NULL
	SET @i = 1

	WHILE @i <= @substring_index
	BEGIN
		SET @full_string= LTRIM(@full_string)
		IF ISNULL(@full_string, '') = '' RETURN NULL

		SET @index  = CHARINDEX(@split_string , @full_string)
		IF @index  = 0 SELECT @substring = @full_string, @full_string = ''
		ELSE 	    SELECT @substring = SUBSTRING(@full_string, 1, @index -1), @full_string = SUBSTRING(@full_string, @index +LEN(@substring_index), 100000)
		IF @i = @substring_index RETURN @substring
		SET @i = @i + 1
	END

	RETURN NULL
END
GO



IF EXISTS (SELECT table_name FROM information_schema.views WHERE  table_schema = 'realpoc' AND table_name = 'random_val_view') DROP VIEW realpoc.random_val_view 
GO
CREATE VIEW realpoc.random_val_view
AS
SELECT RAND() as  random_value
GO


IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'FUNCTION' AND ROUTINE_NAME='GET_RANDOM_INT') DROP FUNCTION realpoc.GET_RANDOM_INT
GO
CREATE FUNCTION realpoc.GET_RANDOM_INT(@Lower int, @Upper int) RETURNS nvarchar(max)
AS
BEGIN
		---- Create the variables for the random number generation
		DECLARE @Random INT;
		SET @Random=0;
		SELECT @Random = ROUND(((@Upper - @Lower) * (select random_value from realpoc.random_val_view) + @Lower), 0)
		RETURN @Random
END
GO





---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------FUNCTIONS END-----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------



--Drop all tables
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_offer') DROP TABLE realpoc.property_offer
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'offer_category') DROP TABLE realpoc.offer_category
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_subcategory') DROP TABLE realpoc.property_subcategory
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_category') DROP TABLE realpoc.property_category
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_heating_type') DROP TABLE realpoc.property_heating_type
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_heating_medium') DROP TABLE realpoc.property_heating_medium
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_location') DROP TABLE realpoc.property_location




--Create Tables and Insert Seed Data
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------TABLES AND SEED DATA START----------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'offer_category') DROP TABLE realpoc.offer_category
GO
CREATE TABLE realpoc.offer_category (
	id				int				NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	descr			nvarchar(100)	NOT NULL,
);
GO

DELETE realpoc.offer_category
SET IDENTITY_INSERT realpoc.offer_category ON
GO
INSERT  realpoc.offer_category(id,descr) SELECT 1,'Sale'
INSERT  realpoc.offer_category(id,descr) SELECT 2,'Rent'
SET IDENTITY_INSERT realpoc.offer_category OFF
GO


IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_category') DROP TABLE realpoc.property_category
GO
CREATE TABLE realpoc.property_category (
	id				int				NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	descr			nvarchar(100)	NOT NULL,
);
GO

DELETE realpoc.property_category
SET IDENTITY_INSERT realpoc.property_category ON
GO
INSERT  realpoc.property_category(id,descr) SELECT 1,'Residential'
INSERT  realpoc.property_category(id,descr) SELECT 2,'Commercial'
INSERT  realpoc.property_category(id,descr) SELECT 3,'Land'
INSERT  realpoc.property_category(id,descr) SELECT 4,'Other Properties'
SET IDENTITY_INSERT realpoc.property_category OFF
GO



IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_subcategory') DROP TABLE realpoc.property_subcategory
GO
CREATE TABLE realpoc.property_subcategory (
	id				int				NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	category_id		int				NOT NULL    REFERENCES realpoc.property_category(id),
	descr			nvarchar(100)	NOT NULL,
);
GO

DELETE realpoc.property_subcategory
SET IDENTITY_INSERT realpoc.property_subcategory ON
GO
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 1,1,'Flat'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 2,1,'Villa'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 3,1,'Studio'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 4,2,'Office'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 5,2,'Store'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 6,3,'Plot'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 7,3,'Parcel'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 8,4,'Parking'
INSERT  realpoc.property_subcategory(id,category_id,descr) SELECT 9,4,'Business'
SET IDENTITY_INSERT realpoc.property_subcategory OFF
GO




IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_heating_type') DROP TABLE realpoc.property_heating_type
GO
CREATE TABLE realpoc.property_heating_type (
	id				int				NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	descr			nvarchar(100)	NOT NULL,
);
GO

DELETE realpoc.property_heating_type
SET IDENTITY_INSERT realpoc.property_heating_type ON
GO
INSERT  realpoc.property_heating_type(id,descr) SELECT 1,'Autonomous'
INSERT  realpoc.property_heating_type(id,descr) SELECT 2,'Central'
INSERT  realpoc.property_heating_type(id,descr) SELECT 3,'None'
INSERT  realpoc.property_heating_type(id,descr) SELECT 4,'Any'
SET IDENTITY_INSERT realpoc.property_heating_type OFF
GO

IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_heating_medium') DROP TABLE realpoc.property_heating_medium
GO
CREATE TABLE realpoc.property_heating_medium (
	id				int				NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	descr			nvarchar(100)	NOT NULL,
);
GO

DELETE realpoc.property_heating_medium
SET IDENTITY_INSERT realpoc.property_heating_medium ON
GO
INSERT  realpoc.property_heating_medium(id,descr) SELECT 1,'Gas'
INSERT  realpoc.property_heating_medium(id,descr) SELECT 2,'Petrol'
INSERT  realpoc.property_heating_medium(id,descr) SELECT 3,'Air Condition'
INSERT  realpoc.property_heating_medium(id,descr) SELECT 4,'Any'
SET IDENTITY_INSERT realpoc.property_heating_medium OFF
GO



IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_location') DROP TABLE realpoc.property_location
GO
CREATE TABLE realpoc.property_location (
	id						int				NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	code					nvarchar(50)	NOT NULL	UNIQUE, --00001.00000.00000.00000
	full_descr			    AS ISNULL(level4_descr+',','')+ ISNULL(level3_descr+',','') +ISNULL(level2_descr+',','') +ISNULL(level1_descr,''),
	level1_descr			nvarchar(100)	NULL,
	level2_descr			nvarchar(100)	NULL,
	level3_descr			nvarchar(100)	NULL,
	level4_descr			nvarchar(100)	NULL,
	level1_code				nvarchar(100)   NULL,
	level2_code				nvarchar(100)   NULL,
	level3_code				nvarchar(100)   NULL,
	level4_code				nvarchar(100)   NULL
);
GO

--Level1 --Attica
--Level2 --Attica Contains (Athens Center,Athens West,Athens North,Athens East,Piraeus,Rest Attica,Argosaronikos Islands)
--Level3 --Athens Center Contains (Exarchia,Ampelokipoi,Goudi etc)
--Level4 --Ampelokipoi Contains (Ampelokipoi,Panormou,Pyrgos,Erythros,Elinoroson)

DELETE realpoc.property_location
SET IDENTITY_INSERT realpoc.property_location ON
GO
INSERT realpoc.property_location (id,code,level1_descr,level2_descr,level3_descr,level4_descr)
SELECT		 1,'00001.00000.00000.00000','Attica',NULL,NULL,NULL
UNION SELECT 2,'00001.00001.00000.00000','Attica','Athens Center',NULL,NULL
UNION SELECT 3,'00001.00002.00000.00000','Attica','Athens West',NULL,NULL
UNION SELECT 4,'00001.00003.00000.00000','Attica','Athens North',NULL,NULL
UNION SELECT 5,'00001.00004.00000.00000','Attica','Athens East',NULL,NULL
UNION SELECT 6,'00001.00001.00001.00000','Attica','Athens Center','Exarchia',NULL
UNION SELECT 7,'00001.00001.00002.00000','Attica','Athens Center','Ampelokipoi',NULL
UNION SELECT 8,'00001.00001.00003.00000','Attica','Athens Center','Kaisariani',NULL
UNION SELECT 9,'00001.00001.00004.00000','Attica','Athens Center','Goudi',NULL
UNION SELECT 10,'00001.00001.00002.00001','Attica','Athens Center','Ampelokipoi','Center'
UNION SELECT 11,'00001.00001.00002.00002','Attica','Athens Center','Ampelokipoi','Panormou'
UNION SELECT 12,'00001.00001.00002.00003','Attica','Athens Center','Ampelokipoi','Pyrgos'
UNION SELECT 13,'00001.00001.00002.00004','Attica','Athens Center','Ampelokipoi','Erythros'
UNION SELECT 14,'00001.00001.00002.00005','Attica','Athens Center','Ampelokipoi','Elinoroson'
UNION SELECT 15,'00002.00000.00000.00000','Thessaloniki',NULL,NULL,NULL
UNION SELECT 16,'00002.00001.00000.00000','Thessaloniki','Rest',NULL,NULL
UNION SELECT 17,'00002.00002.00000.00000','Thessaloniki','Suburbs',NULL,NULL
UNION SELECT 18,'00002.00003.00000.00000','Thessaloniki','Center',NULL,NULL
UNION SELECT 19,'00002.00003.00001.00000','Thessaloniki','Center','Vardaris',NULL
UNION SELECT 20,'00002.00003.00002.00000','Thessaloniki','Center','Toumpa',NULL
UNION SELECT 21,'00002.00003.00003.00000','Thessaloniki','Center','Lefkos Pirgos',NULL
UNION SELECT 22,'00002.00003.00004.00000','Thessaloniki','Center','Limani',NULL
SET IDENTITY_INSERT realpoc.property_location OFF
GO

UPDATE realpoc.property_location SET level1_code = realpoc.GET_SUBSTRING_BY_INDEX(code,1,'.')
UPDATE realpoc.property_location SET level2_code = realpoc.GET_SUBSTRING_BY_INDEX(code,2,'.')
UPDATE realpoc.property_location SET level3_code = realpoc.GET_SUBSTRING_BY_INDEX(code,3,'.')
UPDATE realpoc.property_location SET level4_code = realpoc.GET_SUBSTRING_BY_INDEX(code,4,'.')


--SELECT * FROM realpoc.property_location ORDER BY level4_descr,level3_descr,level2_descr,level1_descr






 --Property
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'property_offer') DROP TABLE realpoc.property_offer
GO
CREATE TABLE realpoc.property_offer (

	id						int	NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	is_active				bit NOT NULL DEFAULT 1,
	is_open					bit NOT NULL DEFAULT 1,	
	title					nvarchar(200) NULL,
	descr					nvarchar(1000) NULL,
	category_id				int NULL REFERENCES realpoc.property_category(id),
	subcategory_id			int NULL REFERENCES realpoc.property_subcategory(id),
	offer_type_id			int NULL REFERENCES realpoc.property_offer(id),
	price					money NULL,
	rooms					int NULL,
	floor_level				int NULL,
	heating_type_id			int NULL REFERENCES realpoc.property_heating_type(id),
	heating_medium_id		int NULL REFERENCES realpoc.property_heating_medium(id),
	constr_year				int	NULL,
	area					int	NULL,
	other_features			nvarchar(1000) NULL,
	location_id				int NULL,
	location_code			nvarchar(50) NULL,
	level1_code				nvarchar(50)   NULL,
	level2_code				nvarchar(50)   NULL,
	level3_code				nvarchar(50)   NULL,
	level4_code				nvarchar(50)   NULL,
	location_coords			nvarchar(100)  NULL,
	featured_image_url		nvarchar(50)   NULL,
	featured_image			image NULL,
	date_lastupdate			datetime NOT NULL DEFAULT GETDATE(),
	date_entered			datetime NOT NULL DEFAULT GETDATE(),	
);
GO



--Fake Data
DELETE realpoc.property_offer
--SET IDENTITY_INSERT realpoc.property_offer ON
--GO
--INSERT realpoc.property_offer (id, is_active,is_open,title,descr,category_id,subcategory_id,offer_type_id,price,rooms,floor_level,heating_type_id,heating_medium_id,constr_year,area,other_features,location_id,location_code,location_coords,featured_image) 
--SELECT 1,1,1,'Title Offer 1 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',1,'','40.59430000,23.04890000',NULL
--UNION
--SELECT 2,1,1,'Title Offer 2 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',2,'','40.65960000,22.80180000',NULL
--UNION
--SELECT 3,1,1,'Title Offer 3 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',3,'','38.24030000,21.74540000',NULL
--UNION
--SELECT 4,1,1,'Title Offer 4 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',4,'','40.08530000,21.42550000',NULL
--UNION
--SELECT 5,1,1,'Title Offer 5 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',5,'','41.08980000,23.56610000',NULL
--UNION
--SELECT 6,1,1,'Title Offer 6 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',6,'','40.57890000,22.95190000',NULL
--UNION
--SELECT 7,1,1,'Title Offer 7 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',7,'','40.58320000,22.95860000',NULL
--UNION
--SELECT 8,1,1,'Title Offer 8 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',8,'','38.03750000,23.73520000',NULL
--UNION
--SELECT 9,1,1,'Title Offer 9 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',9,'','41.19190000,24.10390000',NULL
--UNION
--SELECT 10,1,1,'Title Offer 10 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',10,'','37.9737888,23.6564988',NULL
--UNION
--SELECT 11,1,1,'Title Offer 11 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',1,1,1,500,2,1,1,1,2000,100,'Game room,furniture',11,'','37.9843888,23.6514988',NULL
--UNION
--SELECT 12,1,1,'Title Offer 11 rooms 500pcm at Athens Center','Description Offer 2 rooms 500pcm at Athens Center',2,1,2,300,2,1,1,1,2000,100,'Game room,furniture',12,'','37.9929888,23.6594988',NULL
--SET IDENTITY_INSERT realpoc.property_offer OFF
--GO

--SELECT * FROM realpoc.property_offer

--Super Fake Data...
DELETE realpoc.property_offer
GO
SET IDENTITY_INSERT realpoc.property_offer ON
GO
DECLARE @index	int,
		@lat	float,
		@long	float
SELECT @index	= 1
SELECT @lat		= 37.9929888
SELECT @long	= 23.6594988

WHILE @index < 1000
BEGIN
INSERT	realpoc.property_offer (id, is_active,is_open,title,descr,category_id,subcategory_id,offer_type_id,price,rooms,floor_level,heating_type_id,heating_medium_id,constr_year,area,other_features,location_id,location_code,location_coords,featured_image) 
SELECT							@index, --id
							    1, --is_active
								1, --is_open
								'Dummy Title Offer ' + Convert(nvarchar(100),@index) + ' rooms 500pcm at Athens Center', --title
								'Dummy Description Offer 2 rooms 500pcm at Athens Center',--descr
								realpoc.GET_RANDOM_INT(1,4),--category_id (1-4)
								realpoc.GET_RANDOM_INT(1,5),--subcategory_id (1-5)
								realpoc.GET_RANDOM_INT(1,2),--offer_type_id (1-2)
								realpoc.GET_RANDOM_INT(200,100000),--price
								realpoc.GET_RANDOM_INT(1,4),--rooms
								realpoc.GET_RANDOM_INT(1,10),--floor_level
								realpoc.GET_RANDOM_INT(1,4),--heating_type_id (1-4)
								realpoc.GET_RANDOM_INT(1,4), --heating_medium_id (1-4)
								realpoc.GET_RANDOM_INT(1960,2010),--constr_year
								realpoc.GET_RANDOM_INT(30,900), --area
								'Nothing mentioned',--other_features
								realpoc.GET_RANDOM_INT(2,22), --location_id
								'', --location_code
								CONVERT(nvarchar(100),@lat + RAND() - 0.5)+','+CONVERT(nvarchar(100),@long + RAND() - 0.5), null

SET @index = @index+1

END
SET IDENTITY_INSERT realpoc.property_offer OFF
GO


--select * from realpoc.property_offer_vw 
UPDATE realpoc.property_offer SET price= realpoc.GET_RANDOM_INT(10000,500000) WHERE offer_type_id=1
UPDATE realpoc.property_offer SET price= realpoc.GET_RANDOM_INT(100,1000) WHERE offer_type_id=2


UPDATE realpoc.property_offer SET subcategory_id= realpoc.GET_RANDOM_INT(1,3) WHERE category_id=1
UPDATE realpoc.property_offer SET subcategory_id= realpoc.GET_RANDOM_INT(4,5) WHERE category_id=2
UPDATE realpoc.property_offer SET subcategory_id= realpoc.GET_RANDOM_INT(6,7) WHERE category_id=3
UPDATE realpoc.property_offer SET subcategory_id= realpoc.GET_RANDOM_INT(8,9) WHERE category_id=4

UPDATE realpoc.property_offer SET featured_image_url = 'offer'+CONVERT(nvarchar(10),realpoc.GET_RANDOM_INT(1,5))+'.jpg'


UPDATE realpoc.property_offer SET location_code = (SELECT code FROM realpoc.property_location WHERE id = location_id)
UPDATE realpoc.property_offer SET level1_code = realpoc.GET_SUBSTRING_BY_INDEX(location_code,1,'.')
UPDATE realpoc.property_offer SET level2_code = realpoc.GET_SUBSTRING_BY_INDEX(location_code,2,'.')
UPDATE realpoc.property_offer SET level3_code = realpoc.GET_SUBSTRING_BY_INDEX(location_code,3,'.')
UPDATE realpoc.property_offer SET level4_code = realpoc.GET_SUBSTRING_BY_INDEX(location_code,4,'.')




IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'users') DROP TABLE realpoc.users
GO
CREATE TABLE realpoc.users (
	id				int				NOT NULL	IDENTITY(1, 1) PRIMARY KEY,
	email			nvarchar(100)   NOT NULL UNIQUE,
	password		nvarchar(100)   NOT NULL,
	role			int				NULL,
	first_name		nvarchar(100)	NULL,
	last_name		nvarchar(100)	NULL
);
GO


DELETE realpoc.users
SET IDENTITY_INSERT realpoc.users ON
GO
INSERT  realpoc.users(id,email,password) SELECT 1,'vasileioskk@gmail.com','password'
SET IDENTITY_INSERT realpoc.users OFF
GO


--Table to Store via stored procedure what properties every location matches for quick searches.
IF EXISTS (SELECT table_name FROM   information_schema.tables WHERE  table_schema = 'realpoc' AND table_name = 'propertieslocation') DROP TABLE realpoc.propertieslocation
GO
CREATE TABLE realpoc.propertieslocation (

	location_code					nvarchar(50) NULL,		
	offer_id						int NULL
);
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------TABLES AND SEED DATA END------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------VIEWS-------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Property List Item
IF EXISTS (SELECT table_name FROM information_schema.views WHERE  table_schema = 'realpoc' AND table_name = 'property_offer_vw') DROP VIEW realpoc.property_offer_vw 
GO
CREATE VIEW realpoc.property_offer_vw AS 

SELECT 

[OfferId]				=	po.id,
[OfferCategory]			=	ofcat.descr,
[PropertyCategory]		=	prcat.descr,
[PropertySubCategory]	=	prsubcat.descr,
[PropertyLocation]				=	ploc.full_descr,
[Title]					=	title,
[Description]			=	po.descr,
[Price]					=	price,
[Rooms]					=	rooms,
[FloorLevel]			=	floor_level,	
[HeatingType]			=	heattype.descr,
[HeatingMedium]			=	heatmedium.descr,
[ConstructionYear]		=	constr_year,
[Area]					=	area,
[OtherFeatures]			=	other_features,
[Geolocation]			=   location_coords,
[PropertyLat]			=	realpoc.GET_SUBSTRING_BY_INDEX(location_coords,1,','),
[PropertyLng]			=	realpoc.GET_SUBSTRING_BY_INDEX(location_coords,2,','),
[FeaturedImage]			=	featured_image,
[FeaturedImageUrl]		=   featured_image_url,
[LastUpdate]			=	date_lastupdate,
[DateEntered]			=	date_entered


FROM realpoc.property_offer po 
LEFT JOIN realpoc.property_category prcat ON  po.category_id = prcat.id
LEFT JOIN realpoc.property_subcategory prsubcat ON  po.subcategory_id = prsubcat.id
LEFT JOIN realpoc.offer_category ofcat ON  po.offer_type_id = ofcat.id
LEFT JOIN realpoc.property_heating_type heattype ON  po.heating_type_id = heattype.id
LEFT JOIN realpoc.property_heating_medium heatmedium ON  po.heating_medium_id = heatmedium.id
LEFT JOIN realpoc.property_location ploc ON  po.location_code = ploc.code
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------VIEWS END---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*
select * from realpoc.property_offer_vw 

SELECT title=
(SELECT OfferCategory FROM realpoc.property_offer_vw WHERE OfferId=4)
+' €'+(SELECT Convert(nvarchar(100),Price) FROM realpoc.property_offer_vw WHERE OfferId=4)
+' for '+(SELECT Convert(nvarchar(100),Rooms) FROM realpoc.property_offer_vw WHERE OfferId=4)
+' Room '
+'('+(SELECT Convert(nvarchar(100),Area) FROM realpoc.property_offer_vw WHERE OfferId=4)+' sqm) '
+(SELECT PropertyCategory FROM realpoc.property_offer_vw WHERE OfferId=4)
+' '+(SELECT PropertySubCategory FROM realpoc.property_offer_vw WHERE OfferId=4)
+' at '+(SELECT PropertyLocation FROM realpoc.property_offer_vw WHERE OfferId=4)

SELECT descr=
'With construction year '+(SELECT Convert(nvarchar(100),ConstructionYear) FROM realpoc.property_offer_vw WHERE OfferId=4)+' dont miss this amazing '+
(SELECT OfferCategory FROM realpoc.property_offer_vw WHERE OfferId=4)
+' only for €'+(SELECT Convert(nvarchar(100),Price) FROM realpoc.property_offer_vw WHERE OfferId=4)
+' for '+(SELECT Convert(nvarchar(100),Rooms) FROM realpoc.property_offer_vw WHERE OfferId=4)
+' Room '
+'('+(SELECT Convert(nvarchar(100),Area) FROM realpoc.property_offer_vw WHERE OfferId=4)+' sqm) '
+(SELECT PropertyCategory FROM realpoc.property_offer_vw WHERE OfferId=4)
+' '+(SELECT PropertySubCategory FROM realpoc.property_offer_vw WHERE OfferId=4)
+' at '+(SELECT PropertyLocation FROM realpoc.property_offer_vw WHERE OfferId=4)
+' with '+(SELECT HeatingType+' '+HeatingMedium FROM realpoc.property_offer_vw WHERE OfferId=4)
*/

UPDATE realpoc.property_offer SET title=
+'For '+(SELECT OfferCategory FROM realpoc.property_offer_vw WHERE OfferId=id)
+' €'+(SELECT Convert(nvarchar(100),Price) FROM realpoc.property_offer_vw WHERE OfferId=id)
+' '+(SELECT Convert(nvarchar(100),Rooms) FROM realpoc.property_offer_vw WHERE OfferId=id)
+' Room '
+'('+(SELECT Convert(nvarchar(100),Area) FROM realpoc.property_offer_vw WHERE OfferId=id)+' sqm) '
+(SELECT PropertyCategory FROM realpoc.property_offer_vw WHERE OfferId=id)
+' '+(SELECT PropertySubCategory FROM realpoc.property_offer_vw WHERE OfferId=id)
+' at '+(SELECT PropertyLocation FROM realpoc.property_offer_vw WHERE OfferId=id)

UPDATE realpoc.property_offer SET descr=
'With construction year '+(SELECT Convert(nvarchar(100),ConstructionYear) FROM realpoc.property_offer_vw WHERE OfferId=id)+' dont miss this amazing '+
(SELECT OfferCategory FROM realpoc.property_offer_vw WHERE OfferId=id)
+' only for €'+(SELECT Convert(nvarchar(100),Price) FROM realpoc.property_offer_vw WHERE OfferId=id)
+' for '+(SELECT Convert(nvarchar(100),Rooms) FROM realpoc.property_offer_vw WHERE OfferId=id)
+' Room '
+'('+(SELECT Convert(nvarchar(100),Area) FROM realpoc.property_offer_vw WHERE OfferId=id)+' sqm) '
+(SELECT PropertyCategory FROM realpoc.property_offer_vw WHERE OfferId=id)
+' '+(SELECT PropertySubCategory FROM realpoc.property_offer_vw WHERE OfferId=id)
+' On '+(SELECT Convert(nvarchar(100),FloorLevel) FROM realpoc.property_offer_vw WHERE OfferId=id)+' floor '
+' at '+(SELECT PropertyLocation FROM realpoc.property_offer_vw WHERE OfferId=id)
+' with '+(SELECT HeatingType+' '+HeatingMedium FROM realpoc.property_offer_vw WHERE OfferId=id)


select * from realpoc.property_offer_vw 



---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------STORED PROCEDURES-------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='getPropertyOffersList_sp') DROP PROCEDURE realpoc.getPropertyOffersList_sp
GO
CREATE PROCEDURE realpoc.getPropertyOffersList_sp
AS

SELECT * FROM realpoc.property_offer_vw
RETURN 0
GO


IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='getLocations_sp') DROP PROCEDURE realpoc.getLocations_sp
GO
CREATE PROCEDURE realpoc.getLocations_sp @SearchString nvarchar(50)=NULL
AS

SELECT	TOP 10	
		[id] = id,
		[name]=full_descr 
FROM realpoc.property_location 
WHERE  full_descr LIKE '%'+ISNULL(@SearchString,'')+'%' ORDER BY level4_descr,level3_descr,level2_descr,level1_descr


RETURN 0
GO


IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='getSelectedLocations_sp') DROP PROCEDURE realpoc.getSelectedLocations_sp
GO
CREATE PROCEDURE realpoc.getSelectedLocations_sp @SelectedLocations nvarchar(max)=NULL
AS

DECLARE @i int -- @SearchLocations index
DECLARE @id nvarchar(50) -- @selected id
DECLARE @selectedId   TABLE(
                        id int NOT NULL
                       );
					   
					   	
	SET @i =1;
	SET @id = realpoc.GET_SUBSTRING_BY_INDEX(@SelectedLocations,@i,',')
	IF  @id IS NOT NULL INSERT @selectedId(id) SELECT CONVERT(int,@id)

	WHILE (@id IS NOT NULL)
	BEGIN
		SET @i =@i+1
		SET @id = realpoc.GET_SUBSTRING_BY_INDEX(@SelectedLocations,@i,',')
		IF @id IS NOT NULL INSERT @selectedId(id) SELECT CONVERT(int,@id)
	END

SELECT	TOP 10	
		[id] = id,
		[name]=full_descr 
FROM	realpoc.property_location 
WHERE   id IN(SELECT id FROM @selectedId) ORDER BY level4_descr,level3_descr,level2_descr,level1_descr


RETURN 0
GO


IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='searchPropertyOffers_sp') DROP PROCEDURE realpoc.searchPropertyOffers_sp
GO
CREATE PROCEDURE realpoc.searchPropertyOffers_sp @OfferTypeId int=NULL,
												 @CategoryId int=NULL,
												 @SubCategoryId int=NULL,
												 @LocationCode nvarchar(50)=NULL, -- {1,2,22,45}
												 @MaxPrice decimal=NULL,
												 @MinArea int=NULL,
												 @MinRooms int=NULL,
												 @MinFloorLevel int=NULL
													
AS



declare @matchingOffers TABLE(
                        id int NOT NULL
                       );

INSERT INTO @matchingOffers
SELECT id FROM realpoc.property_offer WHERE
	is_active=1
AND	is_open=1
AND category_id=ISNULL(@CategoryId,category_id) 
AND subcategory_id=ISNULL(@SubCategoryId,subcategory_id)
AND offer_type_id=ISNULL(@OfferTypeId,offer_type_id)
AND location_code=ISNULL(@LocationCode,location_code) --To be split in parts.
AND price <= ISNULL(@MaxPrice,price) --Add min later
AND area >= ISNULL(@MinArea,area) --Add max later
AND rooms >= ISNULL(@MinRooms,rooms) --Add max later
AND floor_level >= ISNULL(@MinFloorLevel,floor_level) --Add max later

SELECT * FROM realpoc.property_offer_vw WHERE OfferId IN( SELECT id FROM @matchingOffers)

RETURN 0
GO



IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='searchPropertyOffersPaged_sp') DROP PROCEDURE realpoc.searchPropertyOffersPaged_sp
GO
CREATE PROCEDURE realpoc.searchPropertyOffersPaged_sp	@Page int=1,
														@PageSize int=10,
														@OfferTypeId int=NULL,
														@CategoryId int=NULL,
														@SubCategoryId int=NULL,
														@LocationCode nvarchar(500)=NULL,
														@MaxPrice decimal=NULL,
														@MinArea int=NULL,
														@MinRooms int=NULL,
														@MinFloorLevel int=NULL
													
AS

IF @Page<=0 OR @Page IS NULL SET @page=1
IF @PageSize<=0 OR @PageSize IS NULL SET @PageSize=10





	DECLARE @i int -- @LocationCode index
	DECLARE @id nvarchar(50) -- @selected id
	DECLARE @matchingLocations TABLE(
								offer_id int NOT NULL
								);
					   					   	
	SET @i =1;
	SET @id = realpoc.GET_SUBSTRING_BY_INDEX(@LocationCode, @i,',')
	--IF  @id IS NOT NULL INSERT @selectedId(id) SELECT CONVERT(int,@id)
	IF @id IS NOT NULL INSERT @matchingLocations SELECT offer_id FROM realpoc.propertieslocation WHERE location_code =(SELECT code FROM realpoc.property_location WHERE id = CONVERT(int,@id))


	WHILE (@id IS NOT NULL)
	BEGIN
		SET @i =@i+1
		SET @id = realpoc.GET_SUBSTRING_BY_INDEX(@LocationCode, @i,',')
		IF @id IS NOT NULL INSERT @matchingLocations SELECT offer_id FROM realpoc.propertieslocation WHERE location_code =(SELECT code FROM realpoc.property_location WHERE id = CONVERT(int,@id))
	END



--All other filters except location
DECLARE @matchingFilters TABLE(
                        offer_id int NOT NULL
                       );


INSERT INTO @matchingFilters
SELECT id FROM realpoc.property_offer WHERE
	is_active=1
AND	is_open=1
AND category_id=ISNULL(@CategoryId,category_id) 
AND subcategory_id=ISNULL(@SubCategoryId,subcategory_id)
AND offer_type_id=ISNULL(@OfferTypeId,offer_type_id)
--AND location_code=ISNULL(@LocationCode,location_code) --To be split in parts.
AND price <= ISNULL(@MaxPrice,price) --Add min later
AND area >= ISNULL(@MinArea,area) --Add max later
AND rooms >= ISNULL(@MinRooms,rooms) --Add max later
AND floor_level >= ISNULL(@MinFloorLevel,floor_level) --Add max later



DECLARE @matchingOffers TABLE(
                        offer_id int NOT NULL
                       );
INSERT @matchingOffers SELECT id FROM realpoc.property_offer WHERE id IN( SELECT offer_id FROM @matchingFilters) AND id IN( SELECT offer_id FROM @matchingLocations) 


SELECT  *
FROM realpoc.property_offer_vw
     CROSS JOIN (SELECT Count(*) AS TotalResults FROM @matchingOffers) AS tResultsCount
WHERE OfferId IN( SELECT offer_id FROM @matchingOffers)
ORDER BY OfferId
OFFSET (@Page-1)* @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;


RETURN 0
GO

--EXEC realpoc.searchPropertyOffersPaged_sp 1,10,1,1,1

--SELECT  ROW_NUMBER() OVER ( ORDER BY OfferId ) AS RowNum,COUNT(*) OVER() AS TotalCount

IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='getOffersByRange_sp') DROP PROCEDURE realpoc.getOffersByRange_sp
GO
CREATE PROCEDURE realpoc.getOffersByRange_sp	 @lat  nvarchar(200) =NULL, --google map center lat
												 @lng  nvarchar(200) =NULL, --google map center lng
												 @range int = NULL,			--Range manual or javascript calculated to match google map zoom
												 @zoom int = NULL			--IF zoom is null or 0 ignore range calculation
AS
											


IF (@zoom IS NOT NULL AND @zoom <> 0)
BEGIN

SET @range = 11.75 * POWER ( 2  , 22 - @zoom ) --11.75 is FOR 800px x 800px MAP

END


IF @range<1000 SET @range=1000 -- Mimum distance of offers to show on google map
IF @range>1000000 SET @range=1000000 -- Max distance of offers to show on google map


SELECT

[OfferId],			
[OfferCategory],			
[PropertyCategory],	
[PropertySubCategory],	
[PropertyLocation],
[Area],				
[Title]	,				
[Price]	,
[Geolocation],			
[PropertyLat],			
[PropertyLng]		


FROM realpoc.property_offer_vw
WHERE ( 6371 * acos( cos( radians(@lat) ) * cos( radians( PropertyLat ) ) * cos( radians( PropertyLng ) - radians(@lng) ) + sin( radians(@lat) ) * sin( radians( PropertyLat ) ) ) ) < @range/1000


RETURN 0
GO

--SELECT * FROM realpoc.property_offer_vw
--EXEC realpoc.getOffersByRange_sp '40.59430000','23.04890000',1000,0



IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='getuserprofile_sp') DROP PROCEDURE realpoc.getuserprofile_sp
GO
CREATE PROCEDURE realpoc.getuserprofile_sp @email nvarchar(100)=NULL
AS

SELECT * FROM realpoc.users_profile WHERE email=@email

RETURN 0
GO



IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='registeruser_sp') DROP PROCEDURE realpoc.registeruser_sp
GO
CREATE PROCEDURE realpoc.registeruser_sp @email nvarchar(100),@password nvarchar(100)
AS

DECLARE @userid int

INSERT  realpoc.users(email,password) SELECT @email,@password
SET @userid = SCOPE_IDENTITY()  
SELECT * FROM realpoc.users WHERE id=@userid

RETURN 0
GO

--EXEC realpoc.getuserprofile_sp 'vasileioskk@gmail.com'

IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='loginuser_sp') DROP PROCEDURE realpoc.loginuser_sp
GO
CREATE PROCEDURE realpoc.loginuser_sp @email nvarchar(100)
AS

SELECT [Id]=id,[Email]=email,[Password]=password FROM realpoc.users WHERE email=@email

RETURN 0
GO

--GetOfferById
IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='getofferbyid_sp') DROP PROCEDURE realpoc.getofferbyid_sp
GO
CREATE PROCEDURE realpoc.getofferbyid_sp @OfferId int
AS

SELECT * FROM realpoc.property_offer_vw WHERE OfferId=@OfferId


RETURN 0
GO



--GetSponsored
IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='getsponsored_sp') DROP PROCEDURE realpoc.getsponsored_sp
GO
CREATE PROCEDURE realpoc.getsponsored_sp
AS

SELECT TOP 12 * FROM realpoc.property_offer_vw  WHERE OfferCategory='Rent' AND LEN(PropertyLocation)<35

RETURN 0
GO



--Update what properties every location matches 
IF EXISTS (SELECT ROUTINE_NAME from information_schema.routines where routine_type = 'PROCEDURE' AND ROUTINE_NAME='updateLocationProperties_sp') DROP PROCEDURE realpoc.updateLocationProperties_sp
GO
CREATE PROCEDURE realpoc.updateLocationProperties_sp 
AS

DECLARE @code nvarchar(30) 
DECLARE @level4 nvarchar(5)
DECLARE @level3 nvarchar(5)
DECLARE @level2 nvarchar(5)
DECLARE @level1 nvarchar(5)

--Delete current data
DELETE realpoc.propertieslocation

DECLARE loc_cursor CURSOR  
    FOR SELECT code FROM realpoc.property_location
OPEN loc_cursor  
FETCH NEXT FROM loc_cursor INTO @code;  

WHILE @@FETCH_STATUS = 0  
BEGIN
		
		SET @level4 =realpoc.GET_SUBSTRING_BY_INDEX(@code,4,'.')
		SET @level3 =realpoc.GET_SUBSTRING_BY_INDEX(@code,3,'.')
		SET @level2 =realpoc.GET_SUBSTRING_BY_INDEX(@code,2,'.')
		SET @level1 =realpoc.GET_SUBSTRING_BY_INDEX(@code,1,'.')

		IF @level4<>'00000'
			BEGIN
				INSERT realpoc.propertieslocation (location_code,offer_id) 
				SELECT @code,id FROM realpoc.property_offer WHERE location_code = @code
			END
		ELSE IF @level3<>'00000'
			BEGIN
				INSERT realpoc.propertieslocation (location_code,offer_id) 
				SELECT @code,id FROM realpoc.property_offer WHERE level1_code+level2_code+level3_code =@level1+@level2+@level3
			END
		ELSE IF @level2<>'00000'
			BEGIN
				INSERT realpoc.propertieslocation (location_code,offer_id) 
				SELECT @code,id FROM realpoc.property_offer WHERE level1_code+level2_code = @level1+@level2
			END
		ELSE IF @level1<>'00000'
			BEGIN
				INSERT realpoc.propertieslocation (location_code,offer_id) 
				SELECT @code,id FROM realpoc.property_offer WHERE level1_code = @level1
			END

   FETCH NEXT FROM loc_cursor INTO @code;  
END   
CLOSE loc_cursor;  
DEALLOCATE loc_cursor;  

RETURN 0
GO


EXEC realpoc.updateLocationProperties_sp
--SELECT * FROM realpoc.propertieslocation




---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------STORED PROCEDURES END---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------














---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------NOTEPAD-----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
--Search
DECLARE @code nvarchar(30) 
DECLARE @level4 nvarchar(5)
DECLARE @level3 nvarchar(5)
DECLARE @level2 nvarchar(5)
DECLARE @level1 nvarchar(5)
SET @code= '00001.00001.00000.00000' 
SET @level4 =realpoc.GET_SUBSTRING_BY_INDEX(@code,4,'.')
SET @level3 =realpoc.GET_SUBSTRING_BY_INDEX(@code,3,'.')
SET @level2 =realpoc.GET_SUBSTRING_BY_INDEX(@code,2,'.')
SET @level1 =realpoc.GET_SUBSTRING_BY_INDEX(@code,1,'.')

IF @level4<>'00000'
	BEGIN
		SELECT * FROM realpoc.property_offer WHERE location_code = @code
	END
ELSE IF @level3<>'00000'
	BEGIN
		SELECT '@level3<>00000'
		SELECT * FROM realpoc.property_offer WHERE level1_code+level2_code+level3_code =@level1+@level2+@level3
	END
ELSE IF @level2<>'00000'
	BEGIN
		SELECT '@level2<>00000'
		SELECT * FROM realpoc.property_offer WHERE level1_code+level2_code = @level1+@level2
	END
ELSE IF @level1<>'00000'
	BEGIN
		SELECT '@level1<>00000'
		SELECT * FROM realpoc.property_offer WHERE level1_code = @level1
	END

*/