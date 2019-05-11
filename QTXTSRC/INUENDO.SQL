/******************************************************************************/
/*                                                                            */
/*  Inuendo 1.2 (Alpha release) - BASE TABLE BUILDS                           */
/*                                                                            */
/*  Copyright (C) 2012, 2019  Christopher F. Burns Sr.                        */
/*    c/o The Inuendo Project (http://inuendo.us).                            */
/*                                                                            */
/*  This program is free software: you can redistribute it and/or modify      */
/*  it under the terms of the GNU General Public License as published by      */
/*  the Free Software Foundation, either version 3 of the License, or         */
/*  (at your option) any later version.                                       */
/*                                                                            */
/*  This program is distributed in the hope that it will be useful,           */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of            */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             */
/*  GNU General Public License for more details.                              */
/*                                                                            */
/*  You should have received a copy of the GNU General Public License         */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.     */
/*                                                                            */
/******************************************************************************/


/******************************************************************************/
/*  ENTITY PROPERTIES                                                         */
/******************************************************************************/


CREATE TABLE ENTPROP (
  CLASS VARCHAR(14) ALLOCATE(1) CCSID 37 NOT NULL DEFAULT ' ' ,
  PROPERTY VARCHAR(14) ALLOCATE(1) CCSID 37 NOT NULL DEFAULT ' ' ,
  DATATYPE VARCHAR(14) ALLOCATE(1) CCSID 37 NOT NULL DEFAULT ' ' ,
  "DESCRIPTOR" VARCHAR(254) ALLOCATE(2) CCSID 37 NOT NULL DEFAULT '  ' ,
  SEQUENCER SMALLINT NOT NULL DEFAULT 0 ,
  PARTCLASS VARCHAR(14) ALLOCATE(1) CCSID 37 NOT NULL DEFAULT '' ,
  CONSTRAINT ENTPROP_PRIMARY PRIMARY KEY( CLASS , PROPERTY ) );

ALTER TABLE ENTPROP ALTER KEEP IN MEMORY YES ;

LABEL ON TABLE ENTPROP
 IS 'ENTITY PROPERTY' ;

LABEL ON COLUMN ENTPROP
( CLASS IS 'CLASS                ' ,
 PROPERTY IS 'PROPERTY            NAME' ,
 DATATYPE IS 'DATA                TYPE' ,
 "DESCRIPTOR" IS 'DESCRIPTION          ' ,
 SEQUENCER IS 'PROPERTY            SEQUENCER' ,
 PARTCLASS IS 'PARTNER             CLASS' ) ;

LABEL ON COLUMN ENTPROP
( CLASS TEXT IS 'CLASS' ,
 PROPERTY TEXT IS 'PROPERTY NAME' ,
 DATATYPE TEXT IS 'DATA TYPE' ,
 "DESCRIPTOR" TEXT IS 'DESCRIPTION' ,
 SEQUENCER TEXT IS 'PROPERTY SEQUENCER' ,
 PARTCLASS TEXT IS 'PARTNER CLASS' ) ;

GRANT DELETE , INSERT , SELECT , UPDATE
ON ENTPROP TO PUBLIC ;

CREATE INDEX ENTPROPL1
  ON ENTPROP ( CLASS ASC , SEQUENCER ASC ) ;

LABEL ON INDEX ENTPROPL1
  IS 'Entity Property (CLASS, SEQUENCER)' ;


/******************************************************************************/
/*  ENTITY HEADER                                                             */
/******************************************************************************/

CREATE TABLE ENTHEAD (
  ENTITYID BIGINT GENERATED ALWAYS AS IDENTITY (
  START WITH 1 INCREMENT BY 1
  NO MINVALUE NO MAXVALUE
  NO CYCLE NO ORDER
  NO CACHE ) ,
  PARENTID BIGINT NOT NULL ,
  CLASS VARCHAR(14) NOT NULL ,
  LEGACYA VARCHAR(254)  NOT NULL DEFAULT ' ',
  LEGACYN BIGINT NOT NULL DEFAULT 0,
  DESCRIPTOR VARCHAR(254) NOT NULL DEFAULT ' ',
  STATUS CHAR(1) NOT NULL DEFAULT ' ',
  CREATETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CREATEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CREATEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CREATEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CREATEPROG CHAR(10) NOT NULL DEFAULT ' ',
  CONSTRAINT ENTHEAD_PRIMARY PRIMARY KEY( ENTITYID ) ) ;

