      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY AGGREGATE FUNCTIONS                         *
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

      /copy qcpysrc,stdhsrvpgm                                               // h-spec for srvpgm

      /copy qcpysrc,stdentinp                                                // protytpes, wrk flds
      /copy qcpysrc,stdentaggr                                               // protytpes, wrk flds


      **********************************************************************************************
      *  AVERAGE FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-proc EntityAvgM export;                                           // entity child avg

       dcl-pi EntityAvgM like(EntNumbA.Value);                               // entity child avg
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pi;                                                               // entity child avg

       return
         EntityAggregation(EntityID : Class : Property : 'AVG' : Moment);    // aggregate average

       end-proc;                                                             // entity child avg

      **********************************************************************************************

       dcl-proc EntityAvg export;                                            // entity child avg

       dcl-pi EntityAvg like(EntNumbA.Value);                                // entity child avg
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pi;                                                               // entity child avg

       return
         EntityAggregation(EntityID : Class : Property : 'AVG');             // aggregate average

       end-proc;                                                             // entity child avg


      **********************************************************************************************
      *  MAXIMUM FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-proc EntityMaxM export;                                           // entity child max

       dcl-pi EntityMaxM like(EntNumbA.Value);                               // entity child max
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pi;                                                               // entity child max

       return
         EntityAggregation(EntityID : Class : Property : 'MAX' : Moment);    // aggregate maximum

       end-proc;                                                             // entity child max

      **********************************************************************************************

       dcl-proc EntityMax export;                                            // entity child max

       dcl-pi EntityMax like(EntNumbA.Value);                                // entity child max
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pi;                                                               // entity child max

       return
         EntityAggregation(EntityID : Class : Property : 'MAX');             // aggregate maximum

       end-proc;                                                             // entity child max


      **********************************************************************************************
      *  MINIMUM FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-proc EntityMinM export;                                           // entity child min

       dcl-pi EntityMinM like(EntNumbA.Value);                               // entity child min
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pi;                                                               // entity child min

       return
         EntityAggregation(EntityID : Class : Property : 'MIN' : Moment);    // aggregate minimum

       end-proc;                                                             // entity child min

      **********************************************************************************************

       dcl-proc EntityMin export;                                            // entity child min

       dcl-pi EntityMin like(EntNumbA.Value);                                // entity child min
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pi;                                                               // entity child min

       return
         EntityAggregation(EntityID : Class : Property : 'MIN');             // aggregate minimum

       end-proc;                                                             // entity child min


      **********************************************************************************************
      *  SUM FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-proc EntitySumM export;                                           // entity child sum

       dcl-pi EntitySumM like(EntNumbA.Value);                               // entity child sum
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pi;                                                               // entity child sum

       return
         EntityAggregation(EntityID : Class : Property : 'SUM' : Moment);    // aggregate sum

       end-proc;                                                             // entity child sum

      **********************************************************************************************

       dcl-proc EntitySum export;                                            // entity child sum

       dcl-pi EntitySum like(EntNumbA.Value);                                // entity child sum
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pi;                                                               // entity child sum

       return
         EntityAggregation(EntityID : Class : Property : 'SUM');             // aggregate minimum

       end-proc;                                                             // entity child sum


      **********************************************************************************************
      *  COUNT FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-proc EntityCountM export;                                         // entity child count

       dcl-pi EntityCountM like(EntNumbA.Value);                             // entity child count
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pi;                                                               // entity child count

       dcl-s PropertyX like(EntNumbA.Property) inz('LEGACYN');               // property nickname

       return
         EntityAggregation(EntityID : Class : PropertyX : 'CNT' : Moment);   // aggregate sum

       end-proc;                                                             // entity child count

      **********************************************************************************************

       dcl-proc EntityCount export;                                          // entity child count

       dcl-pi EntityCount like(EntNumbA.Value);                              // entity child count
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
       end-pi;                                                               // entity child count

       dcl-s PropertyX like(EntNumbA.Property) inz('LEGACYN');               // property nickname

       return
         EntityAggregation(EntityID : Class : PropertyX : 'CNT');            // aggregate count

       end-proc;                                                             // entity child count


      **********************************************************************************************
      *  SUPPORTING FUNCTIONS
      **********************************************************************************************

       dcl-proc EntityAggregation;                                           // entity aggregation

       dcl-pi EntityAggregation like(EntNumbA.Value);                        // entity aggregation
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Function   like(AggrFunction)        const;                         // aggregation function
         Moment     like(EntNumbA.ChangeTime) const options(*nopass);        // change time stamp
       end-pi;                                                               // entity aggregation

       dcl-s ResultX   like(EntNumbA.Value);                                 // result work field
       dcl-s ClassX    like(EntHeadA.Class);                                 // entity class
       dcl-s PropertyX like(EntNumbA.Property);                              // property nickname
       dcl-s FunctionX like(AggrFunction);                                   // function work field
       dcl-s MomentX   like(EntHeadA.CreateTime);                            // moment in time

       ClassX    = UpperCase(Class);                                         // class in uppercase
       PropertyX = UpperCase(Property);                                      // prop in uppercase

       if ValidClassProperty(ClassX : PropertyX : 'NUMB');                   // if valid class

         if %parms >= 5;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         FunctionX = UpperCase(Function);                                    // upper cased function

         exec sql
           select case when :FunctionX = 'AVG'
                         then avg(getNumb(entityID, :PropertyX, :MomentX))
                       when :FunctionX = 'MAX'
                         then max(getNumb(entityID, :PropertyX, :MomentX))
                       when :FunctionX = 'MIN'
                         then min(getNumb(entityID, :PropertyX, :MomentX))
                       when :FunctionX = 'SUM'
                         then sum(getNumb(entityID, :PropertyX, :MomentX))
                       when :FunctionX = 'CNT'
                         then count(*)
                       else 0 end into :ResultX
             from enthead
               where ParentID = :EntityID and Class = :ClassX
                 and (:FunctionX != 'CNT' or CreateTime <= :MomentX);       // aggregate function

       endif;                                                                // if valid class

       return ResultX;                                                       // result of aggr func

       end-proc;                                                             // entity aggregation

