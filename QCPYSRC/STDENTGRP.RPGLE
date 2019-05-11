      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 - STANDARD ENTITY GROUP FUNCTIONS (PROTOTYPES & STORAGE)                      *
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
      *  FUNCTIONS BASED ON DATE PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupDate;                                               // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const options(*nopass);        // value range high
         Moment     like(EntDateG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by date

       dcl-pr EntityGroupDateRangeM;                                         // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
         Moment     like(EntDateG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by date

       dcl-pr EntityGroupDateRange;                                          // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
       end-pr;                                                               // entity group by date

       dcl-pr EntityGroupDateValueM;                                         // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
         Moment     like(EntDateG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by date

       dcl-pr EntityGroupDateValue;                                          // entity group by date
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by date

      **********************************************************************************************
      *  FUNCTIONS BASED ON FLAG PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupFlag;                                               // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntFlagG.Value)      const;                         // value range low
         RangeHigh  like(EntFlagG.Value)      const options(*nopass);        // value range high
         Moment     like(EntFlagG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by flag

       dcl-pr EntityGroupFlagRangeM;                                         // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntFlagG.Value)      const;                         // value range low
         RangeHigh  like(EntFlagG.Value)      const;                         // value range high
         Moment     like(EntFlagG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by flag

       dcl-pr EntityGroupFlagRange;                                          // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntFlagG.Value)      const;                         // value range low
         RangeHigh  like(EntFlagG.Value)      const;                         // value range high
       end-pr;                                                               // entity group by flag

       dcl-pr EntityGroupFlagValueM;                                         // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntFlagG.Value)      const;                         // comparison value
         Moment     like(EntFlagG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by flag

       dcl-pr EntityGroupFlagValue;                                          // entity group by flag
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntFlagG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by flag

      **********************************************************************************************
      *  FUNCTIONS BASED ON NOTE PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupNote;                                               // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNoteG.Value)      const;                         // value range low
         RangeHigh  like(EntNoteG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNoteG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by note

       dcl-pr EntityGroupNoteRangeM;                                         // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNoteG.Value)      const;                         // value range low
         RangeHigh  like(EntNoteG.Value)      const;                         // value range high
         Moment     like(EntNoteG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by note

       dcl-pr EntityGroupNoteRange;                                          // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNoteG.Value)      const;                         // value range low
         RangeHigh  like(EntNoteG.Value)      const;                         // value range high
       end-pr;                                                               // entity group by note

       dcl-pr EntityGroupNoteValueM;                                         // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNoteG.Value)      const;                         // comparison value
         Moment     like(EntNoteG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by note

       dcl-pr EntityGroupNoteValue;                                          // entity group by note
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNoteG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by note

      **********************************************************************************************
      *  FUNCTIONS BASED ON NUMBER PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupNumb;                                               // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumbG.Value)      const;                         // value range low
         RangeHigh  like(EntNumbG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNumbG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by numb

       dcl-pr EntityGroupNumbRangeM;                                         // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumbG.Value)      const;                         // value range low
         RangeHigh  like(EntNumbG.Value)      const;                         // value range high
         Moment     like(EntNumbG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by numb

       dcl-pr EntityGroupNumbRange;                                          // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumbG.Value)      const;                         // value range low
         RangeHigh  like(EntNumbG.Value)      const;                         // value range high
       end-pr;                                                               // entity group by numb

       dcl-pr EntityGroupNumbValueM;                                         // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumbG.Value)      const;                         // comparison value
         Moment     like(EntNumbG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by numb

       dcl-pr EntityGroupNumbValue;                                          // entity group by numb
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumbG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by numb

      **********************************************************************************************
      *  FUNCTIONS BASED ON ENCRYPTED NOTE (NOTX) PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupNotx;                                               // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNotxG.Value)      const;                         // value range low
         RangeHigh  like(EntNotxG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNotxG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by notx

       dcl-pr EntityGroupNotxRangeM;                                         // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNotxG.Value)      const;                         // value range low
         RangeHigh  like(EntNotxG.Value)      const;                         // value range high
         Moment     like(EntNotxG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by notx

       dcl-pr EntityGroupNotxRange;                                          // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNotxG.Value)      const;                         // value range low
         RangeHigh  like(EntNotxG.Value)      const;                         // value range high
       end-pr;                                                               // entity group by notx

       dcl-pr EntityGroupNotxValueM;                                         // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNotxG.Value)      const;                         // comparison value
         Moment     like(EntNotxG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by notx

       dcl-pr EntityGroupNotxValue;                                          // entity group by notx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNotxG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by notx

      **********************************************************************************************
      *  FUNCTIONS BASED ON ENCRYPTED NUMBER (NUMX) PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupNumx;                                               // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumxG.Value)      const;                         // value range low
         RangeHigh  like(EntNumxG.Value)      const options(*nopass);        // value range high
         Moment     like(EntNumxG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by numx

       dcl-pr EntityGroupNumxRangeM;                                         // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumxG.Value)      const;                         // value range low
         RangeHigh  like(EntNumxG.Value)      const;                         // value range high
         Moment     like(EntNumxG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by numx

       dcl-pr EntityGroupNumxRange;                                          // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntNumxG.Value)      const;                         // value range low
         RangeHigh  like(EntNumxG.Value)      const;                         // value range high
       end-pr;                                                               // entity group by numx

       dcl-pr EntityGroupNumxValueM;                                         // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumxG.Value)      const;                         // comparison value
         Moment     like(EntNumxG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by numx

       dcl-pr EntityGroupNumxValue;                                          // entity group by numx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntNumxG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by numx

      **********************************************************************************************
      *  FUNCTIONS BASED ON ENCRYPTED DATE (DATX) PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupDatx;                                               // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const options(*nopass);        // value range high
         Moment     like(EntDatxG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by datx

       dcl-pr EntityGroupDatxRangeM;                                         // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
         Moment     like(EntDatxG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by datx

       dcl-pr EntityGroupDatxRange;                                          // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         RangeLow   like(EntDateG.Value)      const;                         // value range low
         RangeHigh  like(EntDateG.Value)      const;                         // value range high
       end-pr;                                                               // entity group by datx

       dcl-pr EntityGroupDatxValueM;                                         // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
         Moment     like(EntDatxG.ChangeTime) const;                         // moment in time
       end-pr;                                                               // entity group by datx

       dcl-pr EntityGroupDatxValue;                                          // entity group by datx
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntDateG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by datx


      **********************************************************************************************
      *  FUNCTIONS BASED ON LINK PROPERTIES, WITH SQL WRAPPERS
      **********************************************************************************************

       dcl-pr EntityGroupLink;                                               // entity group by link
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntLinkG.Value)      const;                         // single value
         Moment     like(EntLinkG.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // entity group by link

       dcl-pr EntityGroupLinkValue;                                          // entity group by link
         ParentID   like(EntHeadG.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadG.Class)      const;                         // entity class
         Property   like(EntHeadG.Descriptor) const;                         // property name/path
         Value      like(EntLinkG.Value)      const;                         // comparison value
       end-pr;                                                               // entity group by link


      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntHeadG extname('ENTHEAD') qualified template end-ds;         // record template
       dcl-ds EntPropG extname('ENTPROP') qualified template end-ds;         // record template
       dcl-ds EntDateG extname('ENTDATE') qualified template end-ds;         // record template
       dcl-ds EntFlagG extname('ENTFLAG') qualified template end-ds;         // record template
       dcl-ds EntLinkG extname('ENTLINK') qualified template end-ds;         // record template
       dcl-ds EntNoteG extname('ENTNOTE') qualified template end-ds;         // record template
       dcl-ds EntNumbG extname('ENTNUMB') qualified template end-ds;         // record template
       dcl-ds EntNotxG extname('ENTNOTX') qualified template end-ds;         // record template
       dcl-ds EntNumxG extname('ENTNUMX') qualified template end-ds;         // record template
       dcl-ds EntDatxG extname('ENTDATX') qualified template end-ds;         // record template