LABEL ON TABLE ENTHEAD
  IS 'Entity Header' ;

LABEL ON COLUMN ENTHEAD
( ENTITYID IS 'Entity              ID' ,
  PARENTID IS 'Parent              ID' ,
  CLASS IS 'Entity              Class' ,
  LEGACYA IS 'Legacy              ID Alpha',
  LEGACYN IS 'Legacy              ID Numeric' ,
  DESCRIPTOR IS 'Freeform            Descriptor' ,
  STATUS IS 'Status              Code' ,
  CREATETIME IS 'Create              Time                Stamp' ,
  CREATEJNAM IS 'Create              Job                 Name' ,
  CREATEUSER IS 'Create              User                Profile' ,
  CREATEJNUM IS 'Create              Job                 Number' ,
  CREATEPROG IS 'Create              Program             Name' );

LABEL ON COLUMN ENTHEAD
( ENTITYID TEXT IS 'Entity ID' ,
  PARENTID TEXT IS 'Parent ID' ,
  CLASS TEXT IS 'Entity Class' ,
  LEGACYA TEXT IS 'Legacy ID Alpha',
  LEGACYN TEXT IS 'Legacy ID Numeric' ,
  DESCRIPTOR TEXT IS 'Freeform Descriptor' ,
  STATUS TEXT IS 'Status Code' ,
  CREATETIME TEXT IS 'Create Time Stamp' ,
  CREATEJNAM TEXT IS 'Create Job Name	' ,
  CREATEUSER TEXT IS 'Create User Profile' ,
  CREATEJNUM TEXT IS 'Create Job Number' ,
  CREATEPROG TEXT IS 'Create Program Name' ) ;

CREATE INDEX ENTHEADL0 ON ENTHEAD
  (CREATEJNAM  ASC, CREATEUSER  ASC, CREATEJNUM  ASC, CREATETIME  ASC);

LABEL ON INDEX ENTHEADL0
  IS 'Entity Header (CREATEJNAM, CREATEUSER)';

CREATE INDEX ENTHEADL1
  ON ENTHEAD ( PARENTID ASC , CLASS ASC , LEGACYA ASC , LEGACYN ASC ) ;

LABEL ON INDEX ENTHEADL1
  IS 'Entity Header (ParentID, Class, LegacyA, LegacyN)' ;

CREATE INDEX ENTHEADL2
  ON ENTHEAD ( PARENTID ASC , CLASS ASC , LEGACYN ASC ) ;

LABEL ON INDEX ENTHEADL2
  IS 'Entity Header (ParentID, Class, LegacyN)' ;

CREATE INDEX ENTHEADL3
  ON ENTHEAD ( CLASS ASC , LEGACYA ASC , LEGACYN ASC, ENTITYID ASC ) ;

LABEL ON INDEX ENTHEADL3
  IS 'Entity Header (Class, LegacyA, LegacyN, EntityID)' ;

CREATE INDEX ENTHEADL4
  ON ENTHEAD ( CLASS ASC , LEGACYN ASC, ENTITYID ASC ) ;

LABEL ON INDEX ENTHEADL4
  IS 'Entity Header (Class, LegacyN, EntityID)' ;


GRANT SELECT ON TABLE ENTHEAD TO PUBLIC;
GRANT INSERT ON TABLE ENTHEAD TO PUBLIC;
GRANT UPDATE ON TABLE ENTHEAD TO PUBLIC;

REVOKE DELETE ON TABLE ENTHEAD FROM PUBLIC;


/******************************************************************************/
/*  INSTANTIATE FOUNDER, THEN APPLY ENTITY ID CONSTRAINT                      */
/******************************************************************************/

