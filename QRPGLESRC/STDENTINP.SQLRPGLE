      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY INPUT FUNCTIONS                             *
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

      /copy qcpysrc,stdhsrvpgm                                               // h-spec for srvpgm
      /copy qcpysrc,stdentinp                                                // protytpes, work stg
      /copy qcpysrc,stderrcod                                                // error code for APIs
      /copy qcpysrc,stdcrypfnc                                               // encryption functions
      /copy qcpysrc,usrspcapis                                               // user space api's

       dcl-pr MethodStmt like(EntHeadI.Descriptor);                          // SQL method statement
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntNoteI.Property)   const;                           // property nickname
         Moment   like(EntNoteI.ChangeTime) const;                           // change time stamp
       end-pr;                                                               // SQL method statement

       dcl-pr ValidMethod ind;                                               // valid method name
         Method like(EntHeadI.Descriptor) const;                             // method name
       end-pr;                                                               // valid method name

       dcl-pr RenameObject extpgm('QLIRNMO');                                // rename object
         FromName likeds(UsrSpcQual) const;                                  // from qualified name
         ObjType  char(10)           const;                                  // object type
         ToName   likeds(UsrSpcQual) const;                                  // to qualified name
         Replace  char(1)            const;                                  // initial value
         ErrCode  like(ErrorCode);                                           // error code
       end-pr;                                                               // rename object

       dcl-ds SMUsrSpc qualified;                                            // sess mom usrspc obj
         SMObject  char(10) inz('SETSSNMOM');                                // sess moment object
         SMLibrary char(10) inz('QTEMP');                                    // sess moment library
       end-ds;                                                               // sess mom usrspc obj

       dcl-s SessionMoment like(EntHeadI.CreateTime) based(SMPtr);           // sess moment
       dcl-s SMPtr         pointer;                                          // sess moment pointer


      **********************************************************************************************
      *  IDENTITY RESOLUTION
      **********************************************************************************************

       dcl-proc getEntityID export;                                          // get entity ID (both)

       dcl-pi getEntityID like(EntHeadI.EntityID);                           // get entity ID (both)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const options(*nopass);          // moment in time
       end-pi;                                                               // get entity ID (both)

       dcl-s ClassX    like(EntHeadI.Class);                                 // entity class
       dcl-s EntityIDx like(EntHeadI.EntityID);                              // entity ID
       dcl-s MomentX   like(EntHeadI.CreateTime);                            // moment in time

       monitor;                                                              // catch all errors

         if %parms >= 5;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         ClassX = UpperCase(Class);                                          // class in uppercase

         exec sql select ifnull(entityid, 0) into :EntityIDx from enthead
           where parentid    = :ParentID and class   = :ClassX
             and legacyn     = :LegacyN  and legacyA = :LegacyA
             and createtime <= :MomentX
           order by createtime desc fetch first row only;                    // latest before moment

         return EntityIDx;                                                   // return entity ID

       on-error *all;                                                        // on any error
         return 0;                                                           // no ID returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID (both)

      **********************************************************************************************

       dcl-proc getEntityIDn export;                                         // get entity ID (num)

       dcl-pi getEntityIDn like(EntHeadI.EntityID);                          // get entity ID (num)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyN  like(EntHeadI.LegacyN)    const;                           // legacy ID numeric
         Moment   like(EntHeadI.CreateTime) const options(*nopass);          // moment in time
       end-pi;                                                               // get entity ID (num)

       dcl-s LegacyAx  like(EntHeadI.LegacyA);                               // legacy ID alpha
       dcl-s EntityIDx like(EntHeadI.EntityID);                              // entity ID
       dcl-s MomentX   like(EntHeadI.CreateTime);                            // moment in time

       monitor;                                                              // catch all errors

         if %parms >= 4;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         return getEntityID(ParentID:Class:LegacyN:LegacyAx:MomentX);        // return entity ID

       on-error *all;                                                        // on any error

         return 0;                                                           // no ID returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID (num)

      **********************************************************************************************

       dcl-proc getEntityIDa export;                                         // get entity ID (alph)

       dcl-pi getEntityIDa like(EntHeadI.EntityID);                          // get entity ID (alph)
         ParentID like(EntHeadI.ParentID)   const;                           // parent ID
         Class    like(EntHeadI.Class)      const;                           // entity class
         LegacyA  like(EntHeadI.LegacyA)    const;                           // legacy ID alpha
         Moment   like(EntHeadI.CreateTime) const options(*nopass);          // moment in time
       end-pi;                                                               // get entity ID (alph)

       dcl-s LegacyNx  like(EntHeadI.LegacyN);                               // legacy ID numeric
       dcl-s EntityIDx like(EntHeadI.EntityID);                              // entity ID
       dcl-s MomentX   like(EntHeadI.CreateTime);                            // moment in time

       monitor;                                                              // catch all errors

         if %parms >= 4;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         return getEntityID(ParentID:Class:LegacyNx:LegacyA:MomentX);        // return entity ID

       on-error *all;                                                        // on any error

         return 0;                                                           // no ID returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity ID (alph)


      **********************************************************************************************
      *  RETRIEVAL OF ENTITY PROPERTY SUBTABLE VALUES
      **********************************************************************************************

       dcl-proc getDate export;                                              // get entity date

       dcl-pi getDate like(EntDateI.Value);                                  // get entity date
         EntityID like(EntDateI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDateI.ChangeTime) const options(*nopass);          // moment in time
       end-pi;                                                               // get entity date

       dcl-s DateX     like(EntDateI.Value);                                 // date value
       dcl-s MomentX   like(EntDateI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntDateI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntDateI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if it's a property
           exec sql select ifnull(value, :DateX) into :DateX from entdate
             where entityid    = :OwnerX and property = :PropertyX
               and changetime <= :MomentX
             order by changetime desc fetch first row only;                  // latest before moment
         elseif OwnerX < 0;                                                  // or it's a method
           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement
           exec sql prepare getDateX1 from :SQLStmX;                         // prepare statement
           exec sql execute getDateX1 using :DateX;                          // attempt function
         endif;                                                              // if it's a property

         return DateX;                                                       // return date value

       on-error *all;                                                        // on any error
         return *loval;                                                      // no value returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity date

      **********************************************************************************************

       dcl-proc getDateN export;                                             // get date numeric

       dcl-pi getDateN zoned(8);                                             // get date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5)                   const;                         // date format
         Moment     like(EntDateI.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // get date numeric

       dcl-s MomentX like(EntDateI.ChangeTime);                              // moment in time
       dcl-s DateX like(EntDateI.Value);                                     // date value native
       dcl-s DateNumX zoned(8);                                              // date value numeric
       dcl-s DateFormatX char(5);                                            // date format work

       monitor;                                                              // catch all errors

         if %parms >= 4;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         DateX = getDate(EntityID:Property:MomentX);                         // date value native

         if DateX <> *loval;                                                 // if date retrieved

           DateFormatX = UpperCase(DateFormat);                              // uppercase format

           if DateFormatX = '*MDY';                                          // if MDY format
             DateNumX = %dec(DateX:*mdy);                                    // convert from native
           elseif DateFormatX = '*YMD';                                      // or YMD format
             DateNumX = %dec(DateX:*ymd);                                    // convert from native
           elseif DateFormatX = '*DMY';                                      // or DMY format
             DateNumX = %dec(DateX:*dmy);                                    // convert from native
           elseif DateFormatX = '*JUL';                                      // or julian format
             DateNumX = %dec(DateX:*jul);                                    // convert from native
           elseif DateFormatX = '*ISO';                                      // or ISO format
             DateNumX = %dec(DateX:*iso);                                    // convert from native
           elseif DateFormatX = '*USA';                                      // or USA format
             DateNumX = %dec(DateX:*usa);                                    // convert from native
           elseif DateFormatX = '*EUR';                                      // or European format
             DateNumX = %dec(DateX:*eur);                                    // convert from native
           elseif DateFormatX = '*JIS';                                      // or Japanese format
             DateNumX = %dec(DateX:*jis);                                    // convert from native
           else;                                                             // or invalid format
             DateNumX = 0;                                                   // leave date zero
           endif;                                                            // if MDY format

         endif;                                                              // if date retrieved

       on-error *all;                                                        // on any error
         DateNumX = 0;                                                       // no value returned

       endmon;                                                               // catch all errors

       return DateNumX;                                                      // return numeric date

       end-proc;                                                             // get date numeric

      **********************************************************************************************

       dcl-proc getDateA export;                                             // get date alpha

       dcl-pi getDateA char(10);                                             // get date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5)                   const;                         // date format
         Moment     like(EntDateI.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // get date alpha

       dcl-s MomentX like(EntDateI.ChangeTime);                              // moment in time
       dcl-s DateX   like(EntDateI.Value);                                   // date value native
       dcl-s DateAlphaX char(10);                                            // date value alpha
       dcl-s DateFormatX char(5);                                            // date format work

       monitor;                                                              // catch all errors

         if %parms >= 4;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         DateX = getDate(EntityID:Property:MomentX);                         // date value native

         if DateX <> *loval;                                                 // if date retrieved

           DateFormatX = UpperCase(DateFormat);                              // uppercase format

           if DateFormatX = '*MDY';                                          // if MDY format
             DateAlphaX = %char(DateX:*mdy);                                 // convert from native
           elseif DateFormatX = '*YMD';                                      // or YMD format
             DateAlphaX = %char(DateX:*ymd);                                 // convert from native
           elseif DateFormatX = '*DMY';                                      // or DMY format
             DateAlphaX = %char(DateX:*dmy);                                 // convert from native
           elseif DateFormatX = '*JUL';                                      // or julian format
             DateAlphaX = %char(DateX:*jul);                                 // convert from native
           elseif DateFormatX = '*ISO';                                      // or ISO format
             DateAlphaX = %char(DateX:*iso);                                 // convert from native
           elseif DateFormatX = '*USA';                                      // or USA format
             DateAlphaX = %char(DateX:*usa);                                 // convert from native
           elseif DateFormatX = '*EUR';                                      // or European format
             DateAlphaX = %char(DateX:*eur);                                 // convert from native
           elseif DateFormatX = '*JIS';                                      // or Japanese format
             DateAlphaX = %char(DateX:*jis);                                 // convert from native
           elseif DateFormatX = '*MDY0';                                     // if MDY format
             DateAlphaX = %char(DateX:*mdy0);                                // convert from native
           elseif DateFormatX = '*YMD0';                                     // or YMD format
             DateAlphaX = %char(DateX:*ymd0);                                // convert from native
           elseif DateFormatX = '*DMY0';                                     // or DMY format
             DateAlphaX = %char(DateX:*dmy0);                                // convert from native
           elseif DateFormatX = '*JUL0';                                     // or julian format
             DateAlphaX = %char(DateX:*jul0);                                // convert from native
           elseif DateFormatX = '*ISO0';                                     // or ISO format
             DateAlphaX = %char(DateX:*iso0);                                // convert from native
           elseif DateFormatX = '*USA0';                                     // or USA format
             DateAlphaX = %char(DateX:*usa0);                                // convert from native
           elseif DateFormatX = '*EUR0';                                     // or European format
             DateAlphaX = %char(DateX:*eur0);                                // convert from native
           elseif DateFormatX = '*JIS0';                                     // or Japanese format
             DateAlphaX = %char(DateX:*jis0);                                // convert from native
           else;                                                             // or invalid format
             DateAlphaX = *blanks;                                           // leave date blank
           endif;                                                            // if MDY format

         endif;                                                              // if date retrieved

       on-error *all;                                                        // on any error
         DateAlphaX = *blanks;                                               // no value returned

       endmon;                                                               // catch all errors

       return DateAlphaX;                                                    // return alpha date

       end-proc;                                                             // get date alpha

      **********************************************************************************************

       dcl-proc getFlag export;                                              // get entity flag

       dcl-pi getFlag like(EntFlagI.Value);                                  // get entity flag
         EntityID like(EntFlagI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntFlagI.ChangeTime) const options(*nopass);          // moment in time
       end-pi;                                                               // get entity flag

       dcl-s FlagX     like(EntFlagI.Value);                                 // flag value
       dcl-s MomentX   like(EntFlagI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntFlagI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntFlagI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if it's a property
           exec sql select ifnull(value, :FlagX) into :FlagX from entflag
             where entityid    = :OwnerX and property = :PropertyX
               and changetime <= :MomentX
             order by changetime desc fetch first row only;                  // latest before moment
         elseif OwnerX < 0;                                                  // or it's a method
           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement
           exec sql prepare getFlagX1 from :SQLStmX;                         // prepare statement
           exec sql execute getFlagX1 using :FlagX;                          // attempt function
         endif;                                                              // if it's a property

         return FlagX;                                                       // return flag value

       on-error *all;                                                        // on any error
         return *blank;                                                      // no value returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity flag

      **********************************************************************************************

       dcl-proc getLink export;                                              // get entity link

       dcl-pi getLink like(EntLinkI.Value);                                  // get entity link
         EntityID like(EntLinkI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntLinkI.ChangeTime) const options(*nopass);          // change time stamp
       end-pi;                                                               // get entity link

       dcl-s LinkX     like(EntLinkI.Value);                                 // link value
       dcl-s MomentX   like(EntLinkI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntLinkI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntLinkI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if it's a property
           exec sql select ifnull(value, :LinkX) into :LinkX from entlink
             where entityid = :OwnerX and property = :PropertyX
               and changetime <= :MomentX
             order by changetime desc fetch first row only;                  // latest before moment
         elseif OwnerX < 0;                                                  // or it's a method
           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement
           exec sql prepare getLinkX1 from :SQLStmX;                         // prepare statement
           exec sql execute getLinkX1 using :LinkX;                          // attempt function
         endif;                                                              // if it's a property

         return LinkX;                                                       // return link value

       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity link

      **********************************************************************************************

       dcl-proc getNote export;                                              // get entity note

       dcl-pi getNote like(EntNoteI.Value);                                  // get entity note
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNoteI.ChangeTime) const options(*nopass);          // change time stamp
       end-pi;                                                               // get entity note

       dcl-s NoteX     like(EntNoteI.Value);                                 // note value
       dcl-s MomentX   like(EntNoteI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntNoteI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntNoteI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if valid owner ID
           exec sql select ifnull(value, :NoteX) into :NoteX from entnote
             where entityid = :OwnerX   and property = :PropertyX
               and changetime <= :MomentX
             order by changetime desc fetch first row only;                  // latest before moment
         elseif OwnerX < 0;                                                  // maybe it's a method
           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement
           exec sql prepare getNoteX1 from :SQLStmX;                         // prepare statement
           exec sql execute getNoteX1 using :NoteX;                          // attempt function
         endif;                                                              // if valid owner ID

         return NoteX;                                                       // return note value

       on-error *all;                                                        // on any error
         return *blank;                                                      // no value returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity note

      **********************************************************************************************

       dcl-proc getNumb export;                                              // get entity number

       dcl-pi getNumb like(EntNumbI.Value);                                  // get entity number
         EntityID like(EntNumbI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNumbI.ChangeTime) const options(*nopass);          // change time stamp
       end-pi;                                                               // get entity number

       dcl-s NumbX     like(EntNumbI.Value);                                 // number value
       dcl-s MomentX   like(EntNumbI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntNumbI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntNumbI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if it's a property
           exec sql select ifnull(value, :NumbX) into :NumbX from entnumb
             where entityid = :OwnerX and property = :PropertyX
               and changetime <= :MomentX
             order by changetime desc fetch first row only;                  // latest before moment
         elseif OwnerX < 0;                                                  // or it's a method
           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement
           exec sql prepare getNumbX1 from :SQLStmX;                         // prepare statement
           exec sql execute getNumbX1 using :NumbX;                          // attempt function
         endif;                                                              // if it's a property

         return NumbX;                                                       // return number value

       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get entity number

      **********************************************************************************************

       dcl-proc getNotX export;                                              // get encrypted note

       dcl-pi getNotX like(EntNoteI.Value);                                  // get encrypted note
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNoteI.ChangeTime) const options(*nopass);          // change time stamp
       end-pi;                                                               // get encrypted note

       dcl-s EncNoteX  like(EntNotXI.Value);                                 // encrypted note value
       dcl-s DecNoteX  like(EntNoteI.Value);                                 // decrypted note value
       dcl-s MomentX   like(EntNotXI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntNotXI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntNotXI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if it's a property

           exec sql
             select value into :EncNoteX from entnotx
               where entityid = :OwnerX and property = :PropertyX
                 and changetime <= :MomentX
               order by changetime desc fetch first row only;                // latest before moment

           if EncNoteX = *blanks;                                            // if no value
             DecNoteX = *blanks;                                             // assume blank value
           else;                                                             // value exists
             DecNoteX = Decrypt(EncNotex);                                   // decrypt value
           endif;                                                            // if value exists

         elseif OwnerX < 0;                                                  // or it's a method

           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement

           exec sql prepare getNotxX1 from :SQLStmX;                         // prepare statement
           exec sql execute getNotxX1 using :DecNoteX;                       // attempt function

         endif;                                                              // if it's a property

         return DecNoteX;                                                    // return note value

       on-error *all;                                                        // on any error
         return *blanks;                                                     // no value returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted note

      **********************************************************************************************

       dcl-proc getNumX export;                                              // get encrypted number

       dcl-pi getNumX like(EntNumbI.Value);                                  // get encrypted number
         EntityID like(EntNotXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntNotXI.ChangeTime) const options(*nopass);          // change time stamp
       end-pi;                                                               // get encrypted number

       dcl-ds *n;                                                            // type conversion
         ChrNumbX char(25);                                                  // character number
         DecNumbX zoned(25:7) overlay(ChrNumbX);                             // number value
       end-ds;                                                               // type conversion

       dcl-s MomentX   like(EntNotXI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntNotXI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntNotXI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement
       dcl-s EncNumbX  like(EntNumXI.Value);                                 // encrypted numb value

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if it's a property

           exec sql
             select value into :EncNumbX from entnumx
               where entityid = :OwnerX and property = :PropertyX
                 and changetime <= :MomentX
               order by changetime desc fetch first row only;                // latest before moment

           if EncNumbX = *blanks;                                            // if no value
             ChrNumbX = *zeros;                                              // assume zero value
           else;                                                             // value exists
             ChrNumbX = Decrypt(EncNumbX);                                   // decrypt value
           endif;                                                            // if no value

         elseif OwnerX < 0;                                                  // or it's a method

           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement

           exec sql prepare getNotxX1 from :SQLStmX;                         // prepare statement
           exec sql execute getNotxX1 using :DecNumbX;                       // attempt function

         endif;                                                              // if it's a property

         return DecNumbX;                                                    // return number value

       on-error *all;                                                        // on any error
         return 0;                                                           // no value returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted number

      **********************************************************************************************

       dcl-proc getDatX export;                                              // get encrypted date

       dcl-pi getDatX like(EntDateI.Value);                                  // get encrypted date
         EntityID like(EntDatXI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property nickname
         Moment   like(EntDatXI.ChangeTime) const options(*nopass);          // change time stamp
       end-pi;                                                               // get encrypted date

       dcl-s EncDateX  like(EntDatXI.Value);                                 // encrypted date value
       dcl-s DecDateX  like(EntDateI.Value);                                 // decrypted date value
       dcl-s MomentX   like(EntDatXI.ChangeTime);                            // moment in time
       dcl-s OwnerX    like(EntDatXI.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntDatXI.Property);                              // property nickname
       dcl-s SQLStmX   like(EntHeadI.Descriptor);                            // SQL statement

       monitor;                                                              // catch all errors

         OwnerX    = PropertyOwner(EntityID:Property);                       // owner entity ID
         PropertyX = FinalSegment(Property);                                 // final path segment

         if %parms >= 3;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         if OwnerX > 0;                                                      // if it's a property

           exec sql
             select value into :EncDateX from entdatx
               where entityid = :OwnerX and property = :PropertyX
                 and changetime <= :MomentX
               order by changetime desc fetch first row only;                // latest before moment

           if EncDateX = *blanks;                                            // if no value
             DecDateX = *loval;                                              // assume low date
           else;                                                             // value exists
             DecDateX = %date(Decrypt(EncDateX) : *iso);                     // decrypt value
           endif;                                                            // if no value

         elseif OwnerX < 0;                                                  // or it's a method

           SQLStmX = MethodStmt(EntityID:PropertyX:MomentX);                 // SQL method statement

           exec sql prepare getDatxX1 from :SQLStmX;                         // prepare statement
           exec sql execute getDatxX1 using :DecDateX;                       // attempt function

         endif;                                                              // if it's a property

         return DecDateX;                                                    // return date value

       on-error *all;                                                        // on any error
         return *loval;                                                      // low date returned

       endmon;                                                               // catch all errors

       end-proc;                                                             // get encrypted date

      **********************************************************************************************

       dcl-proc getDatxN export;                                             // get enc date numeric

       dcl-pi getDatxN zoned(8);                                             // get enc date numeric
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5)                   const;                         // date format
         Moment     like(EntDateI.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // get enc date numeric

       dcl-s MomentX like(EntDateI.ChangeTime);                              // moment in time
       dcl-s DateX   like(EntDateI.Value);                                   // date value native
       dcl-s DateNumX zoned(8);                                              // date value numeric
       dcl-s DateFormatX char(5);                                            // date format work

       monitor;                                                              // catch all errors

         if %parms >= 4;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         DateX = getDatx(EntityID:Property:MomentX);                         // date value native

         if DateX <> *loval;                                                 // if date retrieved

           DateFormatX = UpperCase(DateFormat);                              // uppercase format

           if DateFormatX = '*MDY';                                          // if MDY format
             DateNumX = %dec(DateX:*mdy);                                    // convert from native
           elseif DateFormatX = '*YMD';                                      // or YMD format
             DateNumX = %dec(DateX:*ymd);                                    // convert from native
           elseif DateFormatX = '*DMY';                                      // 3r DMY format
             DateNumX = %dec(DateX:*dmy);                                    // convert from native
           elseif DateFormatX = '*JUL';                                      // or julian format
             DateNumX = %dec(DateX:*jul);                                    // convert from native
           elseif DateFormatX = '*ISO';                                      // or ISO format
             DateNumX = %dec(DateX:*iso);                                    // convert from native
           elseif DateFormatX = '*USA';                                      // or USA format
             DateNumX = %dec(DateX:*usa);                                    // convert from native
           elseif DateFormatX = '*EUR';                                      // or European format
             DateNumX = %dec(DateX:*eur);                                    // convert from native
           elseif DateFormatX = '*JIS';                                      // or Japanese format
             DateNumX = %dec(DateX:*jis);                                    // convert from native
           else;                                                             // or invalid format
             DateNumX = 0;                                                   // leave date zero
           endif;                                                            // if MDY format

         endif;                                                              // if date retrieved

       on-error *all;                                                        // on any error
         DateNumX = 0;                                                       // no value returned

       endmon;                                                               // catch all errors

       return DateNumX;                                                      // return numeric date

       end-proc;                                                             // get enc date numeric

      **********************************************************************************************

       dcl-proc getDatxA export;                                             // get encr date alpha

       dcl-pi getDatxA char(10);                                             // get encr date alpha
         EntityID   like(EntDateI.EntityID)   const;                         // entity ID
         Property   like(EntHeadI.Descriptor) const;                         // property nickname
         DateFormat char(5)                   const;                         // date format
         Moment     like(EntDateI.ChangeTime) const options(*nopass);        // moment in time
       end-pi;                                                               // get encr date alpha

       dcl-s MomentX like(EntDateI.ChangeTime);                              // moment in time
       dcl-s DateX   like(EntDateI.Value);                                   // date value native
       dcl-s DateAlphaX char(10);                                            // date value alpha
       dcl-s DateFormatX char(5);                                            // date format work

       monitor;                                                              // catch all errors

         if %parms >= 4;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         DateX = getDatx(EntityID:Property:MomentX);                         // date value native

         if DateX <> *loval;                                                 // if date retrieved

           DateFormatX = UpperCase(DateFormat);                              // uppercase format

           if DateFormatX = '*MDY';                                          // if MDY format
             DateAlphaX = %char(DateX:*mdy);                                 // convert from native
           elseif DateFormatX = '*YMD';                                      // or YMD format
             DateAlphaX = %char(DateX:*ymd);                                 // convert from native
           elseif DateFormatX = '*DMY';                                      // or DMY format
             DateAlphaX = %char(DateX:*dmy);                                 // convert from native
           elseif DateFormatX = '*JUL';                                      // or julian format
             DateAlphaX = %char(DateX:*jul);                                 // convert from native
           elseif DateFormatX = '*ISO';                                      // or ISO format
             DateAlphaX = %char(DateX:*iso);                                 // convert from native
           elseif DateFormatX = '*USA';                                      // or USA format
             DateAlphaX = %char(DateX:*usa);                                 // convert from native
           elseif DateFormatX = '*EUR';                                      // or European format
             DateAlphaX = %char(DateX:*eur);                                 // convert from native
           elseif DateFormatX = '*JIS';                                      // or Japanese format
             DateAlphaX = %char(DateX:*jis);                                 // convert from native
           elseif DateFormatX = '*MDY0';                                     // if MDY format
             DateAlphaX = %char(DateX:*mdy0);                                // convert from native
           elseif DateFormatX = '*YMD0';                                     // or YMD format
             DateAlphaX = %char(DateX:*ymd0);                                // convert from native
           elseif DateFormatX = '*DMY0';                                     // or DMY format
             DateAlphaX = %char(DateX:*dmy0);                                // convert from native
           elseif DateFormatX = '*JUL0';                                     // or julian format
             DateAlphaX = %char(DateX:*jul0);                                // convert from native
           elseif DateFormatX = '*ISO0';                                     // or ISO format
             DateAlphaX = %char(DateX:*iso0);                                // convert from native
           elseif DateFormatX = '*USA0';                                     // or USA format
             DateAlphaX = %char(DateX:*usa0);                                // convert from native
           elseif DateFormatX = '*EUR0';                                     // or European format
             DateAlphaX = %char(DateX:*eur0);                                // convert from native
           elseif DateFormatX = '*JIS0';                                     // or Japanese format
             DateAlphaX = %char(DateX:*jis0);                                // convert from native
           else;                                                             // or invalid format
             DateAlphaX = *blanks;                                           // leave date blank
           endif;                                                            // if MDY format

         endif;                                                              // if date retrieved

       on-error *all;                                                        // on any error
         DateAlphaX = *blanks;                                               // no value returned

       endmon;                                                               // catch all errors

       return DateAlphaX;                                                    // return alpha date

       end-proc;                                                             // get encr date alpha

      **********************************************************************************************
      *  RETRIEVAL OF ENTITY HEADER METADATA
      **********************************************************************************************

       dcl-proc getParentID export;                                          // get entity parent ID

       dcl-pi getParentID like(EntHeadI.ParentID);                           // get entity parent ID
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pi;                                                               // get entity parent ID

       dcl-s ParentIDx like(EntHeadI.EntityID);                              // entity parent ID

       exec sql
         select ifnull(parentid, 0) into :ParentIDx from enthead
           where entityid = :EntityID;                                       // retrieve parent ID

       return ParentIDx;                                                     // return parent ID

       end-proc;                                                             // get entity parent ID

      **********************************************************************************************

       dcl-proc getClass export;                                             // get entity class

       dcl-pi getClass like(EntHeadI.Class);                                 // get entity class
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pi;                                                               // get entity class

       dcl-s ClassX like(EntHeadI.Class);                                    // entity class

       exec sql
         select ifnull(class, ' ') into :ClassX from enthead
           where entityid = :EntityID;                                       // retrieve class

       return ClassX;                                                        // return class

       end-proc;                                                             // get entity class

      **********************************************************************************************

       dcl-proc getDescriptor export;                                        // get entity descrip

       dcl-pi getDescriptor like(EntHeadI.descriptor);                       // get entity descrip
         EntityID like(EntHeadI.entityID) const;                             // entity ID
       end-pi;                                                               // get entity descrip

       dcl-s DescriptorX like(EntHeadI.descriptor);                          // entity descriptor

       exec sql
         select ifnull(descriptor, ' ') into :DescriptorX from enthead
           where entityid = :EntityID;                                       // retrieve descriptor

       return DescriptorX;                                                   // return descriptor

       end-proc;                                                             // get entity descrip

      **********************************************************************************************

       dcl-proc getLegacyN export;                                           // get legacy ID numer

       dcl-pi getLegacyN like(EntHeadI.LegacyN);                             // get legacy ID numer
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pi;                                                               // get legacy ID numer

       dcl-s LegacyNx like(EntHeadI.LegacyN);                                // legacy ID numeric

       exec sql
         select ifnull(legacyn, 0) into :LegacyNx from enthead
           where entityid = :EntityID;                                       // retrieve legacy ID

       return LegacyNx;                                                      // return legacy ID

       end-proc;                                                             // get legacy ID numer

      **********************************************************************************************

       dcl-proc getLegacyA export;                                           // get legacy ID alpha

       dcl-pi getLegacyA like(EntHeadI.LegacyA);                             // get legacy ID alpha
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pi;                                                               // get legacy ID alpha

       dcl-s LegacyAx like(EntHeadI.LegacyA);                                // legacy ID alpha

       exec sql
         select ifnull(legacya, ' ') into :LegacyAx from enthead
           where entityid = :EntityID;                                       // retrieve legacy ID

       return LegacyAx;                                                      // return legacy ID

       end-proc;                                                             // get legacy ID alpha

      **********************************************************************************************

       dcl-proc getStatus export;                                            // get entity status

       dcl-pi getStatus like(EntHeadI.Status);                               // get entity status
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
       end-pi;                                                               // get entity status

       dcl-s StatusX like(EntHeadI.Status);                                  // entity status

       exec sql
         select ifnull(status, ' ') into :StatusX from enthead
           where entityid = :EntityID;                                       // retrieve status

       return StatusX;                                                       // return status

       end-proc;                                                             // get entity status

      **********************************************************************************************
      *  HELPER PROCEDURES FOR INTEGRITY AND AUDIT SUPPORT
      **********************************************************************************************

       dcl-proc ValidProperty export;                                        // valid property

       dcl-pi ValidProperty ind;                                             // valid property
         EntityID like(EntHeadI.EntityID) const;                             // entity ID
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const options(*nopass);            // data type
       end-pi;                                                               // valid property

       dcl-s ClassX like(EntHeadI.Class);                                    // entity class

       ClassX = getClass(EntityID);                                          // entity class

       if %parms >= 3;                                                       // if data type passed
         return ValidClassProperty(ClassX:Property:DataType);                // validate with type
       else;                                                                 // no data type passed
         return ValidClassProperty(ClassX:Property);                         // validate combo only
       endif;                                                                // if data type passed

       end-proc;                                                             // valid property

      **********************************************************************************************

       dcl-proc PropertyOwner export;                                        // property owner

       dcl-pi PropertyOwner like(EntHeadI.EntityID);                         // valid property
         EntityID like(EntHeadI.EntityID)   const;                           // entity ID
         Property like(EntHeadI.Descriptor) const;                           // property path
       end-pi;                                                               // valid property

       dcl-s PropertyX     like(EntHeadI.Descriptor);                        // property nickname
       dcl-s ThisLevelProp like(EntPropI.Property);                          // this level property
       dcl-s NextLevelProp like(EntHeadI.Descriptor);                        // next level property
       dcl-s NextLevelID   like(EntHeadI.EntityID);                          // next level entity ID
       dcl-s DelimiterPos  packed(3);                                        // delimiter position

       // If the property has multiple levels separated by a delimiter, drill
       //   downward through the links, else bubble upward until a valid
       //   property owner is found.

       PropertyX = UpperCase(Property);                                      // upper case property

       DelimiterPos = %scan(Delimiter:PropertyX);                            // delimiter position

       if DelimiterPos > 1;                                                  // if multiple levels

         ThisLevelProp = %subst(PropertyX:1:DelimiterPos - 1);               // this level property
         NextLevelProp = %subst(PropertyX:DelimiterPos + 1);                 // next level property

         if ValidProperty(EntityID:ThisLevelProp:'LINK');                    // if it's a link
           NextLevelID = getLink(EntityID:ThisLevelProp);                    // next level entity ID
           return PropertyOwner(NextLevelID:NextLevelProp);                  // drill down one level
         else;                                                               // not a link
           return 0;                                                         // cannot resolve
         endif;                                                              // if it's a link

       endif;                                                                // if multiple levels

       // If the property is valid for this entity, they simply return this
       //   entity ID as the owner.  Otherwise, as long as it's not already
       //   at the founder level, bubble upward through the ancestry until
       //   a valid property owner is found.

       if ValidProperty(EntityID:PropertyX);                                 // if valid property
         return EntityID;                                                    // return this entity
       elseif ValidMethod(PropertyX);                                        // or valid method
         return -EntityID;                                                   // return negative ID
       elseif EntityID = FounderID or EntityID = 0;                          // or already at top
         return 0;                                                           // cannot resolve
       else;                                                                 // still has ancestors
         NextLevelID = getParentID(EntityID);                                // next level entity ID
         return PropertyOwner(NextLevelID:PropertyX);                        // bubble upward
       endif;                                                                // if valid property

       end-proc;                                                             // property owner

      **********************************************************************************************

       dcl-proc FinalSegment export;                                         // final path segment

       dcl-pi FinalSegment like(EntPropI.Property);                          // final path segment
         FullPath like(EntHeadI.Descriptor) const;                           // full property path
       end-pi;                                                               // final path segment

       dcl-s FullPathX like(EntHeadI.Descriptor);                            // full property path

       FullPathX = FullPath;                                                 // full property path

       dow %scan(Delimiter : FullPathX) > 0;                                 // while property path
         FullPathX = %subst(FullPathX : (1 + %scan(Delimiter : FullPathX))); // strip first segment
       enddo;                                                                // while property path

       return UpperCase(FullPathX);                                          // return last segment

       end-proc;                                                             // final path segment

      **********************************************************************************************

       dcl-proc UpperCase export;                                            // cast as upper case

       dcl-pi UpperCase like(EntNoteI.Value);                                // cast as upper case
         FreeText like(EntNoteI.Value) const;                                // free form text
       end-pi;                                                               // cast as upper case

       dcl-c lower 'abcdefghijklmnopqrstuvwxyz';                             // lower case letters
       dcl-c upper 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';                             // upper case letters

       return %xlate(lower : upper : FreeText);                              // return upper case

       end-proc;                                                             // cast as upper case

      **********************************************************************************************

       dcl-proc ValidClass export;                                           // valid class name

       dcl-pi ValidClass ind;                                                // valid class name
         Class like(EntHeadI.Class) const;                                   // class name argument
       end-pi;                                                               // valid class name

       dcl-s ClassX like(EntHeadI.Class);                                    // entity class
       dcl-s CountX packed(1);                                               // count work field

       ClassX = UpperCase(Class);                                            // class in uppercase

       exec sql select ifnull(count(*), 0) into :CountX from entprop
         where class = :ClassX and property <= ' ';                          // find class header

       return (CountX > 0);                                                  // true if found

       end-proc;                                                             // valid class name

      **********************************************************************************************

       dcl-proc MethodStmt;                                                  // SQL method statement

       dcl-pi MethodStmt like(EntHeadI.Descriptor);                          // SQL method statement
         EntityID like(EntNoteI.EntityID)   const;                           // entity ID
         Property like(EntNoteI.Property)   const;                           // property nickname
         Moment   like(EntNoteI.ChangeTime) const;                           // change time stamp
       end-pi;                                                               // SQL method statement

       dcl-s SQLStmX like(EntHeadI.Descriptor);                              // SQL statement
       dcl-c SQuote x'7D';                                                   // single quote

       SQLStmX = 'values( select ' + Property + '('
               + 'bigint(' + %char(EntityID) + '), '
               + 'timestamp(' + SQuote + %char(Moment) + Squote + ')) '
               + 'from enthead where entityid = 1) into ?';                  // build function call

       return SQLStmX;                                                       // return SQL statement

       end-proc;                                                             // SQL method statement

      **********************************************************************************************

       dcl-proc ValidMethod;                                                 // valid method name

       dcl-pi ValidMethod ind;                                               // valid method name
         Method like(EntHeadI.Descriptor) const;                             // method name
       end-pi;                                                               // valid method name

       dcl-s MethodX like(EntHeadI.Descriptor);                              // method work field
       dcl-s CountX  like(EntPropI.Sequencer);                               // count work field

       MethodX = UpperCase(Method);                                          // method in uppercase

       exec sql select ifnull(count(*), 0) into :CountX from sysfuncs
         where funcname = :MethodX;                                          // find function

       return (CountX > 0);                                                  // true if found

       end-proc;                                                             // valid method name

      **********************************************************************************************

       dcl-proc ValidClassProperty export;                                   // valid class property

       dcl-pi ValidClassProperty ind;                                        // valid class property
         Class    like(EntHeadI.Class)    const;                             // class name
         Property like(EntFlagI.Property) const;                             // property nickname
         DataType like(EntPropI.DataType) const options(*nopass);            // data type
       end-pi;                                                               // valid class property

       dcl-s PropertyX like(EntFlagI.Property);                              // property nickname
       dcl-s DataTypeX like(EntPropI.DataType);                              // data type
       dcl-s ClassX    like(EntHeadI.Class);                                 // entity class
       dcl-s CountX    packed(1);                                            // count work field

       if %parms >= 3;                                                       // if data type passed
         DataTypeX = UpperCase(DataType);                                    // capture in work fld
       endif;                                                                // if data type passed

       PropertyX = UpperCase(Property);                                      // upper case property

       if PropertyX = 'CLASS'      and (DataTypeX = ' ' or DataTypeX = 'NOTE')
       or PropertyX = 'PARENTID'   and (DataTypeX = ' ' or DataTypeX = 'LINK')
       or PropertyX = 'STATUS'     and (DataTypeX = ' ' or DataTypeX = 'FLAG')
       or PropertyX = 'LEGACYN'    and (DataTypeX = ' ' or DataTypeX = 'NUMB')
       or PropertyX = 'LEGACYA'    and (DataTypeX = ' ' or DataTypeX = 'NOTE')
       or PropertyX = 'DESCRIPTOR' and (DataTypeX = ' ' or DataTypeX = 'NOTE'); // if metadata
         return *on;                                                            // then it's valid
       endif;                                                                   // if metadata

       ClassX = UpperCase(Class);                                            // upper case class

       exec sql select ifnull(count(*), 0) into :CountX from entprop
         where class = :ClassX and property = :PropertyX
           and (:DataTypeX = ' ' or datatype = :DataTypeX);                  // search for property

       return (CountX > 0);                                                  // true if found

       end-proc;                                                             // valid class property


      **********************************************************************************************
      *  TIME TRAVEL SUPPORT
      **********************************************************************************************

       // NOTE:  See the Inuendo Technical Reference for important information
       // regarding the proper use of a Session Moment.

       dcl-proc setSessionMoment export;                                     // set session moment

       dcl-pi setSessionMoment ind;                                          // set session moment
         SessionDate char(7);                                                // session date CYYMMDD
         SessionTime char(6);                                                // session time HHMMSS
         SessionMicr int(10);                                                // microseconds
       end-pi;                                                               // set session moment

       RtvPtrSpc(SMUsrSpc : SMPtr : ErrorCode);                              // retv ptr to usrspc

       if SMPtr = *null;                                                     // if no user space

         CrtUsrSpc(SMUsrSpc : 'MOMENT' : %len(SessionMoment) : ' ' :
                    '*EXCLUDE' : 'Session Moment' : '*NO' : ErrorCode);      // create user space

         RtvPtrSpc(SMUsrSpc : SMPtr : ErrorCode);                            // retv ptr to usrspc

       endif;                                                                // if no user space

       monitor;                                                              // catch all errors

         if SMPtr <> *null;                                                  // if usrspc exists
           SessionMoment = %date(SessionDate:*cymd0)
                         + %time(SessionTime:*hms0)
                         + %mseconds(SessionMicr);                           // calc session moment
           return *on;                                                       // return true
         else;                                                               // no usrspc exists
           return *off;                                                      // return false
         endif;                                                              // if usrspc exists

       on-error *all;                                                        // on any error

         return *off;                                                        // return false

       endmon;                                                               // catch all errors

       end-proc;                                                             // set session moment

      **********************************************************************************************

       dcl-proc getSessionMoment export;                                     // get session moment

       dcl-pi getSessionMoment like(EntHeadI.CreateTime) end-pi;             // get session moment

       dcl-s SessionMomentX like(SessionMoment);                             // moment work field

       // if a session moment user space is active, return the value contained
       //   within, otherwise just return the current sytem time stamp

       if SessionMomentActive();                                             // if sess moment actv
         return SessionMoment;                                               // return that moment
       else;                                                                 // no sess moment actv
         exec sql set :SessionMomentX = CURRENT_TIMESTAMP;                   // get system tstamp
         return SessionMomentX;                                              // return that value
       endif;                                                                // if sess moment actv

       end-proc;                                                             // get session moment

      **********************************************************************************************

       dcl-proc clrSessionMoment export;                                     // clear session moment

       dcl-pi clrSessionMoment ind end-pi;                                   // clear session moment

       DltUsrSpc(SMUsrSpc : ErrorCode);                                      // delete user space
       RtvPtrSpc(SMUsrSpc : SMPtr : ErrorCode);                              // retv ptr to usrspc

       return (SMPtr = *null);                                               // true if deleted

       end-proc;                                                             // clear session moment

      **********************************************************************************************

       dcl-proc SessionMomentActive export;                                  // session moment actv

       dcl-pi SessionMomentActive ind end-pi;                                // session moment actv

       dcl-s SessionMomentX like(SessionMoment);                             // moment work field

       // If the pointer is null, then it was either never set by
       //   SetSessionMoment or it was destroyed by either a RCLACTGRP command
       //   or by the deletion of the user space object from library QTEMP.
       //   See if the associated user space exists and either relink to it
       //   or just initalize the pointer and clear the session moment.
       //   Destroy the user space if it contains invalid timestamp data.

       monitor;                                                              // catch all errors

         if SMPtr = *null;                                                   // if pointer is null

           reset ErrorCode;                                                  // reset error code
           RtvPtrSpc(SMUsrSpc : SMPtr : ErrorCode);                          // retv ptr to usrspc

           if SMPtr <> *null and ErrorCode.MsgCod = *blanks;                 // if ptr to usrspc
             SessionMomentX = SessionMoment + %mseconds(1);                  // ensure valid stamp
           else;                                                             // no ptr to usrspc
             SMPtr = *null;                                                  // force a reset
           endif;                                                            // if ptr to usrspc

         endif;                                                              // if pointer is null

       on-error *all;                                                        // on any error

         DltUsrSpc(SMUsrSpc : ErrorCode);                                    // delete if exists
         SMPtr = *null;                                                      // force pointer reset

       endmon;                                                               // catch all errors

       // if pointer still null, reset pointer and initialize moment

       if SMPtr = *null;                                                     // if ptr still null
         SMPtr = %alloc(%len(SessionMoment));                                // alloc for moment
         SessionMoment = *loval;                                             // initialize moment
       endif;                                                                // if ptr still null

       // return a true if there is a session moment;

       return (SessionMoment <> *loval);                                     // true if sess moment

       end-proc;                                                             // session moment actv

      **********************************************************************************************
