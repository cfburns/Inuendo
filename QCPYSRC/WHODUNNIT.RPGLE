      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - WHO DONE IT FUNCTIONS (PROTOTYPES & STORAGE)                *
      *                                                                                            *
      *  Copyright (C) 2012, 2019  Christopher F. Burns Sr.                                        *
      *    c/o The Inuendo Project (http://inuendo.us).                                            *
      *                                                                                            *
      *  Use RPG /COPY statement in application programs to include this member.                   *
      *                                                                                            *
      *  This program is free software: you can redistribute it and/or modify                      *
      *  it under the terms of the GNU General Public License as published by                      *
      *  the Free Software Foundation, either version 3 of the License, or                         *
      *  (at your option) any later version.                                                       *
      *                                                                                            *
      *  This program is distributed in the hope that it will be useful,                           *
      *  but WITHOUT ANY WARRANTY; without even the implied warranty of                            *
      *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                             *
      *  GNU General Public License for more details.                                              *
      *                                                                                            *
      *  You should have received a copy of the GNU General Public License                         *
      *  along with this program.  If not, see <http://www.gnu.org/licenses/>.                     *
      *                                                                                            *
      **********************************************************************************************

      **********************************************************************************************
      *  FIRED BY A USER PROGRAM (RPG FRIENDLY)
      **********************************************************************************************

       dcl-pr firedby ind;                                                   // fired by
         pgmnam char(10) const;                                              // program name
         iostm1 char(10) const options(*nopass);                             // i/o statement
         iostm2 char(10) const options(*nopass);                             // i/o statement
         iostm3 char(10) const options(*nopass);                             // i/o statement
         iostm4 char(10) const options(*nopass);                             // i/o statement
         iostm5 char(10) const options(*nopass);                             // i/o statement
       end-pr;                                                               // fired by

      **********************************************************************************************
      *  FIRED BY A USER PROGRAM (SQL FRIENDLY) - 1 PARAMETER
      **********************************************************************************************

       dcl-pr FiredByPgm1 ind;                                               // fired by program
         pgmnam char(10) const;                                              // program name
       end-pr;                                                               // fired by program

      **********************************************************************************************
      *  GUILTY PROGRAM (RPG & SQL FRIENDLY)
      **********************************************************************************************

       dcl-pr GuiltyPgm char(10);                                            // guilty program
         StartPoint char(10) const options(*nopass);                         // starting point
       end-pr;                                                               // guilty program

       dcl-pr GuiltyPgm0 char(10);                                           // guilty program
       end-pr;                                                               // guilty program

      **********************************************************************************************
      *  FIRED BY A PROCEDURE (RPG FRIENDLY)
      **********************************************************************************************

       dcl-pr FiredByProc ind;                                               // fired by procedure
         ProcName   char(32) const;                                          // program name
         ServicePgm char(10) const options(*nopass);                         // service program name
       end-pr;                                                               // fired by procedure

      **********************************************************************************************
      *  FIRED BY A PROCEDURE (SQL FRIENDLY) - 1 PARAMETER
      **********************************************************************************************

       dcl-pr FiredByProc1 ind;                                              // fired by procedure
         ProcName char(32) const;                                            // program name
       end-pr;                                                               // fired by procedure

      **********************************************************************************************
      *  FIRED BY A PROCEDURE (SQL FRIENDLY) - 2 PARAMETERS
      **********************************************************************************************

       dcl-pr FiredByProc2 ind;                                              // fired by procedure
         ProcName   char(32) const;                                          // program name
         ServicePgm char(10) const;                                          // service program name
       end-pr;                                                               // fired by procedure

      **********************************************************************************************
      *  GUILTY OUTPUT PROCEDURE
      **********************************************************************************************

       dcl-pr GuiltyOutputProc varchar(254) end-pr;                          // guilty output proc

      **********************************************************************************************