INSERT INTO entprop (class, property, descriptor)
  values('FOUNDER', ' ', 'DATABASE FOUNDER');

INSERT INTO entprop (class, property, descriptor)
  values('DATATYPE', ' ', 'STANDARD DATA TYPE W/SUBTABLE');

INSERT INTO entprop (class, descriptor)
  values('CLASSERROR', 'CLASS ERROR OR VIOLATION');

INSERT INTO entprop (class, property, datatype, descriptor, sequencer)
  values('CLASSERROR', 'FUNCTION', 'NOTE', 'FUNCTION NAME', 10);

INSERT INTO entprop (class, descriptor)
  values('PROPERROR', 'PROPERTY ERROR OR VIOLATION');

INSERT INTO entprop (class, property, datatype, descriptor, sequencer)
  values('PROPERROR', 'SUBTABLE', 'NOTE', 'SUBTABLE NAME', 10);

INSERT INTO entprop (class, property, datatype, descriptor, sequencer)
  values('PROPERROR', 'FUNCTION', 'NOTE', 'FUNCTION NAME', 20);

INSERT INTO entprop (class, property, datatype, descriptor, sequencer)
  values('PROPERROR', 'PROPPATH', 'NOTE', 'PROPERTY PATH', 30);

INSERT INTO entprop (class, property, datatype, descriptor, sequencer)
  values('PROPERROR', 'OWNER', 'LINK', 'PROPERTY OWNER', 40);

INSERT INTO enthead
  (parentid, class, createtime, createuser, descriptor)
    VALUES (1, 'FOUNDER', CURRENT_TIMESTAMP, USER, 'DATABASE FOUNDER');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'DATE', CURRENT_TIMESTAMP, USER,
               'NATIVE ISO DATE');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'FLAG', CURRENT_TIMESTAMP, USER,
               'SINGLE CHARACTER FLAG');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'LINK', CURRENT_TIMESTAMP, USER,
               'UNIQUE ID LINK TO ANOTHER ENTITY');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'NOTE', CURRENT_TIMESTAMP, USER,
               'FREEFORM VARIABLE LENGTH CHARACTER (254)');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'NUMB', CURRENT_TIMESTAMP, USER,
               'DECIMAL (25,7), HANDLES MOST MONETARY/STATISTICAL');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'NOTX', CURRENT_TIMESTAMP, USER,
               'ENCRYPTED VARIABLE LENGTH CHARACTER (254)');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'NUMX', CURRENT_TIMESTAMP, USER,
               'DECIMAL (25,7) ENCRYPTED');

INSERT INTO enthead
  (parentid, class, legacya, createtime, createuser, descriptor)
    VALUES (1, 'DATATYPE', 'DATX', CURRENT_TIMESTAMP, USER,
               'ENCRYPTED DATE');

ALTER TABLE ENTHEAD ADD FOREIGN KEY (PARENTID)
  REFERENCES ENTHEAD (ENTITYID) ON DELETE RESTRICT ON UPDATE RESTRICT ;


/******************************************************************************/
/*  SUBTABLE ENTDATE (NATIVE ISO DATES)                                       */
/******************************************************************************/

