      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY SQL WRAPPERS                                *
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

      /copy qcpysrc,stdhsrvpgm                                                  h-spec for srvpgm
      /copy qcpysrc,stdentinp                                                   protytpes, work stg
      /copy qcpysrc,stdentout                                                   protytpes, work stg
      /copy qcpysrc,stdentrule                                                  protytpes, work stg
      /copy qcpysrc,stdentsql1                                                  protytpes, work stg

      **********************************************************************************************
      *  IDENTITY RESOLUTION
      **********************************************************************************************

       dcl-proc getEntityID5 export;                                         // get entity ID

       dcl-pi getEntityID5 like(EntHeadI.EntityID);                          // get entity ID
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const;                           // moment in time
       end-pi;                                                               // get entity ID

       monitor;                                                              // catch all errors
         return getEntityID(ParentID:Class:LegacyN:LegacyA:Moment);          // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no ID returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID

      **********************************************************************************************

       dcl-proc getEntityID4 export;                                         // get entity ID

       dcl-pi getEntityID4 like(EntHeadI.EntityID);                          // get entity ID
         ParentID like(EntHeadI.ParentID) const;                             // parent ID
         Class    like(EntHeadI.Class)    const;                             // entity class
         LegacyN  like(EntHeadI.LegacyN)  const;                             // legacy ID numeric
         LegacyA  like(EntHeadI.LegacyA)  const;                             // legacy ID alpha
       end-pi;                                                               // get entity ID

       monitor;                                                              // catch all errors
         return getEntityID(ParentID:Class:LegacyN:LegacyA);                 // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no ID returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID

      **********************************************************************************************

       dcl-proc getEntityIDn4 export;                                        // get entity ID (num)

       dcl-pi getEntityIDn4 like(EntHeadI.EntityID);                         // get entity ID (num)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         Moment   like(EntHeadI.CreateTime) const;                           // moment in time
       end-pi;                                                               // get entity ID (num)

       monitor;                                                              // catch all errors
         return getEntityID(ParentID:Class:LegacyN:' ':Moment);              // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no ID returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID (num)

      **********************************************************************************************

       dcl-proc getEntityIDn3 export;                                        // get entity ID (num)

       dcl-pi getEntityIDn3 like(EntHeadI.EntityID);                         // get entity ID (num)
         ParentID like(EntHeadI.ParentID) const;                             // parent ID
         Class    like(EntHeadI.Class)    const;                             // entity class
         LegacyN  like(EntHeadI.LegacyN)  const;                             // legacy ID numeric
       end-pi;                                                               // get entity ID (num)

       dcl-s MomentX like(EntHeadI.CreateTime);                              // current moment

       monitor;                                                              // catch all errors
         MomentX = getSessionMoment();                                       // use session moment
         return getEntityID(ParentID:Class:LegacyN:' ':MomentX);             // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no ID returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID (num)

      **********************************************************************************************

       dcl-proc getEntityIDa4 export;                                        // get entity ID (alph)

       dcl-pi getEntityIDa4 like(EntHeadI.EntityID);                         // get entity ID (alph)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const;                           // moment in time
       end-pi;                                                               // get entity ID (alph)

       monitor;                                                              // catch all errors
         return getEntityID(ParentID:Class:0:LegacyA:Moment);                // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no ID returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID (alph)

      **********************************************************************************************

       dcl-proc getEntityIDa3 export;                                        // get entity ID (alph)

       dcl-pi getEntityIDa3 like(EntHeadI.EntityID);                         // get entity ID (alph)
         ParentID like(EntHeadI.ParentID) const;                             // parent ID
         Class    like(EntHeadI.Class)    const;                             // entity class
         LegacyA  like(EntHeadI.LegacyA)  const;                             // legacy ID alpha
       end-pi;                                                               // get entity ID (alph)

       dcl-s MomentX like(EntHeadI.CreateTime);                              // current moment

       monitor;                                                              // catch all errors
         MomentX = getSessionMoment();                                       // use session moment
         return getEntityID(ParentID:Class:0:LegacyA:MomentX);               // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no ID returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID (alph)

      **********************************************************************************************
      *  RETRIEVAL OF ENTITY PROPERTY SUBTABLE VALUES
      **********************************************************************************************

       dcl-proc getDate3 export;                                             // get entity date

       dcl-pi getDate3 like(EntDateI.Value);                                 // get entity date
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDateI.ChangeTime) const;                           // moment in time
       end-pi;                                                               // get entity date

       monitor;                                                              // catch all errors
         return getDate(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return *loval;                                                      // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity date

      **********************************************************************************************

       dcl-proc getDate2 export;                                             // get entity date

       dcl-pi getDate2 like(EntDateI.Value);                                 // get entity date
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get entity date

       monitor;                                                              // catch all errors
         return getDate(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return *loval;                                                      // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity date

      **********************************************************************************************

       dcl-proc getDateN4 export;                                            // get date numeric

       dcl-pi getDateN4 zoned(8);                                            // get date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pi;                                                               // get date numeric

       monitor;                                                              // catch all errors
         return getDateN(EntityID:Property:DateFormat:Moment);               // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get date numeric

      **********************************************************************************************

       dcl-proc getDateN3 export;                                            // get date numeric

       dcl-pi getDateN3 zoned(8);                                            // get date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pi;                                                               // get date numeric

       monitor;                                                              // catch all errors
         return getDateN(EntityID:Property:DateFormat);                      // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get date numeric

      **********************************************************************************************

       dcl-proc getDateA4 export;                                            // get date alpha

       dcl-pi getDateA4 char(10);                                            // get date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pi;                                                               // get date alpha

       monitor;                                                              // catch all errors
         return getDateA(EntityID:Property:DateFormat:Moment);               // call normal function
       on-error *all;                                                        // on any error
         return *blanks;                                                     // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get date alpha

      **********************************************************************************************

       dcl-proc getDateA3 export;                                            // get date alpha

       dcl-pi getDateA3 char(10);                                            // get date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pi;                                                               // get date alpha

       monitor;                                                              // catch all errors
         return getDateA(EntityID:Property:DateFormat);                      // call normal function
       on-error *all;                                                        // on any error
         return *blanks;                                                     // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get date alpha

      **********************************************************************************************

       dcl-proc getFlag3 export;                                             // get entity flag

       dcl-pi getFlag3 like(EntFlagI.Value);                                 // get entity flag
         EntityID like(EntFlagI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntFlagI.ChangeTime) const;                           // moment in time
       end-pi;                                                               // get entity flag

       monitor;                                                              // catch all errors
         return getFlag(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return *blank;                                                      // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity flag

      **********************************************************************************************

       dcl-proc getFlag2 export;                                             // get entity flag

       dcl-pi getFlag2 like(EntFlagI.Value);                                 // get entity flag
         EntityID like(EntFlagI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get entity flag

       monitor;                                                              // catch all errors
         return getFlag(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return *blank;                                                      // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity flag

      **********************************************************************************************

       dcl-proc getLink3 export;                                             // get entity link

       dcl-pi getLink3 like(EntLinkI.Value);                                 // get entity link
         EntityID like(EntLinkI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntLinkI.ChangeTime) const;                           // change time stamp
       end-pi;                                                               // get entity link

       monitor;                                                              // catch all errors
         return getLink(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity link

      **********************************************************************************************

       dcl-proc getLink2 export;                                             // get entity link

       dcl-pi getLink2 like(EntLinkI.Value);                                 // get entity link
         EntityID like(EntLinkI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get entity link

       monitor;                                                              // catch all errors
         return getLink(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity link

      **********************************************************************************************

       dcl-proc getNote3 export;                                             // get entity note

       dcl-pi getNote3 like(EntNoteI.Value);                                 // get entity note
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNoteI.ChangeTime) const;                           // change time stamp
       end-pi;                                                               // get entity note

       monitor;                                                              // catch all errors
         return getNote(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return *blank;                                                      // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity note

      **********************************************************************************************

       dcl-proc getNote2 export;                                             // get entity note

       dcl-pi getNote2 like(EntNoteI.Value);                                 // get entity note
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get entity note

       monitor;                                                              // catch all errors
         return getNote(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return *blank;                                                      // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity note

      **********************************************************************************************

       dcl-proc getNumb3 export;                                             // get entity number

       dcl-pi getNumb3 like(EntNumbI.Value);                                 // get entity number
         EntityID like(EntNumbI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNumbI.ChangeTime) const;                           // change time stamp
       end-pi;                                                               // get entity number

       monitor;                                                              // catch all errors
         return getNumb(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity number

      **********************************************************************************************

       dcl-proc getNumb2 export;                                             // get entity number

       dcl-pi getNumb2 like(EntNumbI.Value);                                 // get entity number
         EntityID like(EntNumbI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get entity number

       monitor;                                                              // catch all errors
         return getNumb(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity number

      **********************************************************************************************

       dcl-proc getNotX3 export;                                             // get encrypted note

       dcl-pi getNotX3 like(EntNotXI.Value);                                 // get encrypted note
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNotXI.ChangeTime) const;                           // change time stamp
       end-pi;                                                               // get encrypted note

       monitor;                                                              // catch all errors
         return getNotX(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return *blanks;                                                     // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted note

      **********************************************************************************************

       dcl-proc getNotX2 export;                                             // get encrypted note

       dcl-pi getNotX2 like(EntNotXI.Value);                                 // get encrypted note
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get encrypted note

       monitor;                                                              // catch all errors
         return getNotX(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return *blanks;                                                     // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted note

      **********************************************************************************************

       dcl-proc getNumX3 export;                                             // get encrypted number

       dcl-pi getNumX3 like(EntNumbI.Value);                                 // get encrypted number
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNotXI.ChangeTime) const;                           // change time stamp
       end-pi;                                                               // get encrypted number

       monitor;                                                              // catch all errors
         return getNumX(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted number

      **********************************************************************************************

       dcl-proc getNumX2 export;                                             // get encrypted number

       dcl-pi getNumX2 like(EntNumbI.Value);                                 // get encrypted number
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get encrypted number

       monitor;                                                              // catch all errors
         return getNumX(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted note

      **********************************************************************************************

       dcl-proc getDatX3 export;                                             // get encrypted date

       dcl-pi getDatX3 like(EntDateI.Value);                                 // get encrypted date
         EntityID like(EntDatXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDatXI.ChangeTime) const;                           // change time stamp
       end-pi;                                                               // get encrypted date

       monitor;                                                              // catch all errors
         return getDatX(EntityID:Property:Moment);                           // call normal function
       on-error *all;                                                        // on any error
         return *loval;                                                      // low value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted date

      **********************************************************************************************

       dcl-proc getDatX2 export;                                             // get encrypted date

       dcl-pi getDatX2 like(EntDateI.Value);                                 // get encrypted date
         EntityID like(EntDatXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
       end-pi;                                                               // get encrypted note

       monitor;                                                              // catch all errors
         return getDatX(EntityID:Property);                                  // call normal function
       on-error *all;                                                        // on any error
         return *loval;                                                      // low value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted note

      **********************************************************************************************

       dcl-proc getDatxN4 export;                                            // get enc date numeric

       dcl-pi getDatxN4 zoned(8);                                            // get enc date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pi;                                                               // get enc date numeric

       monitor;                                                              // catch all errors
         return getDatxN(EntityID:Property:DateFormat:Moment);               // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get enc date numeric

      **********************************************************************************************

       dcl-proc getDatxN3 export;                                            // get enc date numeric

       dcl-pi getDatxN3 zoned(8);                                            // get enc date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pi;                                                               // get enc date numeric

       monitor;                                                              // catch all errors
         return getDatxN(EntityID:Property:DateFormat);                      // call normal function
       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get enc date numeric

      **********************************************************************************************

       dcl-proc getDatxA4 export;                                            // get enc date alpha

       dcl-pi getDatxA4 char(10);                                            // get enc date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
         Moment     like(EntDateI.ChangeTime) const;                         // moment in time
       end-pi;                                                               // get enc date alpha

       monitor;                                                              // catch all errors
         return getDatxA(EntityID:Property:DateFormat:Moment);               // call normal function
       on-error *all;                                                        // on any error
         return *blanks;                                                     // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get enc date alpha

      **********************************************************************************************

       dcl-proc getDatxA3 export;                                            // get enc date alpha

       dcl-pi getDatxA3 char(10);                                            // get enc date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5) const;                                           // date format
       end-pi;                                                               // get enc date alpha

       monitor;                                                              // catch all errors
         return getDatxA(EntityID:Property:DateFormat);                      // call normal function
       on-error *all;                                                        // on any error
         return *blanks;                                                     // no value returned
       endmon;                                                               // catch all errors

       end-proc;                                                             // get enc date alpha

      **********************************************************************************************
