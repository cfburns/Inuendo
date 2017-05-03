      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY SQL WRAPPERS                                *
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

      /copy qcpysrc,stdhsrvpgm                                                  h-spec for srvpgm
      /copy qcpysrc,stdentinp                                                   protytpes, work stg
      /copy qcpysrc,stdentout                                                   protytpes, work stg
      /copy qcpysrc,stdentrule                                                  protytpes, work stg
      /copy qcpysrc,stdentsql2                                                  protytpes, work stg


      **********************************************************************************************
      *  NEW ENTITY CREATION
      **********************************************************************************************

       dcl-proc newEntityB5 export;                                          // create new entity

       dcl-pi newEntityB5 like(EntHeadO.entityID);                           // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyN    like(EntHeadO.legacyN)    const;                         // legacy ID numeric
         LegacyA    like(EntHeadO.legacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const;                         // free form note text
       end-pi;                                                               // create new entity

       monitor;                                                              // catch all errors
         return NewEntity(ParentID:Class:LegacyN:LegacyA:Descriptor);        // return new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // return zero ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // create new entity

      **********************************************************************************************

       dcl-proc newEntityB4 export;                                          // create new entity

       dcl-pi newEntityB4 like(EntHeadO.entityID);                           // create new entity
         ParentID like(EntHeadO.parentID) const;                             // parent entity
         Class    like(EntHeadO.class)    const;                             // entity class
         LegacyN  like(EntHeadO.legacyN)  const;                             // legacy ID numeric
         LegacyA  like(EntHeadO.legacyA)  const;                             // legacy ID alpha
       end-pi;                                                               // create new entity

       monitor;                                                              // catch all errors
         return NewEntity(ParentID:Class:LegacyN:LegacyA);                   // return new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // return zero ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // create new entity

      **********************************************************************************************

       dcl-proc newEntityN4 export;                                          // create new entity

       dcl-pi newEntityN4 like(EntHeadO.entityID);                           // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyN    like(EntHeadO.legacyN)    const;                         // legacy ID numeric
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pi;                                                               // create new entity

       dcl-s LegacyAx like(EntHeadO.legacyA);                                // legacy ID alpha

       monitor;                                                              // catch all errors
         return NewEntity(ParentID:Class:LegacyN:LegacyAx:Descriptor);       // return new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // return zero ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // create new entity

      **********************************************************************************************

       dcl-proc newEntityN3 export;                                          // create new entity

       dcl-pi newEntityN3 like(EntHeadO.entityID);                           // create new entity
         ParentID like(EntHeadO.parentID) const;                             // parent entity
         Class    like(EntHeadO.class)    const;                             // entity class
         LegacyN  like(EntHeadO.legacyN)  const;                             // legacy ID numeric
       end-pi;                                                               // create new entity

       dcl-s LegacyAx like(EntHeadO.legacyA);                                // legacy ID alpha

       monitor;                                                              // catch all errors
         return NewEntity(ParentID:Class:LegacyN:LegacyAx);                  // return new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // return zero ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // create new entity

      **********************************************************************************************

       dcl-proc newEntityA4 export;                                          // create new entity

       dcl-pi newEntityA4 like(EntHeadO.entityID);                           // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyA    like(EntHeadO.legacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pi;                                                               // create new entity

       dcl-s LegacyNx like(EntHeadO.legacyN);                                // legacy ID numeric

       monitor;                                                              // catch all errors
         return NewEntity(ParentID:Class:LegacyNx:LegacyA:Descriptor);       // return new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // return zero ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // create new entity

      **********************************************************************************************

       dcl-proc newEntityA3 export;                                          // create new entity

       dcl-pi newEntityA3 like(EntHeadO.entityID);                           // create new entity
         ParentID like(EntHeadO.parentID) const;                             // parent entity
         Class    like(EntHeadO.class)    const;                             // entity class
         LegacyA  like(EntHeadO.legacyA)  const;                             // legacy ID alpha
       end-pi;                                                               // create new entity

       dcl-s LegacyNx like(EntHeadO.legacyN);                                // legacy ID numeric

       monitor;                                                              // catch all errors
         return NewEntity(ParentID:Class:LegacyNx:LegacyA);                  // return new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // return zero ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // create new entity


      **********************************************************************************************
      *  STORED PROCEDURES PRODUCING RESULT SETS
      **********************************************************************************************

       dcl-proc EntityLife2 export;                                          // entity life story

       dcl-pi EntityLife2;                                                   // entity life story
         EntityID like(EntNoteR.EntityID)   const;                           // entity ID
         Moment   like(EntNoteR.ChangeTime) const;                           // moment in time
       end-pi;                                                               // entity life story

       monitor;                                                              // catch all errors
         EntityLife(EntityID:Moment);                                        // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // entity life story

      **********************************************************************************************

       dcl-proc EntityLife1 export;                                          // entity life story

       dcl-pi EntityLife1;                                                   // entity life story
         EntityID like(EntNoteR.EntityID) const;                             // entity ID
       end-pi;                                                               // entity life story

       monitor;                                                              // catch all errors
         EntityLife(EntityID);                                               // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // entity life story

      **********************************************************************************************

       dcl-proc SnapShot2 export;                                            // entity snapshot

       dcl-pi SnapShot2;                                                     // entity snapshot
         EntityID like(EntHeadR.EntityID)   const;                           // entity ID
         Moment   like(EntHeadR.CreateTime) const;                           // moment in time
       end-pi;                                                               // entity snapshot

       monitor;                                                              // catch all errors
         SnapShot(EntityID:Moment);                                          // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // entity snapshot

      **********************************************************************************************

       dcl-proc SnapShot1 export;                                            // entity snapshot

       dcl-pi SnapShot1;                                                     // entity snapshot
         EntityID like(EntHeadR.EntityID) const;                             // entity ID
       end-pi;                                                               // entity snapshot

       monitor;                                                              // catch all errors
         SnapShot(EntityID);                                                 // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // entity snapshot

      **********************************************************************************************

       dcl-proc PropertyLife3 export;                                        // property life story

       dcl-pi PropertyLife3;                                                 // entity snapshot
         EntityID like(EntNoteR.EntityID)   const;                           // entity ID
         Property like(EntNoteR.Property)   const;                           // property nickname
         Moment   like(EntNoteR.ChangeTime) const;                           // moment in time
       end-pi;                                                               // entity snapshot

       monitor;                                                              // catch all errors
         PropertyLife(EntityID:Property:Moment);                             // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // property life story

      **********************************************************************************************

       dcl-proc PropertyLife2 export;                                        // property life story

       dcl-pi PropertyLife2;                                                 // entity snapshot
         EntityID like(EntNoteR.EntityID) const;                             // entity ID
         Property like(EntNoteR.Property) const;                             // property nickname
       end-pi;                                                               // entity snapshot

       monitor;                                                              // catch all errors
         PropertyLife(EntityID:Property);                                    // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // property life story


      **********************************************************************************************
      *  HELPER PROCEDURES FOR INTEGRITY AND AUDIT SUPPORT
      **********************************************************************************************

       dcl-proc ValidProperty3 export;                                       // valid property

       dcl-pi ValidProperty3 ind;                                            // valid property
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const;                             // property data type
       end-pi;                                                               // valid property

       monitor;                                                              // catch all errors
         return ValidProperty(EntityID:Property:DataType);                   // call normal function
       on-error *all;                                                        // on any error
         return *off;                                                        // return false
       endmon;                                                               // catch all errors

       end-proc;                                                             // valid property

      **********************************************************************************************

       dcl-proc ValidProperty2 export;                                       // valid property

       dcl-pi ValidProperty2 ind;                                            // valid property
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
         Property like(EntFlagI.Property) const;                             // property nickname
       end-pi;                                                               // valid property

       monitor;                                                              // catch all errors
         return ValidProperty(EntityID:Property);                            // call normal function
       on-error *all;                                                        // on any error
         return *off;                                                        // return false
       endmon;                                                               // catch all errors

       end-proc;                                                             // valid property

      **********************************************************************************************

       dcl-proc ValidClassProperty3 export;                                  // valid class property

       dcl-pi ValidClassProperty3 ind;                                       // valid class property
         Class    like(EntHeadI.Class)    const;                             // class name
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const;                             // data type
       end-pi;                                                               // valid class property

       monitor;                                                              // catch all errors
         return ValidClassProperty(Class : Property : DataType);             // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // valid class property

      **********************************************************************************************

       dcl-proc ValidClassProperty2 export;                                  // valid class property

       dcl-pi ValidClassProperty2 ind;                                       // valid class property
         Class    like(EntHeadI.Class)    const;                             // class name
         Property like(EntFlagI.Property) const;                             // property nickname
       end-pi;                                                               // valid class property

       monitor;                                                              // catch all errors
         return ValidClassProperty(Class : Property);                        // call normal function
       on-error *all;                                                        // on any error
       endmon;                                                               // catch all errors

       end-proc;                                                             // valid class property

      **********************************************************************************************
