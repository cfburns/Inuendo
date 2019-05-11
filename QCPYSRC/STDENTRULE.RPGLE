      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY BUSINESS RULES (PROTOTYPES & STORAGE)       *
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
      *  HELPER FUNCTIONS FOR INTEGRITY AND AUDIT SUPPORT
      **********************************************************************************************

       dcl-pr Ancestor like(EntHeadR.EntityID);                              // ancestor entity ID
         Descendant like(EntHeadR.EntityID) const;                           // descendant entity ID
         AncesClass like(EntHeadR.Class)    const;                           // ancestor class
       end-pr;                                                               // ancestor entity ID

       dcl-pr HasChildren ind;                                               // entity has children
         EntityID like(EntHeadR.EntityID) const;                             // entity ID
       end-pr;                                                               // entity has children

      **********************************************************************************************
      *  STORED PROCEDURES PRODUCING RESULT SETS
      **********************************************************************************************

       dcl-pr SnapShot;                                                      // entity snapshot
         EntityID like(EntHeadR.EntityID)   const;                           // entity ID
         Moment   like(EntHeadR.CreateTime) const options(*nopass);          // moment in time
       end-pr;                                                               // entity snapshot

       dcl-pr PropertyLife;                                                  // entity snapshot
         EntityID like(EntNoteR.EntityID)   const;                           // entity ID
         Property like(EntNoteR.Property)   const;                           // property nickname
         Moment   like(EntNoteR.ChangeTime) const options(*nopass);          // moment in time
       end-pr;                                                               // entity snapshot

       dcl-pr EntityList;                                                    // entity list
         ParentID   like(EntHeadR.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadR.Class)      const;                         // entity class
         LegacyA    like(EntHeadR.LegacyA)    const;                         // legacy ID alpha
         LegacyN    like(EntHeadR.LegacyN)    const;                         // legacy ID numeric
         Descriptor like(EntHeadR.Descriptor) const;                         // descriptor
       end-pr;                                                               // entity list

       dcl-pr EntityLife;                                                    // entity list
         EntityID like(EntHeadR.EntityID)   const;                           // parent entity ID
         Moment   like(EntHeadR.CreateTime) const options(*nopass);          // moment in time
       end-pr;                                                               // entity list

      **********************************************************************************************
      *  SEARCH FOR ENTITY
      **********************************************************************************************

       dcl-pr SearchEntity like(EntHeadR.EntityID);                          // search for entity
         ParentID like(EntHeadR.ParentID) const;                             // parent entity ID
         Class    like(EntHeadR.Class)    const;                             // ancestor class
         PrevID   like(EntHeadR.EntityID) const options(*nopass);            // previous entity ID
       end-pr;                                                               // search for entity

      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntHeadR ext extname('ENTHEAD') qualified template end-ds;     // record template
       dcl-ds EntPropR ext extname('ENTPROP') qualified template end-ds;     // record template
       dcl-ds EntDateR ext extname('ENTDATE') qualified template end-ds;     // record template
       dcl-ds EntFlagR ext extname('ENTFLAG') qualified template end-ds;     // record template
       dcl-ds EntLinkR ext extname('ENTLINK') qualified template end-ds;     // record template
       dcl-ds EntNoteR ext extname('ENTNOTE') qualified template end-ds;     // record template
       dcl-ds EntNumbR ext extname('ENTNUMB') qualified template end-ds;     // record template
       dcl-ds EntNotxR ext extname('ENTNOTX') qualified template end-ds;     // record template
       dcl-ds EntNumxR ext extname('ENTNUMX') qualified template end-ds;     // record template
       dcl-ds EntDatxR ext extname('ENTDATX') qualified template end-ds;     // record template

