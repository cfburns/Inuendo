      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY SQL WRAPPERS (PROTOTYPES & STORAGE)         *
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
      *  NEW ENTITY CREATION
      **********************************************************************************************

       dcl-pr newEntityB5 like(EntHeadO.entityID);                           // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyN    like(EntHeadO.legacyN)    const;                         // legacy ID numeric
         LegacyA    like(EntHeadO.legacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const;                         // free form note text
       end-pr;                                                               // create new entity

       dcl-pr newEntityB4 like(EntHeadO.entityID);                           // create new entity
         ParentID like(EntHeadO.parentID) const;                             // parent entity
         Class    like(EntHeadO.class)    const;                             // entity class
         LegacyN  like(EntHeadO.legacyN)  const;                             // legacy ID numeric
         LegacyA  like(EntHeadO.legacyA)  const;                             // legacy ID alpha
       end-pr;                                                               // create new entity

       dcl-pr newEntityN4 like(EntHeadO.entityID);                           // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyN    like(EntHeadO.legacyN)    const;                         // legacy ID numeric
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pr;                                                               // create new entity

       dcl-pr newEntityN3 like(EntHeadO.entityID);                           // create new entity
         ParentID like(EntHeadO.parentID) const;                             // parent entity
         Class    like(EntHeadO.class)    const;                             // entity class
         LegacyN  like(EntHeadO.legacyN)  const;                             // legacy ID numeric
       end-pr;                                                               // create new entity

       dcl-pr newEntityA4 like(EntHeadO.entityID);                           // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyA    like(EntHeadO.legacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pr;                                                               // create new entity

       dcl-pr newEntityA3 like(EntHeadO.entityID);                           // create new entity
         ParentID like(EntHeadO.parentID) const;                             // parent entity
         Class    like(EntHeadO.class)    const;                             // entity class
         LegacyA  like(EntHeadO.legacyA)  const;                             // legacy ID alpha
       end-pr;                                                               // create new entity


      **********************************************************************************************
      *  STORED PROCEDURES PRODUCING RESULT SETS
      **********************************************************************************************

       dcl-pr EntityLife2;                                                   // entity life story
         EntityID like(EntNoteR.EntityID)   const;                           // entity ID
         Moment   like(EntNoteR.ChangeTime) const;                           // moment in time
       end-pr;                                                               // entity life story

       dcl-pr EntityLife1;                                                   // entity life story
         EntityID like(EntNoteR.EntityID) const;                             // entity ID
       end-pr;                                                               // entity life story

      **********************************************************************************************

       dcl-pr SnapShot2;                                                     // entity snapshot
         EntityID like(EntHeadR.EntityID)   const;                           // entity ID
         Moment   like(EntHeadR.CreateTime) const;                           // moment in time
       end-pr;                                                               // entity snapshot

       dcl-pr SnapShot1;                                                     // entity snapshot
         EntityID like(EntHeadR.EntityID) const;                             // entity ID
       end-pr;                                                               // entity snapshot

      **********************************************************************************************

       dcl-pr PropertyLife3;                                                 // property life
         EntityID like(EntNoteR.EntityID)   const;                           // entity ID
         Property like(EntNoteR.Property)   const;                           // property nickname
         Moment   like(EntNoteR.ChangeTime) const;                           // moment in time
       end-pr;                                                               // property life

       dcl-pr PropertyLife2;                                                 // property life
         EntityID like(EntNoteR.EntityID) const;                             // entity ID
         Property like(EntNoteR.Property) const;                             // property nickname
       end-pr;                                                               // property life


      **********************************************************************************************
      *  HELPER PROCEDURES FOR INTEGRITY AND AUDIT SUPPORT
      **********************************************************************************************

       dcl-pr ValidProperty3 ind;                                            // valid property
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const;                             // property data type
       end-pr;                                                               // valid property

       dcl-pr ValidProperty2 ind;                                            // valid property
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
         Property like(EntFlagI.Property) const;                             // property nickname
       end-pr;                                                               // valid property

      **********************************************************************************************

       dcl-pr ValidClassProperty3 ind;                                       // valid class property
         Class    like(EntHeadI.Class)    const;                             // class name
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const;                             // data type
       end-pr;                                                               // valid class property

       dcl-pr ValidClassProperty2 ind;                                       // valid class property
         Class    like(EntHeadI.Class)    const;                             // class name
         Property like(EntFlagI.Property) const;                             // property nickname
       end-pr;                                                               // valid class property

