      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY SQL WRAPPERS (PROTOTYPES & STORAGE)         *
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

       dcl-pr getEntityID5 like(EntHeadI.EntityID);                          // get entity ID
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const;                           // moment in time
       end-pr;                                                               // get entity ID

       dcl-pr getEntityID4 like(EntHeadI.EntityID);                          // get entity ID
         ParentID like(EntHeadI.ParentID) const;                             // parent ID
         Class    like(EntHeadI.Class)    const;                             // entity class
         LegacyN  like(EntHeadI.LegacyN)  const;                             // legacy ID numeric
         LegacyA  like(EntHeadI.LegacyA)  const;                             // legacy ID alpha
       end-pr;                                                               // get entity ID

       dcl-pr getEntityIDn4 like(EntHeadI.EntityID);                         // get entity ID (num)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         Moment   like(EntHeadI.CreateTime) const;                           // moment in time
       end-pr;                                                               // get entity ID (num)

       dcl-pr getEntityIDn3 like(EntHeadI.EntityID);                         // get entity ID (num)
         ParentID like(EntHeadI.ParentID) const;                             // parent ID
         Class    like(EntHeadI.Class)    const;                             // entity class
         LegacyN  like(EntHeadI.LegacyN)  const;                             // legacy ID numeric
       end-pr;                                                               // get entity ID (num)

       dcl-pr getEntityIDa4 like(EntHeadI.EntityID);                         // get entity ID (alph)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const;                           // moment in time
       end-pr;                                                               // get entity ID (alph)

       dcl-pr getEntityIDa3 like(EntHeadI.EntityID);                         // get entity ID (alph)
         ParentID like(EntHeadI.ParentID) const;                             // parent ID
         Class    like(EntHeadI.Class)    const;                             // entity class
         LegacyA  like(EntHeadI.LegacyA)  const;                             // legacy ID alpha
       end-pr;                                                               // get entity ID (alph)

      **********************************************************************************************
      *  RETRIEVAL OF ENTITY PROPERTY SUBTABLE VALUES
      **********************************************************************************************

       dcl-pr getDate3 like(EntDateI.Value);                                 // get entity date
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDateI.ChangeTime) const;                           // moment in time
       end-pr;                                                               // get entity date

       dcl-pr getDate2 like(EntDateI.Value);                                 // get entity date
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get entity date

      **********************************************************************************************

       dcl-pr getDateN4 zoned(8);                                            // get date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pr;                                                               // get date numeric

       dcl-pr getDateN3 zoned(8);                                            // get date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pr;                                                               // get date numeric

      **********************************************************************************************

       dcl-pr getDateA4 char(10);                                            // get date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pr;                                                               // get date alpha

       dcl-pr getDateA3 char(10);                                            // get date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pr;                                                               // get date alpha

      **********************************************************************************************

       dcl-pr getFlag3 like(EntFlagI.Value);                                 // get entity flag
         EntityID like(EntFlagI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntFlagI.ChangeTime) const;                           // moment in time
       end-pr;                                                               // get entity flag

       dcl-pr getFlag2 like(EntFlagI.Value);                                 // get entity flag
         EntityID like(EntFlagI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get entity flag

      **********************************************************************************************

       dcl-pr getLink3 like(EntLinkI.Value);                                 // get entity link
         EntityID like(EntLinkI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntLinkI.ChangeTime) const;                           // change time stamp
       end-pr;                                                               // get entity link

       dcl-pr getLink2 like(EntLinkI.Value);                                 // get entity link
         EntityID like(EntLinkI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get entity link

      **********************************************************************************************

       dcl-pr getNote3 like(EntNoteI.Value);                                 // get entity note
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNoteI.ChangeTime) const;                           // change time stamp
       end-pr;                                                               // get entity note

       dcl-pr getNote2 like(EntNoteI.Value);                                 // get entity note
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get entity note

      **********************************************************************************************

       dcl-pr getNumb3 like(EntNumbI.Value);                                 // get entity number
         EntityID like(EntNumbI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNumbI.ChangeTime) const;                           // change time stamp
       end-pr;                                                               // get entity number

       dcl-pr getNumb2 like(EntNumbI.Value);                                 // get entity number
         EntityID like(EntNumbI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get entity number

      **********************************************************************************************

       dcl-pr getNotX3 like(EntNotXI.Value);                                 // get encrypted note
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNotXI.ChangeTime) const;                           // change time stamp
       end-pr;                                                               // get encrypted note

       dcl-pr getNotX2 like(EntNotXI.Value);                                 // get encrypted note
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get encrypted note

      **********************************************************************************************

       dcl-pr getNumX3 like(EntNumbI.Value);                                 // get encrypted number
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNotXI.ChangeTime) const;                           // change time stamp
       end-pr;                                                               // get encrypted number

       dcl-pr getNumX2 like(EntNumbI.Value);                                 // get encrypted number
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get encrypted number

      **********************************************************************************************

       dcl-pr getDatX3 like(EntDateI.Value);                                 // get encrypted date
         EntityID like(EntDatXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDatXI.ChangeTime) const;                           // change time stamp
       end-pr;                                                               // get encrypted date

       dcl-pr getDatX2 like(EntDateI.Value);                                 // get encrypted date
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pr;                                                               // get encrypted date

       dcl-pr getDatxN4 zoned(8);                                            // get enc date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pr;                                                               // get enc date numeric

       dcl-pr getDatxN3 zoned(8);                                            // get enc date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pr;                                                               // get enc date numeric

       dcl-pr getDatxA4 char(10);                                            // get enc date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pr;                                                               // get enc date alpha

       dcl-pr getDatxA3 char(10);                                            // get enc date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pr;                                                               // get enc date alpha

