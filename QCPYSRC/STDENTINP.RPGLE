      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY INPUT FUNCTIONS                             *
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
      *  IDENTITY RESOLUTION
      **********************************************************************************************

       dcl-pr getEntityID like(EntHeadI.EntityID);                           // get entity ID (both)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const options(*nopass);          // create time stamp
       end-pr;                                                               // get entity ID (both)

       dcl-pr getEntityIDn like(EntHeadI.EntityID);                          // get entity ID (num)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         Moment   like(EntHeadI.CreateTime) const options(*nopass);          // moment in time
       end-pr;                                                               // get entity ID (num)

       dcl-pr getEntityIDa like(EntHeadI.EntityID);                          // get entity id (alph)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const options(*nopass);          // moment in time
       end-pr;                                                               // get entity ID (alph)

      **********************************************************************************************
      *  RETRIEVAL OF ENTITY PROPERTY SUBTABLE VALUES
      **********************************************************************************************

       dcl-pr getDate like(EntDateI.Value);                                  // get entity date
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDateI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get entity date

       dcl-pr getDateN zoned(8);                                             // get date numeric
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         DateFormat char(5) const;                                           // date format
         Moment like(EntDateI.ChangeTime) const options(*nopass);            // moment in time
       end-pr;                                                               // get date numeric

       dcl-pr getDateA char(10);                                             // get date alpha
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         DateFormat char(5) const;                                           // date format
         Moment like(EntDateI.ChangeTime) const options(*nopass);            // moment in time
       end-pr;                                                               // get date alpha

       dcl-pr getFlag like(EntFlagI.Value);                                  // get entity flag
         EntityID like(EntFlagI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntFlagI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get entity flag

       dcl-pr getLink like(EntLinkI.Value);                                  // get entity link
         EntityID like(EntLinkI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntLinkI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get entity link

       dcl-pr getNote like(EntNoteI.Value);                                  // get entity note
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNoteI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get entity note

       dcl-pr getNumb like(EntNumbI.Value);                                  // get entity number
         EntityID like(EntNumbI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNumbI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get entity number

       dcl-pr getNotX like(EntNoteI.Value);                                  // get encrypted note
         EntityID like(EntNotxI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNotxI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get encrypted note

       dcl-pr getNumX like(EntNumbI.Value);                                  // get encrypted number
         EntityID like(EntNumxI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNumxI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get encrypted number

       dcl-pr getDatX like(EntDateI.Value);                                  // get encrypted date
         EntityID like(EntDatxI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDatxI.ChangeTime) const options(*nopass);          // change time stamp
       end-pr;                                                               // get encrypted date

       dcl-pr getDatxN zoned(8);                                             // get enc date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5)                   const;                         // date format
         Moment     like(EntDateI.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // get enc date numeric

       dcl-pr getDatxA char(10);                                             // get encr date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5)                   const;                         // date format
         Moment     like(EntDateI.ChangeTime) const options(*nopass);        // moment in time
       end-pr;                                                               // get encr date alpha

      **********************************************************************************************
      *  RETRIEVAL OF ENTITY HEADER METADATA
      **********************************************************************************************

       dcl-pr getParentID like(EntHeadI.ParentID);                           // get entity parent ID
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pr;                                                               // get entity parent ID

       dcl-pr getClass like(EntHeadI.Class);                                 // get entity class
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pr;                                                               // get entity class

       dcl-pr getDescriptor like(EntHeadI.Descriptor);                       // get entity descrip
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pr;                                                               // get entity descrip

       dcl-pr getLegacyN like(EntHeadI.LegacyN);                             // get legacy ID numer
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pr;                                                               // get legacy ID numer

       dcl-pr getLegacyA like(EntHeadI.LegacyA);                             // get legacy ID alpha
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pr;                                                               // get legacy ID alpha

       dcl-pr getStatus like(EntHeadI.Status);                               // get entity status
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pr;                                                               // get entity status

      **********************************************************************************************
      *  HELPER PROCEDURES FOR INTEGRITY AND AUDIT SUPPORT
      **********************************************************************************************

       dcl-pr ValidProperty ind;                                             // valid property
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const options(*nopass);            // data type
       end-pr;                                                               // valid property

       dcl-pr PropertyOwner like(EntHeadI.EntityID);                         // valid property
         EntityID like(EntHeadI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property path
       end-pr;                                                               // valid property

       dcl-pr FinalSegment like(EntPropI.Property);                          // final path segment
         FullPath like(EntHeadI.Descriptor) const;                           // full property path
       end-pr;                                                               // final path segment

       dcl-pr UpperCase like(EntNoteI.Value);                                // cast as upper case
         FreeText like(EntNoteI.Value) const;                                // free form text
       end-pr;                                                               // cast as upper case

       dcl-pr ValidClass ind;                                                // valid class name
         Class like(EntHeadI.Class) const;                                   // class name argument
       end-pr;                                                               // valid class name

       dcl-pr ValidClassProperty ind;                                        // valid class property
         Class    like(EntHeadI.Class)    const;                             // class name
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const options(*nopass);            // data type
       end-pr;                                                               // valid class property

      **********************************************************************************************
      *  TIME TRAVEL SUPPORT
      **********************************************************************************************

       dcl-pr setSessionMoment ind;                                          // set session moment
         SessionDate char(7);                                                // session date CYYMMDD
         SessionTime char(6);                                                // session time HHMMSS
         SessionMicr int(10);                                                // microseconds
       end-pr;                                                               // set session moment

       dcl-pr getSessionMoment like(EntHeadI.CreateTime) end-pr;             // get session moment

       dcl-pr clrSessionMoment ind end-pr;                                   // clear session moment

       dcl-pr SessionMomentActive ind end-pr;                                // session moment actv

      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntHeadI ext extname('ENTHEAD') qualified template end-ds;     // record template
       dcl-ds EntPropI ext extname('ENTPROP') qualified template end-ds;     // record template
       dcl-ds EntDateI ext extname('ENTDATE') qualified template end-ds;     // record template
       dcl-ds EntFlagI ext extname('ENTFLAG') qualified template end-ds;     // record template
       dcl-ds EntLinkI ext extname('ENTLINK') qualified template end-ds;     // record template
       dcl-ds EntNoteI ext extname('ENTNOTE') qualified template end-ds;     // record template
       dcl-ds EntNumbI ext extname('ENTNUMB') qualified template end-ds;     // record template
       dcl-ds EntNotxI ext extname('ENTNOTX') qualified template end-ds;     // record template
       dcl-ds EntNumxI ext extname('ENTNUMX') qualified template end-ds;     // record template
       dcl-ds EntDatxI ext extname('ENTDATX') qualified template end-ds;     // record template

       dcl-s FounderID like(EntHeadI.EntityID) inz(1);                       // founder entity ID

       dcl-c sQuote x'7D';                                                   // single quote
       dcl-c Delimiter '.';                                                  // property delimiter

