      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY OUTPUT FUNCTIONS                            *
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
      *  INSTANTIATION OF A NEW ENTITY
      **********************************************************************************************

       dcl-pr newEntity like(EntHeadO.EntityID);                             // create new entity
         ParentID   like(EntHeadO.ParentID)   const;                         // parent entity
         Class      like(EntHeadO.Class)      const;                         // entity class
         LegacyN    like(EntHeadO.LegacyN)    const;                         // legacy ID numeric
         LegacyA    like(EntHeadO.LegacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pr;                                                               // create new entity

       dcl-pr newEntityN like(EntHeadO.entityID);                            // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyN    like(EntHeadO.legacyN)    const;                         // legacy ID numeric
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pr;                                                               // create new entity

       dcl-pr newEntityA like(EntHeadO.entityID);                            // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyA    like(EntHeadO.legacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pr;                                                               // create new entity

      **********************************************************************************************
      *  APPENDING OF NEW VALUES IN ENTITY SUBTABLES
      **********************************************************************************************

       dcl-pr putDate ind;                                                   // put entity date
         EntityID like(EntDateO.EntityID) const;                             // entity ID
         Property like(EntDateO.Property) const;                             // property nickname
         NewValue like(EntDateO.Value)    const;                             // new property value
       end-pr;                                                               // put entity date

       dcl-pr putDateN ind;                                                  // put date numeric
         EntityID like(EntDateO.EntityID) const;                             // entity ID
         Property like(EntDateO.Property) const;                             // property nickname
         NewValue zoned(8) const;                                            // new property value
         DateFormat char(5) const;                                           // date format
       end-pr;                                                               // put date numeric

       dcl-pr putDateA ind;                                                  // put date alpha
         EntityID like(EntDateO.EntityID) const;                             // entity ID
         Property like(EntDateO.Property) const;                             // property nickname
         NewValue char(10) const;                                            // new property value
         DateFormat char(5) const;                                           // date format
       end-pr;                                                               // put date alpha

       dcl-pr putFlag ind;                                                   // put entity flag
         EntityID like(EntFlagO.EntityID) const;                             // entity ID
         Property like(EntFlagO.Property) const;                             // property nickname
         NewValue like(EntFlagO.Value)    const;                             // new property value
       end-pr;                                                               // put entity flag

       dcl-pr putLink ind;                                                   // put entity link
         EntityID like(EntLinkO.EntityID) const;                             // entity ID
         Property like(EntLinkO.Property) const;                             // property nickname
         NewValue like(EntLinkO.Value)    const;                             // new property value
       end-pr;                                                               // put entity link

       dcl-pr putNote ind;                                                   // put entity note
         EntityID like(EntNoteO.EntityID) const;                             // entity ID
         Property like(EntNoteO.Property) const;                             // property nickname
         NewValue like(EntNoteO.Value)    const;                             // new property value
       end-pr;                                                               // put entity note

       dcl-pr putNumb ind;                                                   // put entity number
         EntityID like(EntNumbO.EntityID) const;                             // entity ID
         Property like(EntNumbO.Property) const;                             // property nickname
         NewValue like(EntNumbO.Value)    const;                             // new property value
       end-pr;                                                               // put entity number

       dcl-pr putNotX ind;                                                   // put encrypted note
         EntityID like(EntNotxO.EntityID) const;                             // entity ID
         Property like(EntNotxO.Property) const;                             // property nickname
         NewValue like(EntNoteO.Value)    const;                             // new property value
       end-pr;                                                               // put encrypted note

       dcl-pr putNumX ind;                                                   // put encrypted number
         EntityID like(EntNumxO.EntityID) const;                             // entity ID
         Property like(EntNumxO.Property) const;                             // property nickname
         NewValue like(EntNumbO.Value)    const;                             // new property value
       end-pr;                                                               // put encrypted number

       dcl-pr putDatX ind;                                                   // put encrypted date
         EntityID like(EntDatxO.EntityID) const;                             // entity ID
         Property like(EntDatxO.Property) const;                             // property nickname
         NewValue like(EntDateO.Value)    const;                             // new property value
       end-pr;                                                               // put encrypted date

      **********************************************************************************************
      *  UPDATES TO HEADER METADATA (WITH AUTOMATIC APPENDS TO COVERT SUBTABLE ENTRIES)
      **********************************************************************************************

       dcl-pr putParentID ind;                                               // put entity parent ID
         EntityID    like(EntHeadO.EntityID) const;                          // entity ID
         NewParentID like(EntHeadO.ParentID) const;                          // new parent ID
       end-pr;                                                               // put entity parent ID

       dcl-pr putClass ind;                                                  // put entity class
         EntityID like(EntHeadO.EntityID) const;                             // entity ID
         NewClass like(EntHeadO.Class)    const;                             // new class
       end-pr;                                                               // put entity class

       dcl-pr putDescriptor ind;                                             // put entity descrip
         EntityID like(EntHeadO.EntityID) const;                             // entity ID
         NewDescriptor like(EntHeadO.Descriptor) const;                      // new descriptor
       end-pr;                                                               // put entity descrip

       dcl-pr putLegacyN ind;                                                // put legacy ID numer
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyN like(EntHeadO.LegacyN)  const;                           // new legacy ID numer
       end-pr;                                                               // put legacy ID numer

       dcl-pr putLegacyA ind;                                                // put legacy ID alpha
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyA like(EntHeadO.LegacyA)  const;                           // new legacy ID alpha
       end-pr;                                                               // put legacy ID alpha

       dcl-pr putStatus ind;                                                 // put entity status
         EntityID  like(EntHeadO.EntityID) const;                            // entity ID
         NewStatus like(EntHeadO.Status)   const;                            // entity status
       end-pr;                                                               // put entity status

      **********************************************************************************************
      *  ENTITY DUPLICATION FUNCTIONS (INCLUDING THOSE TO SUPPORT SQL FUNCTION OVERLOADING)
      **********************************************************************************************

       dcl-pr dupEntity like(EntHeadO.EntityID);                             // duplicate entity
         EntityID   like(EntHeadO.EntityID)   const;                         // entity ID
         NewLegacyN like(EntHeadO.LegacyN)    const;                         // new legacy numer ID
         NewLegacyA like(EntHeadO.LegacyA)    const;                         // new legacy alpha ID
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pr;                                                               // duplicate entity

       dcl-pr dupEntityND like(EntHeadO.EntityID);                           // duplicate entity
          EntityID   like(EntHeadO.EntityID)   const;                        // entity ID
          NewLegacyN like(EntHeadO.LegacyN)    const;                        // new legacy numer ID
          Descriptor like(EntHeadO.Descriptor) const;                        // free form note text
       end-pr;                                                               // duplicate entity

       dcl-pr dupEntityN like(EntHeadO.EntityID);                            // duplicate entity
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyN like(EntHeadO.LegacyN)  const;                           // new legacy numer ID
       end-pr;                                                               // duplicate entity

       dcl-pr dupEntityAD like(EntHeadO.EntityID);                           // duplicate entity
         EntityID   like(EntHeadO.EntityID)   const;                         // entity ID
         NewLegacyA like(EntHeadO.LegacyA)    const;                         // new legacy alpha ID
         Descriptor like(EntHeadO.Descriptor) const;                         // free form note text
       end-pr;                                                               // duplicate entity

       dcl-pr dupEntityA like(EntHeadO.EntityID);                            // duplicate entity
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyA like(EntHeadO.LegacyA)  const;                           // new legacy alpha ID
       end-pr;                                                               // duplicate entity

       dcl-pr copyEntity like(EntHeadO.EntityID);                            // copy entity
         EntityID like(EntHeadO.EntityID) const;                             // entity ID to copy
         ParentID like(EntHeadO.EntityID) const;                             // new parent ID
       end-pr;                                                               // copy entity

      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntHeadO ext extname('ENTHEAD') qualified template end-ds;     // record template
       dcl-ds EntPropO ext extname('ENTPROP') qualified template end-ds;     // record template
       dcl-ds EntDateO ext extname('ENTDATE') qualified template end-ds;     // record template
       dcl-ds EntFlagO ext extname('ENTFLAG') qualified template end-ds;     // record template
       dcl-ds EntLinkO ext extname('ENTLINK') qualified template end-ds;     // record template
       dcl-ds EntNoteO ext extname('ENTNOTE') qualified template end-ds;     // record template
       dcl-ds EntNumbO ext extname('ENTNUMB') qualified template end-ds;     // record template
       dcl-ds EntNotxO ext extname('ENTNOTX') qualified template end-ds;     // record template
       dcl-ds EntNumxO ext extname('ENTNUMX') qualified template end-ds;     // record template
       dcl-ds EntDatxO ext extname('ENTDATX') qualified template end-ds;     // record template

       dcl-c IllHeadIns 'Attemped to insert entity header illegally';        // illegal ent head ins
       dcl-c IllHeadDel 'Attemped to delete entity header illegally';        // illegal ent head del
       dcl-c IllHeadUpd 'Attemped to update entity header illegally';        // illegal ent head upd

       dcl-c IllPropIns 'Attemped to insert property value illegally';       // illegal prop val ins
       dcl-c IllPropDel 'Attemped to delete property value illegally';       // illegal prop val del
       dcl-c IllPropUpd 'Attemped to update property value illegally';       // illegal prop val upd

