      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 - STANDARD ENTITY GROUP FUNCTIONS (PROCEDURES)                                *
      *                                                                                            *
      *  Copyright (C) 2012, 2019  Christopher F. Burns Sr.                                        *
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
      /copy qcpysrc,stdentinp                                                // std ent input funcs
      /copy qcpysrc,stdentgrp                                                // std ent rules


      **********************************************************************************************
      *  FUNCTIONS BASED ON DATE PROPERTIES
      **********************************************************************************************

       // all parameters

       dcl-proc EntityGroupDate export;                                      // entity group by date

       dcl-pi EntityGroupDate;                                               // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const options(*nopass);        // value range high
         Moment     like(EntDateG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by date

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntDateG.Value);                              // value range low
       dcl-s RangeHighX   like(EntDateG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       // if only a range low value passed, set range high value to match

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if range hi provided
           RangeHighX = RangeHigh;                                           // use it
         else;                                                               // no range hi provided
           RangeHighX = RangeLow;                                            // duplicate low value
         endif;                                                              // if range hi provided

         if %parms >= 6;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if RangeLow > RangeHighX;                                           // if out of sequence
           RangeLowX  = RangeHighX;                                          // swap positions
           RangeHighX = RangeLow;                                            // swap positions
         else;                                                               // in proper sequence
           RangeLowX  = RangeLow;                                            // range value low
         endif;                                                              // if out of sequence

         // headers for any relevant entities with matching date property value.

         exec sql declare EntityGroupDateC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getDate(entityID, :Property, :MomentX)
                     between :RangeLowX and :RangeHighX
                order by entityid;                                           // entities w/match

         exec sql open EntityGroupDateC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by date

      **********************************************************************************************

       // low and high range value, with moment parameter

       dcl-proc EntityGroupDateRangeM export;                                // entity group by date

       dcl-pi EntityGroupDateRangeM;                                         // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
         Moment     like(EntDateG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by date

       EntityGroupDate(ParentID : Class     : Property :
                       RangeLow : RangeHigh : Moment);                       // pass op-descriptor

       end-proc;                                                             // entity group by date

      **********************************************************************************************

       // low and high range value, no moment parameter

       dcl-proc EntityGroupDateRange export;                                 // entity group by date

       dcl-pi EntityGroupDateRange;                                          // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
       end-pi;                                                               // entity group by date

       EntityGroupDate(ParentID : Class : Property : RangeLow : RangeHigh);  // pass op-descriptor

       end-proc;                                                             // entity group by date

      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupDateValueM export;                                // entity group by date

       dcl-pi EntityGroupDateValueM;                                         // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
         Moment     like(EntDateG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by date

       EntityGroupDate(ParentID : Class    : Property :
                       Value    : Value    : Moment);                        // pass op-descriptor

       end-proc;                                                             // entity group by date

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupDateValue export;                                 // entity group by date

       dcl-pi EntityGroupDateValue;                                          // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by date

       EntityGroupDate(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by date


      **********************************************************************************************
      *  FUNCTIONS BASED ON FLAG PROPERTIES
      **********************************************************************************************

       // all parameters

       dcl-proc EntityGroupFlag export;                                      // entity group by flag

       dcl-pi EntityGroupFlag;                                               // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntFlagG.Value)      const;                         // value range low
         RangeHigh  like(EntFlagG.Value)      const options(*nopass);        // value range high
         Moment     like(EntFlagG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by flag

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntFlagG.Value);                              // value range low
       dcl-s RangeHighX   like(EntFlagG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       // if only a range low value passed, set range high value to match

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if range hi provided
           RangeHighX = RangeHigh;                                           // use it
         else;                                                               // no range hi provided
           RangeHighX = RangeLow;                                            // duplicate low value
         endif;                                                              // if range hi provided

         if %parms >= 6;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if RangeLow > RangeHighX;                                           // if out of sequence
           RangeLowX  = RangeHighX;                                          // swap positions
           RangeHighX = RangeLow;                                            // swap positions
         else;                                                               // in proper sequence
           RangeLowX  = RangeLow;                                            // range value low
         endif;                                                              // if out of sequence

         // headers for any relevant entities with matching flag property value.

         exec sql declare EntityGroupFlagC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getFlag(entityID, :Property, :MomentX)
                     between :RangeLowX and :RangeHighX
                order by entityid;                                           // entities w/match

         exec sql open EntityGroupFlagC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by flag

      **********************************************************************************************

       // low and high range value, with moment parameter

       dcl-proc EntityGroupFlagRangeM export;                                // entity group by flag

       dcl-pi EntityGroupFlagRangeM;                                         // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntFlagG.Value)      const;                         // value range low
         RangeHigh  like(EntFlagG.Value)      const;                         // value range high
         Moment     like(EntFlagG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by flag

       EntityGroupFlag(ParentID : Class     : Property :
                       RangeLow : RangeHigh : Moment);                       // pass op-descriptor

       end-proc;                                                             // entity group by flag

      **********************************************************************************************

       // low and high range value, no moment parameter

       dcl-proc EntityGroupFlagRange export;                                 // entity group by flag

       dcl-pi EntityGroupFlagRange;                                          // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntFlagG.Value)      const;                         // value range low
         RangeHigh  like(EntFlagG.Value)      const;                         // value range high
       end-pi;                                                               // entity group by flag

       EntityGroupFlag(ParentID : Class : Property : RangeLow : RangeHigh);  // pass op-descriptor

       end-proc;                                                             // entity group by flag

      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupFlagValueM export;                                // entity group by flag

       dcl-pi EntityGroupFlagValueM;                                         // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntFlagG.Value)      const;                         // comparison value
         Moment     like(EntFlagG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by flag

       EntityGroupFlag(ParentID : Class    : Property :
                       Value    : Value    : Moment);                        // pass op-descriptor

       end-proc;                                                             // entity group by flag

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupFlagValue export;                                 // entity group by flag

       dcl-pi EntityGroupFlagValue;                                          // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntFlagG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by flag

       EntityGroupFlag(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by flag


      **********************************************************************************************
      *  FUNCTIONS BASED ON NOTE PROPERTIES
      **********************************************************************************************

       // all parameters

       dcl-proc EntityGroupNote export;                                      // entity group by note

       dcl-pi EntityGroupNote;                                               // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNoteG.Value)      const;                         // value range low
         RangeHigh  like(EntNoteG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNoteG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by note

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntNoteG.Value);                              // value range low
       dcl-s RangeHighX   like(EntNoteG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       // if only a range low value passed, set range high value to match

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if range hi provided
           RangeHighX = RangeHigh;                                           // use it
         else;                                                               // no range hi provided
           RangeHighX = RangeLow;                                            // duplicate low value
         endif;                                                              // if range hi provided

         if %parms >= 6;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if RangeLow > RangeHighX;                                           // if out of sequence
           RangeLowX  = RangeHighX;                                          // swap positions
           RangeHighX = RangeLow;                                            // swap positions
         else;                                                               // in proper sequence
           RangeLowX  = RangeLow;                                            // range value low
         endif;                                                              // if out of sequence

         // headers for any relevant entities with matching note property value.

         exec sql declare EntityGroupNoteC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getNote(entityID, :Property, :MomentX)
                     between :RangeLowX and :RangeHighX
                order by entityid;                                           // entities w/match

         exec sql open EntityGroupNoteC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by note

      **********************************************************************************************

       // low and high range value, with moment parameter

       dcl-proc EntityGroupNoteRangeM export;                                // entity group by note

       dcl-pi EntityGroupNoteRangeM;                                         // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNoteG.Value)      const;                         // value range low
         RangeHigh  like(EntNoteG.Value)      const;                         // value range high
         Moment     like(EntNoteG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by note

       EntityGroupNote(ParentID : Class     : Property :
                       RangeLow : RangeHigh : Moment);                       // pass op-descriptor

       end-proc;                                                             // entity group by note

      **********************************************************************************************

       // low and high range value, no moment parameter

       dcl-proc EntityGroupNoteRange export;                                 // entity group by note

       dcl-pi EntityGroupNoteRange;                                          // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNoteG.Value)      const;                         // value range low
         RangeHigh  like(EntNoteG.Value)      const;                         // value range high
       end-pi;                                                               // entity group by note

       EntityGroupNote(ParentID : Class : Property : RangeLow : RangeHigh);  // pass op-descriptor

       end-proc;                                                             // entity group by note

      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupNoteValueM export;                                // entity group by note

       dcl-pi EntityGroupNoteValueM;                                         // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNoteG.Value)      const;                         // comparison value
         Moment     like(EntNoteG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by note

       EntityGroupNote(ParentID : Class    : Property :
                       Value    : Value    : Moment);                        // pass op-descriptor

       end-proc;                                                             // entity group by note

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupNoteValue export;                                 // entity group by note

       dcl-pi EntityGroupNoteValue;                                          // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNoteG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by note

       EntityGroupNote(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by note


      **********************************************************************************************
      *  FUNCTIONS BASED ON NUMBER PROPERTIES
      **********************************************************************************************

       // all parameters

       dcl-proc EntityGroupNumb export;                                      // entity group by numb

       dcl-pi EntityGroupNumb;                                               // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumbG.Value)      const;                         // value range low
         RangeHigh  like(EntNumbG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNumbG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by numb

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntNumbG.Value);                              // value range low
       dcl-s RangeHighX   like(EntNumbG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       // if only a range low value passed, set range high value to match

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if range hi provided
           RangeHighX = RangeHigh;                                           // use it
         else;                                                               // no range hi provided
           RangeHighX = RangeLow;                                            // duplicate low value
         endif;                                                              // if range hi provided

         if %parms >= 6;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if RangeLow > RangeHighX;                                           // if out of sequence
           RangeLowX  = RangeHighX;                                          // swap positions
           RangeHighX = RangeLow;                                            // swap positions
         else;                                                               // in proper sequence
           RangeLowX  = RangeLow;                                            // range value low
         endif;                                                              // if out of sequence

         // headers for any relevant entities with matching number property value.

         exec sql declare EntityGroupNumbC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getNumb(entityID, :Property, :MomentX)
                     between :RangeLowX and :RangeHighX
                order by entityid;                                           // entities w/match

         exec sql open EntityGroupNumbC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by numb

      **********************************************************************************************

       // low and high range value, with moment parameter

       dcl-proc EntityGroupNumbRangeM export;                                // entity group by numb

       dcl-pi EntityGroupNumbRangeM;                                         // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumbG.Value)      const;                         // value range low
         RangeHigh  like(EntNumbG.Value)      const;                         // value range high
         Moment     like(EntNumbG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by numb

       EntityGroupNumb(ParentID : Class     : Property :
                       RangeLow : RangeHigh : Moment);                       // pass op-descriptor

       end-proc;                                                             // entity group by numb

      **********************************************************************************************

       // low and high range value, no moment parameter

       dcl-proc EntityGroupNumbRange export;                                 // entity group by numb

       dcl-pi EntityGroupNumbRange;                                          // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumbG.Value)      const;                         // value range low
         RangeHigh  like(EntNumbG.Value)      const;                         // value range high
       end-pi;                                                               // entity group by numb

       EntityGroupNumb(ParentID : Class : Property : RangeLow : RangeHigh);  // pass op-descriptor

       end-proc;                                                             // entity group by numb

      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupNumbValueM export;                                // entity group by numb

       dcl-pi EntityGroupNumbValueM;                                         // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumbG.Value)      const;                         // comparison value
         Moment     like(EntNumbG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by numb

       EntityGroupNumb(ParentID : Class    : Property :
                       Value    : Value    : Moment);                        // pass op-descriptor

       end-proc;                                                             // entity group by numb

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupNumbValue export;                                 // entity group by numb

       dcl-pi EntityGroupNumbValue;                                          // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumbG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by numb

       EntityGroupNumb(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by numb


      **********************************************************************************************
      *  FUNCTIONS BASED ON ENCRYPTED NOTE (NOTX) PROPERTIES
      **********************************************************************************************

       // all parameters

       dcl-proc EntityGroupNotx export;                                      // entity group by notx

       dcl-pi EntityGroupNotx;                                               // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNotxG.Value)      const;                         // value range low
         RangeHigh  like(EntNotxG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNotxG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by notx

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntNotxG.Value);                              // value range low
       dcl-s RangeHighX   like(EntNotxG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       // if only a range low value passed, set range high value to match

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if range hi provided
           RangeHighX = RangeHigh;                                           // use it
         else;                                                               // no range hi provided
           RangeHighX = RangeLow;                                            // duplicate low value
         endif;                                                              // if range hi provided

         if %parms >= 6;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if RangeLow > RangeHighX;                                           // if out of sequence
           RangeLowX  = RangeHighX;                                          // swap positions
           RangeHighX = RangeLow;                                            // swap positions
         else;                                                               // in proper sequence
           RangeLowX  = RangeLow;                                            // range value low
         endif;                                                              // if out of sequence

         // headers for any relevant entities with matching notx property value.

         exec sql declare EntityGroupNotxC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getNotx(entityID, :Property, :MomentX)
                     between :RangeLowX and :RangeHighX
                order by entityid;                                           // entities w/match

         exec sql open EntityGroupNotxC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by notx

      **********************************************************************************************

       // low and high range value, with moment parameter

       dcl-proc EntityGroupNotxRangeM export;                                // entity group by notx

       dcl-pi EntityGroupNotxRangeM;                                         // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNotxG.Value)      const;                         // value range low
         RangeHigh  like(EntNotxG.Value)      const;                         // value range high
         Moment     like(EntNotxG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by notx

       EntityGroupNotx(ParentID : Class     : Property :
                       RangeLow : RangeHigh : Moment);                       // pass op-descriptor

       end-proc;                                                             // entity group by notx

      **********************************************************************************************

       // low and high range value, no moment parameter

       dcl-proc EntityGroupNotxRange export;                                 // entity group by notx

       dcl-pi EntityGroupNotxRange;                                          // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNotxG.Value)      const;                         // value range low
         RangeHigh  like(EntNotxG.Value)      const;                         // value range high
       end-pi;                                                               // entity group by notx

       EntityGroupNotx(ParentID : Class : Property : RangeLow : RangeHigh);  // pass op-descriptor

       end-proc;                                                             // entity group by notx

      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupNotxValueM export;                                // entity group by notx

       dcl-pi EntityGroupNotxValueM;                                         // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNotxG.Value)      const;                         // comparison value
         Moment     like(EntNotxG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by notx

       EntityGroupNotx(ParentID : Class    : Property :
                       Value    : Value    : Moment);                        // pass op-descriptor

       end-proc;                                                             // entity group by notx

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupNotxValue export;                                 // entity group by notx

       dcl-pi EntityGroupNotxValue;                                          // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNotxG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by notx

       EntityGroupNotx(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by notx


      **********************************************************************************************
      *  FUNCTIONS BASED ON ENCRYPTED NUMBER (NUMX) PROPERTIES
      **********************************************************************************************

       // all parameters

       dcl-proc EntityGroupNumx export;                                      // entity group by numx

       dcl-pi EntityGroupNumx;                                               // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumxG.Value)      const;                         // value range low
         RangeHigh  like(EntNumxG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNumxG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by numx

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntNumxG.Value);                              // value range low
       dcl-s RangeHighX   like(EntNumxG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       // if only a range low value passed, set range high value to match

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if range hi provided
           RangeHighX = RangeHigh;                                           // use it
         else;                                                               // no range hi provided
           RangeHighX = RangeLow;                                            // duplicate low value
         endif;                                                              // if range hi provided

         if %parms >= 6;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if RangeLow > RangeHighX;                                           // if out of sequence
           RangeLowX  = RangeHighX;                                          // swap positions
           RangeHighX = RangeLow;                                            // swap positions
         else;                                                               // in proper sequence
           RangeLowX  = RangeLow;                                            // range value low
         endif;                                                              // if out of sequence

         // headers for any relevant entities with matching numx property value.

         exec sql declare EntityGroupNumxC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getNumx(entityID, :Property, :MomentX)
                     between :RangeLowX and :RangeHighX
                order by entityid;                                           // entities w/match

         exec sql open EntityGroupNumxC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by numx

      **********************************************************************************************

       // low and high range value, with moment parameter

       dcl-proc EntityGroupNumxRangeM export;                                // entity group by numx

       dcl-pi EntityGroupNumxRangeM;                                         // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumxG.Value)      const;                         // value range low
         RangeHigh  like(EntNumxG.Value)      const;                         // value range high
         Moment     like(EntNumxG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by numx

       EntityGroupNumx(ParentID : Class     : Property :
                       RangeLow : RangeHigh : Moment);                       // pass op-descriptor

       end-proc;                                                             // entity group by numx

      **********************************************************************************************

       // low and high range value, no moment parameter

       dcl-proc EntityGroupNumxRange export;                                 // entity group by numx

       dcl-pi EntityGroupNumxRange;                                          // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumxG.Value)      const;                         // value range low
         RangeHigh  like(EntNumxG.Value)      const;                         // value range high
       end-pi;                                                               // entity group by numx

       EntityGroupNumx(ParentID : Class : Property : RangeLow : RangeHigh);  // pass op-descriptor

       end-proc;                                                             // entity group by numx

      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupNumxValueM export;                                // entity group by numx

       dcl-pi EntityGroupNumxValueM;                                         // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumxG.Value)      const;                         // comparison value
         Moment     like(EntNumxG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by numx

       EntityGroupNumx(ParentID : Class    : Property :
                       Value    : Value    : Moment);                        // pass op-descriptor

       end-proc;                                                             // entity group by numx

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupNumxValue export;                                 // entity group by numx

       dcl-pi EntityGroupNumxValue;                                          // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumxG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by numx

       EntityGroupNumx(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by numx


      **********************************************************************************************
      *  FUNCTIONS BASED ON ENCRYPTED DATE (DATX) PROPERTIES
      **********************************************************************************************

       // all parameters

       dcl-proc EntityGroupDatx export;                                      // entity group by datx

       dcl-pi EntityGroupDatx;                                               // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const options(*nopass);        // value range high
         Moment     like(EntDatxG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by datx

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntDateG.Value);                              // value range low
       dcl-s RangeHighX   like(EntDateG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       // if only a range low value passed, set range high value to match

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if range hi provided
           RangeHighX = RangeHigh;                                           // use it
         else;                                                               // no range hi provided
           RangeHighX = RangeLow;                                            // duplicate low value
         endif;                                                              // if range hi provided

         if %parms >= 6;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if RangeLow > RangeHighX;                                           // if out of sequence
           RangeLowX  = RangeHighX;                                          // swap positions
           RangeHighX = RangeLow;                                            // swap positions
         else;                                                               // in proper sequence
           RangeLowX  = RangeLow;                                            // range value low
         endif;                                                              // if out of sequence

         // headers for any relevant entities with matching datx property value.

         exec sql declare EntityGroupDatxC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getDatx(entityID, :Property, :MomentX)
                     between :RangeLowX and :RangeHighX
                order by entityid;                                           // entities w/match

         exec sql open EntityGroupDatxC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by datx

      **********************************************************************************************

       // low and high range value, with moment parameter

       dcl-proc EntityGroupDatxRangeM export;                                // entity group by datx

       dcl-pi EntityGroupDatxRangeM;                                         // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
         Moment     like(EntDatxG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by datx

       EntityGroupDatx(ParentID : Class     : Property :
                       RangeLow : RangeHigh : Moment);                       // pass op-descriptor

       end-proc;                                                             // entity group by datx

      **********************************************************************************************

       // low and high range value, no moment parameter

       dcl-proc EntityGroupDatxRange export;                                 // entity group by datx

       dcl-pi EntityGroupDatxRange;                                          // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
       end-pi;                                                               // entity group by datx

       EntityGroupDatx(ParentID : Class : Property : RangeLow : RangeHigh);  // pass op-descriptor

       end-proc;                                                             // entity group by datx

      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupDatxValueM export;                                // entity group by datx

       dcl-pi EntityGroupDatxValueM;                                         // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
         Moment     like(EntDatxG.ChangeTime) const;                         // moment in time
       end-pi;                                                               // entity group by datx

       EntityGroupDatx(ParentID : Class    : Property :
                       Value    : Value    : Moment);                        // pass op-descriptor

       end-proc;                                                             // entity group by datx

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupDatxValue export;                                 // entity group by datx

       dcl-pi EntityGroupDatxValue;                                          // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by datx

       EntityGroupDatx(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by datx


      **********************************************************************************************
      *  FUNCTIONS BASED ON LINK PROPERTIES
      **********************************************************************************************

       // single value, with moment parameter

       dcl-proc EntityGroupLink export;                                      // entity group by link

       dcl-pi EntityGroupLink;                                               // entity group by link
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntLinkG.Value)      const;                         // single value
         Moment     like(EntLinkG.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // entity group by link

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s RangeLowX    like(EntNumxG.Value);                              // value range low
       dcl-s RangeHighX   like(EntNumxG.Value);                              // value range high
       dcl-s MomentX      like(EntHeadG.CreateTime);                         // moment in time

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         // headers for any relevant entities with matching link property value.

         exec sql declare EntityGroupLinkC1 cursor for
           select * from enthead
             where parentID    = :ParentID
               and class       = :Class
               and createtime <= :MomentX
               and getLink(entityID, :Property, :MomentX) = :Value
                 order by entityid;                                          // entities w/match

         exec sql open EntityGroupLinkC1;                                    // open cursor

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity group by link

      **********************************************************************************************

       // single value, no moment parameter

       dcl-proc EntityGroupLinkValue export;                                 // entity group by link

       dcl-pi EntityGroupLinkValue;                                          // entity group by link
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntLinkG.Value)      const;                         // comparison value
       end-pi;                                                               // entity group by link

       EntityGroupLink(ParentID : Class : Property : Value);                 // pass op-descriptor

       end-proc;                                                             // entity group by link

