      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY UTILITIES (PROTOTYPES & STORAGE)            *
      *                                                                                            *
      *  Copyright (C) 2012, 2017  Christopher F. Burns Sr.                                        *
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
      *  DELETE AN ENTITY AND LINK DEPENDENCIES (RPG FRIENDLY)
      **********************************************************************************************

       dcl-pr DeleteEntity ind;                                              // delete an entity
         EntityID  like(EntHeadU.EntityID) const;                            // entity ID
         Cascading like(EntFlagU.Value)    const options(*nopass);           // cascading allowed
       end-pr;                                                               // delete an entity

      **********************************************************************************************
      *  DELETE AN ENTITY AND LINK DEPENDENCIES (SQL FRIENDLY - 2 ARGUMENTS)
      **********************************************************************************************

       dcl-pr DeleteEntity2 ind;                                             // delete an entity
         EntityID  like(EntHeadU.EntityID) const;                            // entity ID
         Cascading like(EntFlagU.Value)    const;                            // cascading allowed
       end-pr;                                                               // delete an entity

      **********************************************************************************************
      *  DELETE AN ENTITY AND LINK DEPENDENCIES (SQL FRIENDLY - 1 ARGUMENT)
      **********************************************************************************************

       dcl-pr DeleteEntity1 ind;                                             // delete an entity
         EntityID like(EntHeadU.EntityID) const;                             // entity ID
       end-pr;                                                               // delete an entity

      **********************************************************************************************
      *  ROLLBACK A JOB (RPG FRIENDLY)
      **********************************************************************************************

       dcl-pr RollbackJob ind;                                               // rollback a job
         JobName   like(EntHeadU.CreateJnam) const;                          // job name
         JobUser   like(EntHeadU.CreateUser) const;                          // job user profile
         JobNumber like(EntHeadU.CreateJnum) const;                          // job number
         Moment    like(EntHeadU.CreateTime) const options(*nopass);         // moment in time
       end-pr;                                                               // rollback a job

      **********************************************************************************************
      *  ROLLBACK A JOB (SQL FRIENDLY - 4 ARGUMENTS)
      **********************************************************************************************

       dcl-pr RollbackJob4 ind;                                              // rollback a job
         JobName   like(EntHeadU.CreateJnam) const;                          // job name
         JobUser   like(EntHeadU.CreateUser) const;                          // job user profile
         JobNumber like(EntHeadU.CreateJnum) const;                          // job number
         Moment    like(EntHeadU.CreateTime) const;                          // moment in time
       end-pr;                                                               // rollback a job

      **********************************************************************************************
      *  ROLLBACK A JOB (SQL FRIENDLY - 3 ARGUMENTS)
      **********************************************************************************************

       dcl-pr RollbackJob3 ind;                                              // rollback a job
         JobName   like(EntHeadU.CreateJnam) const;                          // job name
         JobUser   like(EntHeadU.CreateUser) const;                          // job user profile
         JobNumber like(EntHeadU.CreateJnum) const;                          // job number
       end-pr;                                                               // rollback a job

      **********************************************************************************************
      *  PREVIOUS MOMENT
      **********************************************************************************************

       dcl-pr PrevMoment like(EntHeadU.CreateTime);                          // previous moment
         Moment like(EntHeadU.CreateTime) const;                             // based on moment
       end-pr;                                                               // previous moment

      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntHeadU ext extname('ENTHEAD') qualified template end-ds;     // record template
       dcl-ds EntPropU ext extname('ENTPROP') qualified template end-ds;     // record template
       dcl-ds EntDateU ext extname('ENTDATE') qualified template end-ds;     // record template
       dcl-ds EntFlagU ext extname('ENTFLAG') qualified template end-ds;     // record template
       dcl-ds EntLinkU ext extname('ENTLINK') qualified template end-ds;     // record template
       dcl-ds EntNoteU ext extname('ENTNOTE') qualified template end-ds;     // record template
       dcl-ds EntNumbU ext extname('ENTNUMB') qualified template end-ds;     // record template
       dcl-ds EntNotxU ext extname('ENTNOTX') qualified template end-ds;     // record template
       dcl-ds EntNumxU ext extname('ENTNUMX') qualified template end-ds;     // record template
       dcl-ds EntDatxU ext extname('ENTDATX') qualified template end-ds;     // record template

