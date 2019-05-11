/******************************************************************************/
/*                                                                            */
/*  Inuendo 1.2 (Alpha release) - STANDARD ENTITY BUSINESS RULES (SQL)        */
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
/*  DETERMINE ANCESTOR OF A SPECIFIED CLASS, FOR AN EXISTING DESCENDANT       */
/******************************************************************************/

CREATE OR REPLACE FUNCTION ANCESTOR (
  DESCENDANT BIGINT ,
  ANCESCLASS VARCHAR(14) )
  RETURNS BIGINT
  LANGUAGE RPGLE
  SPECIFIC ANCESTOR
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTRULE(ANCESTOR)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ANCESTOR
  IS 'Entity Ancestor' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ANCESTOR
TO PUBLIC ;


/******************************************************************************/
/*  DETERMINE WHETHER AN ENTITY HAS SUBORDINATE ENTITIES (A.K.A. CHILDREN)    */
/******************************************************************************/

CREATE OR REPLACE FUNCTION HASCHILDREN (
  ENTITYID BIGINT )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC HASCHILDREN
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTRULE(HASCHILDREN)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION HASCHILDREN
  IS 'Entity Has Children' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION HASCHILDREN
TO PUBLIC ;


/******************************************************************************/
/*  PROPERTY LIFE HISTORY - RESULT SET (WITH & WITHOUT MOMENT PARAMETER)      */
/******************************************************************************/

CREATE OR REPLACE PROCEDURE PROPERTYLIFE (
  IN ENTITYID BIGINT ,
  IN PROPERTY VARCHAR(14) ,
  IN MOMENT TIMESTAMP )
  DYNAMIC RESULT SETS 1
  LANGUAGE RPGLE
  SPECIFIC PROPERTYLIFEM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTSQL2(PROPERTYLIFE3)
  PARAMETER STYLE GENERAL;

COMMENT ON SPECIFIC PROCEDURE PROPERTYLIFEM
  IS 'Entity Property Life' ;

GRANT ALTER , EXECUTE
ON SPECIFIC PROCEDURE PROPERTYLIFEM
TO PUBLIC ;


CREATE OR REPLACE PROCEDURE PROPERTYLIFE (
  IN ENTITY BIGINT ,
  IN PROPERTY VARCHAR(14) )
  DYNAMIC RESULT SETS 1
  LANGUAGE RPGLE
  SPECIFIC PROPERTYLIFE
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTSQL2(PROPERTYLIFE2)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC PROCEDURE PROPERTYLIFE
  IS 'Entity Property Life' ;

GRANT ALTER , EXECUTE
ON SPECIFIC PROCEDURE PROPERTYLIFE
TO PUBLIC ;


/******************************************************************************/
/*  ENTITY PROFILE SNAPSHOT - RESULT SET (WITH & WITHOUT MOMENT PARAMETER)    */
/******************************************************************************/

CREATE OR REPLACE PROCEDURE SNAPSHOT (
  IN ENTITYID BIGINT ,
  IN MOMENT TIMESTAMP )
  DYNAMIC RESULT SETS 1
  LANGUAGE RPGLE
  SPECIFIC SNAPSHOTM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTSQL2(SHAPSHOT2)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC PROCEDURE SNAPSHOTM
  IS 'Entity Snapshot' ;

GRANT ALTER , EXECUTE
ON SPECIFIC PROCEDURE SNAPSHOTM
TO PUBLIC ;


CREATE OR REPLACE PROCEDURE SNAPSHOT (
  IN ENTITYID BIGINT )
  DYNAMIC RESULT SETS 1
  LANGUAGE RPGLE
  SPECIFIC SNAPSHOT
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTSQL2(SNAPSHOT1)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC PROCEDURE SNAPSHOT
  IS 'Entity Snapshot' ;

GRANT ALTER , EXECUTE
ON SPECIFIC PROCEDURE SNAPSHOT
TO PUBLIC ;


/******************************************************************************/
/*  ENTITY LIST FOR SEARCH FUNCTIONS                                          */
/******************************************************************************/

CREATE OR REPLACE PROCEDURE ENTITYLIST (
 IN PARENTID BIGINT ,
 IN CLASS VARCHAR(14) ,
 IN LEGACYA VARCHAR(254) ,
 IN LEGACYN BIGINT ,
 IN "DESCRIPTOR" VARCHAR(254) )
 DYNAMIC RESULT SETS 1
 LANGUAGE RPGLE
 SPECIFIC ENTITYLIST
 NOT DETERMINISTIC
 MODIFIES SQL DATA
 CALLED ON NULL INPUT
 EXTERNAL NAME STDENTRULE(ENTITYLIST)
 PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC PROCEDURE ENTITYLIST
 IS 'Entity List For Search Functions' ;

GRANT ALTER , EXECUTE
ON SPECIFIC PROCEDURE ENTITYLIST
TO PUBLIC ;


/******************************************************************************/
/*  ENTITY LIFE HISTORY - RESULT SET (WITH & WITHOUT MOMENT PARAMETER)        */
/******************************************************************************/

CREATE OR REPLACE PROCEDURE ENTITYLIFE (
  IN ENTITYID BIGINT ,
  IN MOMENT TIMESTAMP )
  DYNAMIC RESULT SETS 1
  LANGUAGE RPGLE
  SPECIFIC ENTITYLIFEM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTSQL2(ENTITYLIFE2)
  PARAMETER STYLE GENERAL;

COMMENT ON SPECIFIC PROCEDURE ENTITYLIFEM
  IS 'Entity Life' ;

GRANT ALTER , EXECUTE
ON SPECIFIC PROCEDURE ENTITYLIFEM
TO PUBLIC ;


CREATE OR REPLACE PROCEDURE ENTITYLIFE (
  IN ENTITY BIGINT )
  DYNAMIC RESULT SETS 1
  LANGUAGE RPGLE
  SPECIFIC ENTITYLIFE
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTSQL2(ENTITYLIFE1)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC PROCEDURE ENTITYLIFE
  IS 'Entity Life' ;

GRANT ALTER , EXECUTE
ON SPECIFIC PROCEDURE ENTITYLIFE
TO PUBLIC ;


