/******************************************************************************/
/*                                                                            */
/*  Inuendo 1.2 (Alpha release) - WHO DONE IT FUNCTIONS (SQL)                 */
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
/*  FIRED BY PROGRAM                                                          */
/******************************************************************************/

CREATE OR REPLACE FUNCTION FIREDBYPGM (
  PROGNAME CHAR(10) )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC FIREDBYPGM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME WHODUNNIT(FIREDBYPGM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION FIREDBYPGM
  IS 'Fired By Program' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION FIREDBYPGM
TO PUBLIC ;


/******************************************************************************/
/*  GUILTY PROGRAM                                                            */
/******************************************************************************/

CREATE OR REPLACE FUNCTION GUILTYPGM (
  STARTPOINT CHAR(10) )
  RETURNS CHAR(10)
  LANGUAGE RPGLE
  SPECIFIC GUILTYPGM
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME WHODUNNIT(GUILTYPGM)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION GUILTYPGM
  IS 'Guilty Program' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION GUILTYPGM
TO PUBLIC ;


/******************************************************************************/
/*  FIRED BY PROCEDURE (WITH AND WITHOUT SERVICE PROGRAM)                     */
/******************************************************************************/

CREATE OR REPLACE FUNCTION FIREDBYPROC (
  PROCNAME CHAR(32) ,
  SERVICEPGM CHAR(10) )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC FIREDBYPROC2
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME WHODUNNIT(FIREDBYPROC2)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION FIREDBYPROC2
  IS 'Roll Back Job (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION FIREDBYPROC2
TO PUBLIC ;


CREATE OR REPLACE FUNCTION FIREDBYPROC (
  PROCNAME CHAR(32) )
  RETURNS CHAR(1)
  LANGUAGE RPGLE
  SPECIFIC FIREDBYPROC1
  NOT DETERMINISTIC
  NOT FENCED
  PROGRAM TYPE SUB
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  EXTERNAL NAME WHODUNNIT(FIREDBYPROC1)
  PARAMETER STYLE GENERAL ;

COMMENT ON SPECIFIC FUNCTION FIREDBYPROC1
  IS 'Roll Back Job (w/Moment)' ;

GRANT ALTER , EXECUTE
ON SPECIFIC FUNCTION FIREDBYPROC1
TO PUBLIC ;

