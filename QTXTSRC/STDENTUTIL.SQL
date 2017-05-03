/******************************************************************************/
/*                                                                            */
/*  Inuendo 1.2 (Alpha release) - STANDARD ENTITY UTILITY FUNCTIONS (SQL)     */
/*                                                                            */
/*  Copyright (C) 2012, 2017  Christopher F. Burns Sr.                        */
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
/*  STATISTICAL FUNCTIONS                                                     */
/******************************************************************************/

CREATE OR REPLACE FUNCTION DELETEENTITY (
  ENTITYID BIGINT,
  CASCADING CHAR(1) )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC DELETEENTITY2
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTUTIL(DELETEENTITY2)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION DELETEENTITY2
  IS 'Delete Entity (w/Cascading Flag)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION DELETEENTITY2
TO PUBLIC ;


CREATE OR REPLACE FUNCTION DELETEENTITY (
  ENTITYID BIGINT )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC DELETEENTITY1
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTUTIL(DELETEENTITY1)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION DELETEENTITY1
  IS 'Delete Entity' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION DELETEENTITY1
TO PUBLIC ;


/******************************************************************************/
/*  ROLL BACK JOB (WITH AND WITHOUT MOMENT)                                   */
/******************************************************************************/

CREATE OR REPLACE FUNCTION ROLLBACKJOB (
  JOBNAME CHAR(10) ,
  JOBUSER CHAR(18) ,
  JOBNUMBER CHAR(6) ,
  MOMENT TIMESTAMP )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC ROLLBACKJOB4
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTUTIL(ROLLBACKJOB4)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ROLLBACKJOB4
  IS 'Roll Back Job (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ROLLBACKJOB4
TO PUBLIC ;


CREATE OR REPLACE FUNCTION ROLLBACKJOB (
  JOBNAME CHAR(10) ,
  JOBUSER CHAR(18) ,
  JOBNUMBER CHAR(6) )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC ROLLBACKJOB3
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTUTIL(ROLLBACKJOB3)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION ROLLBACKJOB3
  IS 'Roll Back Job' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION ROLLBACKJOB3
TO PUBLIC ;


/******************************************************************************/
/*  PREVIOUS MOMENT                                                           */
/******************************************************************************/

CREATE OR REPLACE FUNCTION PREVMOMENT (
  MOMENT TIMESTAMP )
  RETURNS TIMESTAMP
  LANGUAGE RPGLE
  SPECIFIC PREVMOMENT
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME STDENTUTIL(PREVMOMENT)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION PREVMOMENT
  IS 'Previous Moment' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION PREVMOMENT
TO PUBLIC ;

