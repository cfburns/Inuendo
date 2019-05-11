/******************************************************************************/
/*                                                                            */
/*  Inuendo 1.2 (Alpha release) - STANDARD ENTITY AGGREGATE FUNCTIONS (SQL)   */
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
/*  AVERAGE FUNCTIONS                                                         */
/******************************************************************************/

CREATE OR REPLACE FUNCTION ENTITYAVG (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14) ,
  MOMENT TIMESTAMP )
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYAVGM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYAVGM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYAVGM
  IS 'Entity Average (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYAVGM
TO PUBLIC ;


CREATE OR REPLACE FUNCTION ENTITYAVG (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14))
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYAVG
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYAVG)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYAVG
  IS 'Entity Average' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYAVG
TO PUBLIC ;


/******************************************************************************/
/*  MAXIMUM FUNCTIONS                                                         */
/******************************************************************************/

CREATE OR REPLACE FUNCTION ENTITYMAX (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14) ,
  MOMENT TIMESTAMP )
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYMAXM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYMAXM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYMAXM
  IS 'Entity Maximum (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYMAXM
TO PUBLIC ;


CREATE OR REPLACE FUNCTION ENTITYMAX (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14))
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYMAX
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYMAX)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYMAX
  IS 'Entity Maximum' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYMAX
TO PUBLIC ;


/******************************************************************************/
/*  MINIMUM FUNCTIONS                                                         */
/******************************************************************************/

CREATE OR REPLACE FUNCTION ENTITYMIN (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14) ,
  MOMENT TIMESTAMP )
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYMINM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYMINM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYMINM
  IS 'Entity Minimum (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYMINM
TO PUBLIC ;


CREATE OR REPLACE FUNCTION ENTITYMIN (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14))
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYMIN
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYMIN)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYMIN
  IS 'Entity Maximum' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYMIN
TO PUBLIC ;


/******************************************************************************/
/*  SUM FUNCTIONS                                                             */
/******************************************************************************/

CREATE OR REPLACE FUNCTION ENTITYSUM (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14) ,
  MOMENT TIMESTAMP )
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYSUMM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYSUMM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYSUMM
  IS 'Entity Sum (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYSUMM
TO PUBLIC ;


CREATE OR REPLACE FUNCTION ENTITYSUM (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  PROPERTY VARCHAR(14))
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYSUM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYSUM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYSUM
  IS 'Entity Sum' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYSUM
TO PUBLIC ;


/******************************************************************************/
/*  COUNT FUNCTIONS                                                           */
/******************************************************************************/

CREATE OR REPLACE FUNCTION ENTITYCOUNT (
  ENTITYID BIGINT,
  CLASS VARCHAR(14) ,
  MOMENT TIMESTAMP )
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYCOUNTM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYCOUNTM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYCOUNTM
  IS 'Entity Count (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYCOUNTM
TO PUBLIC ;


CREATE OR REPLACE FUNCTION ENTITYCOUNT (
  ENTITYID BIGINT,
  CLASS VARCHAR(14))
  RETURNS DECIMAL(25, 7)
  LANGUAGE RPGLE
  SPECIFIC ENTITYCOUNT
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTAGGR(ENTITYCOUNT)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ENTITYCOUNT
  IS 'Entity Count' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ENTITYCOUNT
TO PUBLIC ;