CREATE TABLE ENTDATE (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL ,
  "VALUE" DATE NOT NULL ,
  CONSTRAINT ENTDATE_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTDATE
  ADD CONSTRAINT ENTDATE_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTDATE IS 'Entity Date' ;

LABEL ON COLUMN ENTDATE
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTDATE
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTDATEL0 ON ENTDATE
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTDATEL0 IS 'Entity Date (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTDATE TO PUBLIC;
GRANT INSERT ON TABLE ENTDATE TO PUBLIC;

REVOKE DELETE ON TABLE ENTDATE FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTDATE FROM PUBLIC;


/******************************************************************************/
/*  SUBTABLE ENTFLAG (SINGLE BYTE CHARACTER FLAGS)                            */
/******************************************************************************/

CREATE TABLE ENTFLAG (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL DEFAULT ' ',
  "VALUE" CHAR(1) NOT NULL DEFAULT ' ' ,
  CONSTRAINT ENTFLAG_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTFLAG
  ADD CONSTRAINT ENTFLAG_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTFLAG IS 'Entity Flag' ;

LABEL ON COLUMN ENTFLAG
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTFLAG
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTFLAGL0 ON ENTFLAG
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTFLAGL0 IS 'Entity Flag (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTFLAG TO PUBLIC;
GRANT INSERT ON TABLE ENTFLAG TO PUBLIC;

REVOKE DELETE ON TABLE ENTFLAG FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTFLAG FROM PUBLIC;


/******************************************************************************/
/*  SUBTABLE ENTLINK (UNIQUE ID'S OF OTHER ENTITIES)                          */
/******************************************************************************/

CREATE TABLE ENTLINK (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL DEFAULT ' ',
  "VALUE" BIGINT NOT NULL DEFAULT 0 ,
  CONSTRAINT ENTLINK_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTLINK
  ADD CONSTRAINT ENTLINK_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

ALTER TABLE ENTLINK
  ADD CONSTRAINT ENTLINK_VALUE
  FOREIGN KEY( VALUE )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTLINK IS 'Entity Link' ;

LABEL ON COLUMN ENTLINK
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTLINK
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTLINKL0 ON ENTLINK
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTLINKL0 IS 'Entity Link (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTLINK TO PUBLIC;
GRANT INSERT ON TABLE ENTLINK TO PUBLIC;

REVOKE DELETE ON TABLE ENTLINK FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTLINK FROM PUBLIC;


/******************************************************************************/
/*  SUBTABLE ENTNOTE (VARIABLE LENGTH CHARACTERS FOR FREEFORM TEXT)           */
/******************************************************************************/

CREATE TABLE ENTNOTE (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL DEFAULT ' ',
  "VALUE" VARCHAR(254) NOT NULL DEFAULT ' ',
  CONSTRAINT ENTNOTE_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTNOTE
  ADD CONSTRAINT ENTNOTE_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTNOTE IS 'Entity Note' ;

LABEL ON COLUMN ENTNOTE
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTNOTE
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTNOTEL0 ON ENTNOTE
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTNOTEL0 IS 'Entity Note (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTNOTE TO PUBLIC;
GRANT INSERT ON TABLE ENTNOTE TO PUBLIC;

REVOKE DELETE ON TABLE ENTNOTE FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTNOTE FROM PUBLIC;


/******************************************************************************/
/*  SUBTABLE ENTNUMB (NUMBERS WITH 0-5 DECIMALS, HANDLES MOST SITUATIONS)     */
/******************************************************************************/

CREATE TABLE ENTNUMB (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL DEFAULT ' ',
  "VALUE" DECIMAL(25,7) NOT NULL DEFAULT 0,
  CONSTRAINT ENTNUMB_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTNUMB
  ADD CONSTRAINT ENTNUMB_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTNUMB IS 'Entity Number' ;

LABEL ON COLUMN ENTNUMB
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTNUMB
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTNUMBL0 ON ENTNUMB
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTNUMBL0 IS 'Entity Number (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTNUMB TO PUBLIC;
GRANT INSERT ON TABLE ENTNUMB TO PUBLIC;

REVOKE DELETE ON TABLE ENTNUMB FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTNUMB FROM PUBLIC;


/******************************************************************************/
/*  SUBTABLE ENTNOTX (ENCRYPTED VARIABLE LENGTH CHARACTER - LIKE ENTNOTE)     */
/******************************************************************************/

CREATE TABLE ENTNOTX (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL DEFAULT ' ',
  "VALUE" VARCHAR(510) FOR BIT DATA NOT NULL ,
  CONSTRAINT ENTNOTX_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTNOTX
  ADD CONSTRAINT ENTNOTX_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTNOTX IS 'Entity Note (Encrypted)' ;

LABEL ON COLUMN ENTNOTX
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTNOTX
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTNOTXL0 ON ENTNOTX
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTNOTXL0 IS 'Entity Note (Encrypted) (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTNOTX TO PUBLIC;
GRANT INSERT ON TABLE ENTNOTX TO PUBLIC;

REVOKE DELETE ON TABLE ENTNOTX FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTNOTX FROM PUBLIC;


/******************************************************************************/
/*  SUBTABLE ENTNUMX (ENCRYPTED NUMBER)                                       */
/******************************************************************************/

CREATE TABLE ENTNUMX (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL DEFAULT ' ',
  "VALUE" VARCHAR(62) FOR BIT DATA NOT NULL ,
  CONSTRAINT ENTNUMX_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTNUMX
  ADD CONSTRAINT ENTNUMX_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTNUMX IS 'Entity Number (Encrypted)' ;

LABEL ON COLUMN ENTNUMX
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTNUMX
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTNUMXL0 ON ENTNUMX
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTNUMXL0 IS
  'Entity Number (Encrypted) (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTNUMX TO PUBLIC;
GRANT INSERT ON TABLE ENTNUMX TO PUBLIC;

REVOKE DELETE ON TABLE ENTNUMX FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTNUMX FROM PUBLIC;


/******************************************************************************/
/*  SUBTABLE ENTDATX (ENCRYPTED NATIVE ISO DATES)                             */
/******************************************************************************/

CREATE TABLE ENTDATX (
  ENTITYID BIGINT NOT NULL ,
  PROPERTY VARCHAR(14) NOT NULL ,
  CHANGETIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  CHANGEJNAM CHAR(10) NOT NULL DEFAULT ' ',
  CHANGEUSER CHAR(18) NOT NULL DEFAULT USER ,
  CHANGEJNUM CHAR(06) NOT NULL DEFAULT ' ',
  CHANGEPROG CHAR(10) NOT NULL ,
  "VALUE" VARCHAR(40) NOT NULL ,
  CONSTRAINT ENTDATX_PRIMARY PRIMARY KEY( ENTITYID , PROPERTY , CHANGETIME ) ) ;

ALTER TABLE ENTDATX
  ADD CONSTRAINT ENTDATX_ENTITYID
  FOREIGN KEY( ENTITYID )
  REFERENCES ENTHEAD ( ENTITYID )
  ON DELETE RESTRICT
  ON UPDATE RESTRICT ;

LABEL ON TABLE ENTDATX IS 'Entity Encrypted Date' ;

LABEL ON COLUMN ENTDATX
( ENTITYID IS 'Entity              ID' ,
  PROPERTY IS 'Property            Name' ,
  CHANGETIME IS 'Change              Time                Stamp' ,
  CHANGEJNAM IS 'Change              Job                 Name' ,	
  CHANGEUSER IS 'Change              User                Profile' ,
  CHANGEJNUM IS 'Change              Job                 Number' ,
  CHANGEPROG IS 'Change              Program' ,
  "VALUE" IS 'Current             Value' ) ;

LABEL ON COLUMN ENTDATX
( ENTITYID TEXT IS 'Entity ID' ,
  PROPERTY TEXT IS 'Property Name' ,
  CHANGETIME TEXT IS 'Change Time Stamp' ,
  CHANGEJNAM TEXT IS 'Change Job Name' ,
  CHANGEUSER TEXT IS 'Change User Profile',
  CHANGEJNUM TEXT IS 'Change Job Number' ,
  CHANGEPROG TEXT IS 'Change Program' ,
  "VALUE" TEXT IS 'Current Value' ) ;

CREATE INDEX ENTDATXL0 ON ENTDATX
  (CHANGEJNAM  ASC, CHANGEUSER  ASC, CHANGEJNUM  ASC, CHANGETIME  ASC);

LABEL ON INDEX ENTDATXL0 IS 'Entity Encrypted Date (CHANGEJNAM, CHANGEUSER)';

GRANT SELECT ON TABLE ENTDATX TO PUBLIC;
GRANT INSERT ON TABLE ENTDATX TO PUBLIC;

REVOKE DELETE ON TABLE ENTDATX FROM PUBLIC;
REVOKE UPDATE ON TABLE ENTDATX FROM PUBLIC;

