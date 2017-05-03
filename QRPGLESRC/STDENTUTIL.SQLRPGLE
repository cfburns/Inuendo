      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY UTILITIES (PROCEDURES)                      *
      *                                                                                            *
      *  Copyright (C) 2012, 2017  Christopher F. Burns Sr.                                        *
      *    c/o The Inuendo Project (http://inuendo.us).                                            *
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

      /copy qcpysrc,stdhsrvpgm                                               // h-spec for srvpgm

      /copy qcpysrc,stdentutil                                               // protytpes, wrk flds
      /copy qcpysrc,stdentinp                                                // protytpes, wrk flds
      /copy qcpysrc,stdentrule                                               // protytpes, wrk flds

      **********************************************************************************************
      *  DELETE AN ENTITY AND LINK DEPENDENCIES (RPG FRIENDLY).
      **********************************************************************************************

       dcl-proc DeleteEntity export;                                         // delete an entity

       dcl-pi DeleteEntity ind;                                              // delete an entity
         EntityID  like(EntHeadU.EntityID) const;                            // entity ID
         Cascading like(EntFlagU.Value)    const options(*nopass);           // cascading allowed
       end-pi;                                                               // delete an entity

       dcl-s ChildIDx     like(EntHeadU.EntityID);                           // child entity ID
       dcl-s LevelX       like(EntPropU.Sequencer);                          // dependence level
       dcl-s CascadingX   like(EntFlagU.Value);                              // cascading allowed
       dcl-s HasChildrenX ind;                                               // has children flag

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       // determine if cascading deletes allowed (on child entities)

       if %parms >= 2;                                                       // if cascade flag pass
         CascadingX = UpperCase(Cascading);                                  // use its value
       endif;                                                                // if cascade flag pass

       HasChildrenX = HasChildren(EntityID);                                 // has children flag

       if HasChildrenX and CascadingX <> 'Y';                                // if children exist
         return *off;                                                        // return a false
       endif;                                                                // if children exist

       // delete any subtable entries for this entity

       exec sql delete from EntDate where EntityID = :EntityID;              // del subtable entries
       exec sql delete from EntFlag where EntityID = :EntityID;              // del subtable entries
       exec sql delete from EntNote where EntityID = :EntityID;              // del subtable entries
       exec sql delete from EntNotx where EntityID = :EntityID;              // del subtable entries
       exec sql delete from EntNumb where EntityID = :EntityID;              // del subtable entries
       exec sql delete from EntNumx where EntityID = :EntityID;              // del subtable entries
       exec sql delete from EntDatx where EntityID = :EntityID;              // del subtable entries

       // for links, delete any subtable entries not only for this entity,
       //   but also any other entry that links to it in this fashion.

       exec sql delete from EntLink where EntityID = :EntityID
                                       or Value    = :EntityID;              // del subtable entries

       // if cascading allowed, delete any descendants

       if CascadingX = 'Y' and HasChildrenX;                                 // if cascading allowed

         exec sql declare DeleteEntityX1 cursor for
           with Candidates (entityid, level) as
             (select a.entityid, 1
                from enthead a where parentid = :EntityID
              union all
              select b.entityid, c.level + 1
                from candidates c, enthead b
                  where b.parentid = c.entityid)
           select entityid, level
             from candidates
               order by 2 desc, 1 desc;                                      // all descendants

         exec sql open DeleteEntityX1;                                       // open cursor
         exec sql fetch from DeleteEntityX1 into :ChildIDx, :LevelX;         // fetch first child

         dow sqlcod = 0;                                                     // while more children
           DeleteEntity(ChildIDx);                                           // delete this child
           exec sql fetch from DeleteEntityX1 into :ChildIDx, :LevelX;       // fetch first child
         enddo;                                                              // while more children

         exec sql close DeleteEntityX1;                                      // close cursor

       endif;                                                                // if cascading allowed

       // finally, delete header

       exec sql delete from EntHead where EntityID = :EntityID;              // del entity header

       // result is false if header was not successfully deleted.

       return (sqlcod = 0);                                                  // true if successful

       end-proc;                                                             // delete an entity

      **********************************************************************************************
      *  DELETE AN ENTITY AND LINK DEPENDENCIES (SQL FRIENDLY - 2 ARGUMENTS)
      **********************************************************************************************

       dcl-proc DeleteEntity2 export;                                        // delete an entity

       dcl-pi DeleteEntity2 ind;                                             // delete an entity
         EntityID  like(EntHeadU.EntityID) const;                            // entity ID
         Cascading like(EntFlagU.Value)    const;                            // cascading allowed
       end-pi;                                                               // delete an entity

       return DeleteEntity(EntityID : Cascading);                            // true if successful

       end-proc;                                                             // delete an entity

      **********************************************************************************************
      *  DELETE AN ENTITY AND LINK DEPENDENCIES (SQL FRIENDLY - 1 ARGUMENT)
      **********************************************************************************************

       dcl-proc DeleteEntity1 export;                                        // delete an entity

       dcl-pi DeleteEntity1 ind;                                             // delete an entity
         EntityID like(EntHeadU.EntityID) const;                             // entity ID
       end-pi;                                                               // delete an entity

       return DeleteEntity(EntityID);                                        // true if successful

       end-proc;                                                             // delete an entity

      **********************************************************************************************
      *  ROLLBACK A JOB TO AN OPTIONAL MOMENT (RPG FRIENDLY)
      **********************************************************************************************

       dcl-proc RollbackJob export;                                          // rollback a job

       dcl-pi RollbackJob ind;                                               // rollback a job
         JobName   like(EntHeadU.CreateJnam) const;                          // job name
         JobUser   like(EntHeadU.CreateUser) const;                          // job user profile
         JobNumber like(EntHeadU.CreateJnum) const;                          // job number
         Moment    like(EntHeadU.CreateTime) const options(*nopass);         // moment in time
       end-pi;                                                               // rollback a job

       dcl-s EntityIDx like(EntHeadU.EntityID);                              // entity ID work field
       dcl-s MomentX   like(EntHeadU.CreateTime);                            // moment in time

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       // Initialize the Moment if not specified.

       monitor;                                                              // catch format errors

         if %parms >= 4;                                                     // if moment passed
           MomentX = Moment;                                                 // use that moment
         else;                                                               // moment not passed
           MomentX = *loval;                                                 // assume life of job
         endif;                                                              // if moment passed

       on-error *all;                                                        // on any error
         MomentX = *loval;                                                   // assume life of job

       endmon;                                                               // catch format errors

       // Delete any subtable entries for this job since the specifed Moment.

       exec sql delete from EntDate
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       exec sql delete from EntFlag
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       exec sql delete from EntLink
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       exec sql delete from EntNote
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       exec sql delete from EntNotx
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       exec sql delete from EntNumb
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       exec sql delete from EntNumx
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       exec sql delete from EntDatx
         where ChangeJnam  = :JobName
           and ChangeUser  = :JobUser
           and ChangeJnum  = :JobNumber
           and ChangeTime >= :MomentX;                                       // del subtable entries

       // Determine any entities created by this job since the specifed Moment
       //   and delete them.  Remember that DeleteEntity will remove any link
       //   dependencies to the specified entity.

       exec sql declare RollBackJobX1 cursor for
         select entityid from enthead
           where CreateJnam  = :JobName
             and CreateUser  = :JobUser
             and CreateJnum  = :JobNumber
             and CreateTime >= :MomentX
               order by 1 desc;                                              // ent created this job

       exec sql open RollBackJobX1;                                          // open cursor
       exec sql fetch from RollBackJobX1 into :EntityIDx;                    // get first entity

       dow sqlcod = 0;                                                       // while more entities
         DeleteEntity(EntityIDx);                                            // delete entirely
         exec sql fetch from RollBackJobX1 into :EntityIDx;                  // get next entity
       enddo;                                                                // while more entities

       exec sql close RollBackJobX1;                                         // close cursor

       return (sqlcod = 0);                                                  // true if successful

       end-proc;                                                             // rollback a job

      **********************************************************************************************
      *  ROLLBACK A JOB (SQL FRIENDLY - 4 ARGUMENTS)
      **********************************************************************************************

       dcl-proc RollbackJob4 export;                                         // rollback a job

       dcl-pi RollbackJob4 ind;                                              // rollback a job
         JobName   like(EntHeadU.CreateJnam) const;                          // job name
         JobUser   like(EntHeadU.CreateUser) const;                          // job user profile
         JobNumber like(EntHeadU.CreateJnum) const;                          // job number
         Moment    like(EntHeadU.CreateTime) const;                          // moment in time
       end-pi;                                                               // rollback a job

       return RollbackJob(JobName : JobUser : JobNumber : Moment);           // true if successful

       end-proc;                                                             // rollback a job

      **********************************************************************************************
      *  ROLLBACK A JOB (SQL FRIENDLY - 3 ARGUMENTS)
      **********************************************************************************************

       dcl-proc RollbackJob3 export;                                         // rollback a job

       dcl-pi RollbackJob3 ind;                                              // rollback a job
         JobName   like(EntHeadU.CreateJnam) const;                          // job name
         JobUser   like(EntHeadU.CreateUser) const;                          // job user profile
         JobNumber like(EntHeadU.CreateJnum) const;                          // job number
       end-pi;                                                               // rollback a job

       return RollbackJob(JobName : JobUser : JobNumber);                    // true if successful

       end-proc;                                                             // rollback a job

      **********************************************************************************************
      *  PREVIOUS MOMENT
      **********************************************************************************************

      *  Calculates the moment precisely one millisecond prior to the specified
      *    moment.  Used mainly for rollback integrity.

       dcl-proc PrevMoment export;                                           // previous moment

       dcl-pi PrevMoment like(EntHeadU.CreateTime);                          // previous moment
         Moment like(EntHeadU.CreateTime) const;                             // based on moment
       end-pi;                                                               // previous moment

       return (Moment - %mseconds(1));                                       // previous moment

       end-proc;                                                             // previous moment

      **********************************************************************************************
