      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY OUTPUT FUNCTIONS                            *
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
      /copy qcpysrc,stdpgmsts                                                // program status DS
      /copy qcpysrc,stdentinp                                                // protytpes, work stg
      /copy qcpysrc,stdentout                                                // protytpes, work stg
      /copy qcpysrc,stdcrypfnc                                               // encryption functions
      /copy qcpysrc,whodunnit                                                // who done it funcs

       dcl-c InvClass 'Invalid class for new entity';                        // invalid class err
       dcl-c InvProp  'Invalid property for class';                          // invalid property err
       dcl-c AutProp  'User not authorized to assign property value';        // prop authority err
       dcl-c IllMeta  'Attemped to update metadata illegally';               // illegal metadata err
       dcl-c InvLink  'Invalid partner class for link property value';       // invalid link class
       dcl-c InvPrnt  'Invalid partner class for new entity parent';         // invalid parent class
       dcl-c EntExst  'Entity with same metadata already existsent';         // invalid parent class

      **********************************************************************************************
      *  INSTANTIATION OF A NEW ENTITY
      **********************************************************************************************

       dcl-proc newEntity export;                                            // create new entity

       dcl-pi newEntity like(EntHeadO.EntityID);                             // create new entity
         ParentID   like(EntHeadO.ParentID)   const;                         // parent entity
         Class      like(EntHeadO.Class)      const;                         // entity class
         LegacyN    like(EntHeadO.LegacyN)    const;                         // legacy ID numeric
         LegacyA    like(EntHeadO.LegacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pi;                                                               // create new entity

       dcl-ds EntHeadX likeds(EntHeadO) inz;                                 // entity header record

       dcl-s ClassX   like(EntHeadO.Class);                                  // entity class
       dcl-s LegacyAx like(EntHeadO.LegacyA);                                // legacy ID alpha
       dcl-s ErrorIDx like(EntHeadO.EntityID);                               // error entity ID

       // No output operations allowed if a session moment is being used.

       if SessionMomentActive();                                             // if session moment
         return 0;                                                           // no entity created
       endif;                                                                // if session moment

       // If legacy identifiers are passed, and this combination already
       //   exists, then return the existing entity ID.  Otherwise create
       //   an entirely new entity.

       ClassX    = %trimr(UpperCase(Class));                                 // entity class
       LegacyAx  = %trimr(LegacyA);                                          // legacy ID alpha

       if LegacyN > 0 or LegacyAx > *blanks;                                 // if legacy ID's

         EntHeadX.EntityID = getEntityID(ParentID:ClassX:LegacyN:LegacyAx);  // see if exists

         if EntHeadX.EntityID > 0;                                           // if already exists
           return EntHeadX.EntityID;                                         // imply its ID
         endif;                                                              // if already exists

       endif;                                                                // if legacy ID's

       // Class must be defined in ENTPROP for a new entity to be built.

       if not ValidClass(ClassX);                                            // if class not valid
         ErrorIDx = newEntityA(ParentID : 'CLASSERROR' : Class : InvClass);  // create error entity
         putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());                // function in error
         return 0;                                                           // no entity ID
       elseif not ValidParentClass(ParentID : Class);                        // or inv parent class
         ErrorIDx = newEntityA(ParentID : 'CLASSERROR' : Class : InvPrnt);   // create error entity
         putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());                // function in error
         return 0;                                                           // no entity ID
       endif;                                                                // if class not valid

       // Build new header.

       EntHeadX.ParentID   = ParentID;                                       // parent entity ID
       EntHeadX.Class      = ClassX;                                         // entity class
       EntHeadX.LegacyN    = LegacyN;                                        // legacy ID numeric
       EntHeadX.LegacyA    = LegacyAx;                                       // legacy ID alpha
       EntHeadX.CreateUser = pgmsts.curusr;                                  // creation user
       EntHeadX.CreateJnum = pgmsts.jobnum;                                  // creation job number
       EntHeadX.CreateJnam = pgmsts.jobnam;                                  // creation job name
       EntHeadX.CreateProg = guiltypgm(pgmsts.pgmnam);                       // creation program

       exec sql set :EntHeadX.CreateTime = CURRENT_TIMESTAMP;                // creation time stamp

       if %parms >= 5;                                                       // if descriptor passed
         EntHeadX.Descriptor = %trimr(Descriptor);                           // use it in header
       endif;                                                                // if descriptor passed

       exec sql insert into enthead overriding user value values(:EntHeadX); // new entity header

       EntHeadX.EntityID = getEntityID(ParentID:ClassX:LegacyN:LegacyA);     // get new entity ID

       if EntHeadX.EntityID > 0;                                             // if insert successful
         putLink(EntHeadX.EntityID:'PARENTID'  :EntHeadX.ParentID);          // echo in subtable
         putNote(EntHeadX.EntityID:'CLASS'     :EntHeadX.Class);             // echo in subtable
         putNote(EntHeadX.EntityID:'DESCRIPTOR':EntHeadX.Descriptor);        // echo in subtable
         putNumb(EntHeadX.EntityID:'LEGACYN'   :EntHeadX.LegacyN);           // echo in subtable
         putNote(EntHeadX.EntityID:'LEGACYA'   :EntHeadX.LegacyA);           // echo in subtable
         putFlag(EntHeadX.EntityID:'STATUS'    :EntHeadX.Status);            // echo in subtable
       endif;                                                                // if insert successful

       return EntHeadX.EntityID;                                             // imply new entity ID

       end-proc;                                                             // create new entity

      **********************************************************************************************

       dcl-proc newEntityN export;                                           // create new entity

       dcl-pi newEntityN like(EntHeadO.entityID);                            // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyN    like(EntHeadO.legacyN)    const;                         // legacy ID numeric
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pi;                                                               // create new entity

       dcl-s LegacyAx like(EntHeadO.legacyA) inz;                            // legacy ID alpha

       if %parms >= 4;                                                       // if descriptor passed
         return NewEntity(ParentID:Class:LegacyN:LegacyAx:Descriptor);       // return new entity ID
       else;                                                                 // no descriptor passed
         return NewEntity(ParentID:Class:LegacyN:LegacyAx);                  // return new entity ID
       endif;                                                                // if descriptor passed

       end-proc newEntityN;                                                  // create new entity

      **********************************************************************************************

       dcl-proc newEntityA export;                                           // create new entity

       dcl-pi newEntityA like(EntHeadO.entityID);                            // create new entity
         ParentID   like(EntHeadO.parentID)   const;                         // parent entity
         Class      like(EntHeadO.class)      const;                         // entity class
         LegacyA    like(EntHeadO.legacyA)    const;                         // legacy ID alpha
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pi;                                                               // create new entity

       dcl-s LegacyNx like(EntHeadO.legacyN);                                // legacy ID numeric

       if %parms >= 4;                                                       // if descriptor passed
         return NewEntity(ParentID:Class:LegacyNx:LegacyA:Descriptor);       // return new entity ID
       else;                                                                 // no descriptor passed
         return NewEntity(ParentID:Class:LegacyNx:LegacyA);                  // return new entity ID
       endif;                                                                // if descriptor passed

       end-proc;                                                             // create new entity


      **********************************************************************************************
      *  APPENDING OF NEW VALUES IN ENTITY SUBTABLES
      **********************************************************************************************

       dcl-proc putDate export;                                              // put entity date

       dcl-pi putDate ind;                                                   // put entity date
         EntityID like(EntDateO.EntityID) const;                             // entity ID
         Property like(EntDateO.Property) const;                             // property nickname
         NewValue like(EntDateO.Value)    const;                             // new property value
       end-pi;                                                               // put entity date

       dcl-ds EntDateX likeds(EntDateO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntDateO.EntityID);                              // owner entity ID
       dcl-s PropertyX like(EntDateO.Property);                              // property nickname
       dcl-s ErrorIDx  like(EntDateO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValue <> getDate(EntityIDx:PropertyX);      // if new value needed

           if not ValidProperty(EntityIDx:PropertyX:'DATE');                 // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntDateX.Value = NewValue;                                      // new property value
             exec sql insert into EntDate values(:EntDateX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put entity date

      **********************************************************************************************

       dcl-proc putDateN export;                                             // put date numeric

       dcl-pi putDateN ind;                                                  // put date numeric
         EntityID like(EntDateO.EntityID) const;                             // entity ID
         Property like(EntDateO.Property) const;                             // property nickname
         NewValue zoned(8)  const;                                           // new property value
         DateFormat char(5) const;                                           // date format
       end-pi;                                                               // put date numeric

       dcl-s NativeDateX like(EntDateO.Value);                               // native date work
       dcl-s DateFormatX char(5);                                            // date format work

       monitor;                                                              // catch all errors

         DateFormatX = UpperCase(DateFormat);                                // uppercase format

         if NewValue = 0;                                                    // if no date value
           NativeDateX = *loval;                                             // assume lowest value
         elseif DateFormatX = '*MDY';                                        // or MDY format
           NativeDateX = %date(NewValue:*mdy);                               // convert to native
         elseif DateFormatX = '*YMD';                                        // or YMD format
           NativeDateX = %date(NewValue:*ymd);                               // convert to native
         elseif DateFormatX = '*DMY';                                        // or DMY format
           NativeDateX = %date(NewValue:*dmy);                               // convert to native
         elseif DateFormatX = '*JUL';                                        // or julian format
           NativeDateX = %date(NewValue:*jul);                               // convert to native
         elseif DateFormatX = '*ISO';                                        // or ISO format
           NativeDateX = %date(NewValue:*iso);                               // convert to native
         elseif DateFormatX = '*USA';                                        // or USA format
           NativeDateX = %date(NewValue:*usa);                               // convert to native
         elseif DateFormatX = '*EUR';                                        // or European format
           NativeDateX = %date(NewValue:*eur);                               // convert to native
         elseif DateFormatX = '*JIS';                                        // or Japanese format
           NativeDateX = %date(NewValue:*jis);                               // convert to native
         else;                                                               // or invalid format
           return *off;                                                      // false since no put
         endif;                                                              // if MDY format

         return putDate(EntityID:Property:NativeDateX);                      // normal put date func

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put date numeric

      **********************************************************************************************

       dcl-proc putDateA export;                                             // put date alpha

       dcl-pi putDateA ind;                                                  // put date alpha
         EntityID like(EntDateO.EntityID) const;                             // entity ID
         Property like(EntDateO.Property) const;                             // property nickname
         NewValue char(10)  const;                                           // new property value
         DateFormat char(5) const;                                           // date format
       end-pi;                                                               // put date alpha

       dcl-s NativeDateX like(EntDateO.Value);                               // native date work
       dcl-s DateFormatX char(5);                                            // date format work

       monitor;                                                              // catch all errors

         DateFormatX = UpperCase(DateFormat);                                // uppercase format

         if NewValue = *blanks;                                              // if no date value
           NativeDateX = *loval;                                             // assume lowest value
         elseif DateFormatX = '*MDY';                                        // or MDY format
           NativeDateX = %date(NewValue:*mdy);                               // convert to native
         elseif DateFormatX = '*YMD';                                        // or YMD format
           NativeDateX = %date(NewValue:*ymd);                               // convert to native
         elseif DateFormatX = '*DMY';                                        // or DMY format
           NativeDateX = %date(NewValue:*dmy);                               // convert to native
         elseif DateFormatX = '*JUL';                                        // or julian format
           NativeDateX = %date(NewValue:*jul);                               // convert to native
         elseif DateFormatX = '*ISO';                                        // or ISO format
           NativeDateX = %date(NewValue:*iso);                               // convert to native
         elseif DateFormatX = '*USA';                                        // or USA format
           NativeDateX = %date(NewValue:*usa);                               // convert to native
         elseif DateFormatX = '*EUR';                                        // or European format
           NativeDateX = %date(NewValue:*eur);                               // convert to native
         elseif DateFormatX = '*JIS';                                        // or Japanese format
           NativeDateX = %date(NewValue:*jis);                               // convert to native
         elseif DateFormatX = '*MDY0';                                       // or MDY format
           NativeDateX = %date(NewValue:*mdy0);                              // convert to native
         elseif DateFormatX = '*YMD0';                                       // or YMD format
           NativeDateX = %date(NewValue:*ymd0);                              // convert to native
         elseif DateFormatX = '*DMY0';                                       // or DMY format
           NativeDateX = %date(NewValue:*dmy0);                              // convert to native
         elseif DateFormatX = '*JUL0';                                       // or julian format
           NativeDateX = %date(NewValue:*jul0);                              // convert to native
         elseif DateFormatX = '*ISO0';                                       // or ISO format
           NativeDateX = %date(NewValue:*iso0);                              // convert to native
         elseif DateFormatX = '*USA0';                                       // or USA format
           NativeDateX = %date(NewValue:*usa0);                              // convert to native
         elseif DateFormatX = '*EUR0';                                       // or European format
           NativeDateX = %date(NewValue:*eur0);                              // convert to native
         elseif DateFormatX = '*JIS0';                                       // or Japanese format
           NativeDateX = %date(NewValue:*jis0);                              // convert to native
         else;                                                               // or invalid format
           return *off;                                                      // false since no put
         endif;                                                              // if MDY format

         return putDate(EntityID:Property:NativeDateX);                      // normal put date func

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put date alpha

      **********************************************************************************************

       dcl-proc putFlag export;                                              // put entity flag

       dcl-pi putFlag ind;                                                   // put entity flag
         EntityID like(EntFlagO.EntityID) const;                             // entity ID
         Property like(EntFlagO.Property) const;                             // property nickname
         NewValue like(EntFlagO.Value)    const;                             // new property value
       end-pi;                                                               // put entity flag

       dcl-ds EntFlagX likeds(EntFlagO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntFlagO.EntityID);                              // entity ID
       dcl-s PropertyX like(EntFlagO.Property);                              // property nickname
       dcl-s ErrorIDx  like(EntFlagO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValue <> getFlag(EntityIDx:PropertyX);      // if new value needed

           if not ValidProperty(EntityIDx:PropertyX:'FLAG');                 // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           elseif PropertyX = 'STATUS'
                    and not FiredByProc('NEWENTITY')
                    and not FiredByProc('PUTSTATUS');                        // or cheating metadata
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : IllMeta);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntFlagX.Value = NewValue;                                      // new property value
             exec sql insert into EntFlag values(:EntFlagX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put entity flag

      **********************************************************************************************

       dcl-proc putLink export;                                              // put entity link

       dcl-pi putLink ind;                                                   // put entity link
         EntityID like(EntLinkO.EntityID) const;                             // entity ID
         Property like(EntLinkO.Property) const;                             // property nickname
         NewValue like(EntLinkO.Value)    const;                             // new property value
       end-pi;                                                               // put entity link

       dcl-ds EntLinkX likeds(EntLinkO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntLinkO.EntityID);                              // entity ID
       dcl-s PropertyX like(EntLinkO.Property);                              // property nickname
       dcl-s ErrorIDx  like(EntLinkO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValue <> getLink(EntityIDx:PropertyX);      // if new value needed

           if not ValidProperty(EntityIDx : PropertyX : 'LINK');             // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           elseif PropertyX = 'PARENTID'
                    and not FiredByProc('NEWENTITY')
                    and not FiredByProc('PUTPARENTID');                      // or cheating metadata
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : IllMeta);   // create error entity
           elseif not ValidLinkClass(EntityIDx : PropertyX : NewValue);      // or invalid link clas
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvLink);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntLinkX.Value = NewValue;                                      // new property value
             exec sql insert into EntLink values(:EntLinkX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put entity link

      **********************************************************************************************

       dcl-proc putNote export;                                              // put entity note

       dcl-pi putNote ind;                                                   // put entity note
         EntityID like(EntNoteO.EntityID) const;                             // entity ID
         Property like(EntNoteO.Property) const;                             // property nickname
         NewValue like(EntNoteO.Value)    const;                             // new property value
       end-pi;                                                               // put entity note

       dcl-ds EntNoteX likeds(EntNoteO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntNoteO.EntityID);                              // actual entity ID
       dcl-s PropertyX like(EntNoteO.Property);                              // actual property
       dcl-s NewValueX like(EntNoteO.Value);                                 // new property value
       dcl-s ErrorIDx  like(EntNoteO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         NewValueX = %trimr(NewValue);                                       // new property value

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValue <> getNote(EntityIDx:PropertyX);      // if new value needed

           if not ValidProperty(EntityIDx:PropertyX:'NOTE');                 // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           elseif PropertyX = 'CLASS'
                    and not FiredByProc('NEWENTITY')
                    and not FiredByProc('PUTCLASS')
               or PropertyX = 'DESCRIPTOR'
                    and not FiredByProc('NEWENTITY')
                    and not FiredByProc('PUTDESCRIPTOR')
               or PropertyX = 'LEGACYA'
                    and not FiredByProc('NEWENTITY')
                    and not FiredByProc('PUTLEGACYA');                       // or cheating metadata
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : IllMeta);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntNoteX.Value = NewValue;                                      // new property value
             exec sql insert into EntNote values(:EntNoteX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put entity note

      **********************************************************************************************

       dcl-proc putNumb export;                                              // put entity number

       dcl-pi putNumb ind;                                                   // put entity number
         EntityID like(EntNumbO.EntityID) const;                             // entity ID
         Property like(EntNumbO.Property) const;                             // property nickname
         NewValue like(EntNumbO.Value)    const;                             // new property value
       end-pi;                                                               // put entity number

       dcl-ds EntNumbX likeds(EntNumbO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntNumbO.EntityID);                              // actual entity ID
       dcl-s PropertyX like(EntNumbO.Property);                              // actual property
       dcl-s ErrorIDx  like(EntNumbO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValue <> getNumb(EntityIDx:PropertyX);      // if new value needed

           if not ValidProperty(EntityIDx:PropertyX:'NUMB');                 // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           elseif PropertyX = 'LEGACYN'
                    and not FiredByProc('NEWENTITY')
                    and not FiredByProc('PUTLEGACYN');                       // or cheating metadata
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : IllMeta);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntNumbX.Value = NewValue;                                      // new property value
             exec sql insert into EntNumb values(:EntNumbX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put entity number

      **********************************************************************************************

       dcl-proc putNotX export;                                              // put encrypted note

       dcl-pi putNotX ind;                                                   // put encrypted note
         EntityID like(EntNotXO.EntityID) const;                             // entity ID
         Property like(EntNotXO.Property) const;                             // property nickname
         NewValue like(EntNoteO.Value)    const;                             // new property value
       end-pi;                                                               // put encrypted note

       dcl-ds EntNotXX likeds(EntNotXO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntNotxO.EntityID);                              // actual entity ID
       dcl-s PropertyX like(EntNotxO.Property);                              // actual property
       dcl-s NewValueX like(EntNoteO.Value);                                 // new property value
       dcl-s ErrorIDx  like(EntNotxO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         NewValueX = %trimr(NewValue);                                       // new property value

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValueX <> getNotX(EntityIDx:PropertyX);     // if new value needed

           if not ValidProperty(EntityIDx:PropertyX:'NOTX');                 // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntNotxX.Value = Encrypt(NewValueX);                            // encrypt value
             exec sql insert into EntNotx values(:EntNotxX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put encrypted note

      **********************************************************************************************

       dcl-proc putNumX export;                                              // put encrypted number

       dcl-pi putNumX ind;                                                   // put encrypted number
         EntityID like(EntNumxO.EntityID) const;                             // entity ID
         Property like(EntNumxO.Property) const;                             // property nickname
         NewValue like(EntNumbO.Value)    const;                             // new property value
       end-pi;                                                               // put encrypted number

       dcl-ds *n;                                                            // type conversion
         ChrNumbX char(23);                                                  // character number
         DecNumbX zoned(23:5) overlay(ChrNumbX);                             // number value
       end-ds;                                                               // type conversion

       dcl-ds EntNumxX likeds(EntNumxO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntNumxO.EntityID);                              // actual entity ID
       dcl-s PropertyX like(EntNumxO.Property);                              // actual property
       dcl-s ErrorIDx  like(EntNumxO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         DecNumbX = NewValue;                                                // decrypted number

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValue <> getNumX(EntityIDx:PropertyX);      // if new value needed

           if not ValidProperty(EntityIDx:PropertyX:'NUMX');                 // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntNumxX.Value = Encrypt(ChrNumbX);                             // encrypt value
             exec sql insert into EntNumx values(:EntNumxX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put encrypted number

      **********************************************************************************************

       dcl-proc putDatX export;                                              // put encrypted date

       dcl-pi putDatX ind;                                                   // put encrypted date
         EntityID like(EntDatXO.EntityID) const;                             // entity ID
         Property like(EntDatXO.Property) const;                             // property nickname
         NewValue like(EntDateO.Value)    const;                             // new property value
       end-pi;                                                               // put encrypted date

       dcl-ds EntDatXX likeds(EntDatXO) based(ePtr);                         // sub table record

       dcl-s EntityIDx like(EntDatxO.EntityID);                              // actual entity ID
       dcl-s PropertyX like(EntDatxO.Property);                              // actual property
       dcl-s NewValueX like(EntDatxO.Value);                                 // new property value
       dcl-s ErrorIDx  like(EntDatxO.EntityID);                              // error entity ID

       monitor;                                                              // catch all errors

         if SessionMomentActive();                                           // if session moment
           return *off;                                                      // return a false
         endif;                                                              // if session moment

         NewValueX = %char(NewValue:*iso);                                   // new property value

         if %scan(Delimiter:Property) > 0;                                   // if delimiter found
           EntityIDx = PropertyOwner(EntityID:Property);                     // actual entity ID
           PropertyX = %trimr(FinalSegment(Property));                       // actual property
         else;                                                               // no delimiter found
           EntityIDx = EntityID;                                             // actual entity ID
           PropertyX = %trimr(UpperCase(Property));                          // actual property
         endif;                                                              // if delimiter found

         if EntityIDx > 0 and NewValue <> getDatX(EntityIDx:PropertyX);      // if new value needed

           if not ValidProperty(EntityIDx:PropertyX:'DATX');                 // if class/prop error
             ErrorIDx  = newEntityN(EntityID : 'PROPERROR' : 0 : InvProp);   // create error entity
           else;                                                             // okay to put value
             eptr = FillPropValue(EntityIDx:PropertyX);                      // fill prop value recd
             EntDatxX.Value = Encrypt(NewValueX);                            // encrypt value
             exec sql insert into EntDatx values(:EntDatxX);                 // put subtable record
           endif;                                                            // if class/prop error

           if ErrorIDx > 0;                                                  // if error entity
             putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());            // function in error
             putNote(ErrorIDx : 'PROPPATH' : Property);                      // orig property path
             putLink(ErrorIDx : 'OWNER'    : EntityIDx);                     // owner entity ID
             return *off;                                                    // false on error
           else;                                                             // no error entity
             return (sqlcod = 0);                                            // true if successful
           endif;                                                            // if error entity

         else;                                                               // no new value needed

           return *off;                                                      // false on no put

         endif;                                                              // if new value needed

       on-error *all;                                                        // on any error

         return *off;                                                        // false on error

       endmon;                                                               // catch all errors

       end-proc;                                                             // put encrypted date


      **********************************************************************************************
      *  UPDATES TO HEADER METADATA (WITH AUTOMATIC APPENDS TO COVERT SUBTABLE ENTRIES)
      **********************************************************************************************

       dcl-proc putParentID export;                                          // put entity parent ID

       dcl-pi putParentID ind;                                               // put entity parent ID
         EntityID    like(EntHeadO.EntityID) const;                          // entity ID
         NewParentID like(EntHeadO.ParentID) const;                          // new parent ID
       end-pi;                                                               // put entity parent ID

       dcl-s ClassX   like(EntHeadO.Class);                                  // entity class
       dcl-s ErrorIDx like(EntHeadO.EntityID);                               // error entity ID

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       ClassX = getClass(EntityID);                                          // class of entity

       if not ValidParentClass(NewParentID : ClassX);                        // if inv parent class
         ErrorIDx = newEntityA(EntityID : 'CLASSERROR' : ClassX : InvPrnt);  // create error entity
         putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());                // function in error
         return *off;                                                        // return a false
       endif;                                                                // if inv parent class

       exec sql update enthead set parentID = :NewParentID
         where entityid = :EntityID;                                         // try to update header

       if sqlcod = 0 and FiredByProc('ROLLBACKJOB');                         // if rolling back
         return *on;                                                         // dont put to subtable
       elseif sqlcod = 0;                                                    // or header updated
         return putLink(EntityID:'PARENTID':NewParentID);                    // put to subtables
       else;                                                                 // header not updated
         return *off;                                                        // return a false
       endif;                                                                // if rolling back

       end-proc;                                                             // put entity parent ID

      **********************************************************************************************

       dcl-proc putClass export;                                             // put entity class

       dcl-pi putClass ind;                                                  // put entity class
         EntityID like(EntHeadO.EntityID) const;                             // entity ID
         NewClass like(EntHeadO.Class)    const;                             // new class
       end-pi;                                                               // put entity class

       dcl-s NewClassX like(EntHeadO.Class);                                 // new class

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       NewClassX = %trimr(NewClass);                                         // new class

       if not ValidClass(NewClassX);                                         // if class not valid
         return *off;                                                        // return a false
       endif;                                                                // if class not valid

       exec sql update enthead set class = :NewClassX
         where entityid = :EntityID;                                         // try to update header

       if sqlcod = 0 and FiredByProc('ROLLBACKJOB');                         // if rolling back
         return *on;                                                         // dont put to subtable
       elseif sqlcod = 0;                                                    // or header updated
         return putNote(EntityID:'CLASS':NewClassX);                         // put to subtables
       else;                                                                 // header not updated
         return *off;                                                        // return a false
       endif;                                                                // if rolling back

       end-proc;                                                             // put entity class

      **********************************************************************************************

       dcl-proc putDescriptor export;                                        // put entity descrip

       dcl-pi putDescriptor ind;                                             // put entity descrip
         EntityID like(EntHeadO.EntityID) const;                             // entity ID
         NewDescriptor like(EntHeadO.Descriptor) const;                      // new descriptor
       end-pi;                                                               // put entity descrip

       dcl-s NewDescriptorX like(EntHeadO.Descriptor);                       // new descriptor

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       NewDescriptorX = %trimr(NewDescriptor);                               // trim trailing blanks

       exec sql update enthead set descriptor = :NewDescriptorX
         where entityid = :EntityID;                                         // try to update header

       if sqlcod = 0 and FiredByProc('ROLLBACKJOB');                         // if rolling back
         return *on;                                                         // dont put to subtable
       elseif sqlcod = 0;                                                    // or header updated
         return putNote(EntityID:'DESCRIPTOR':NewDescriptorX);               // put to subtables
       else;                                                                 // header not updated
         return *off;                                                        // return a false
       endif;                                                                // if rolling back

       end-proc;                                                             // put entity descrip

      **********************************************************************************************

       dcl-proc putLegacyN export;                                           // put legacy ID numer

       dcl-pi putLegacyN ind;                                                // put legacy ID numer
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyN like(EntHeadO.LegacyN)  const;                           // new legacy ID numer
       end-pi;                                                               // put legacy ID numer

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       exec sql update enthead set legacyn = :NewLegacyN
         where entityid = :EntityID;                                         // try to update header

       if sqlcod = 0 and FiredByProc('ROLLBACKJOB');                         // if rolling back
         return *on;                                                         // dont put to subtable
       elseif sqlcod = 0;                                                    // or header updated
         return putNumb(EntityID:'LEGACYN':NewLegacyN);                      // put to subtables
       else;                                                                 // header not updated
         return *off;                                                        // return a false
       endif;                                                                // if rolling back

       end-proc;                                                             // put legacy ID numer

      **********************************************************************************************

       dcl-proc putLegacyA export;                                           // put legacy ID alpha

       dcl-pi putLegacyA ind;                                                // put legacy ID alpha
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyA like(EntHeadO.LegacyA)  const;                           // new legacy ID alpha
       end-pi;                                                               // put legacy ID alpha

       dcl-s NewLegacyAx like(EntHeadO.Descriptor);                          // new legacy ID alphs

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       NewLegacyAx = %trimr(NewLegacyA);                                     // trim trailing blanks

       exec sql update enthead set legacya = :NewLegacyAx
         where entityid = :EntityID;                                         // try to update header

       if sqlcod = 0 and FiredByProc('ROLLBACKJOB');                         // if rolling back
         return *on;                                                         // dont put to subtable
       elseif sqlcod = 0;                                                    // or header updated
         return putNote(EntityID:'LEGACYA':NewLegacyAx);                     // put to subtables
       else;                                                                 // header not updated
         return *off;                                                        // return a false
       endif;                                                                // if rolling back

       end-proc;                                                             // put legacy ID alpha

      **********************************************************************************************

       dcl-proc putStatus export;                                            // put entity status

       dcl-pi putStatus ind;                                                 // put entity status
         EntityID  like(EntHeadO.EntityID) const;                            // entity ID
         NewStatus like(EntHeadO.Status) const;                              // entity status
       end-pi;                                                               // put entity status

       if SessionMomentActive();                                             // if session moment
         return *off;                                                        // return a false
       endif;                                                                // if session moment

       exec sql update enthead set status = :NewStatus
         where entityid = :EntityID;                                         // try to update header

       if sqlcod = 0 and FiredByProc('ROLLBACKJOB');                         // if rolling back
         return *on;                                                         // dont put to subtable
       elseif sqlcod = 0;                                                    // or header updated
         return putFlag(EntityID:'STATUS':NewStatus);                        // put to subtables
       else;                                                                 // header not updated
         return *off;                                                        // return a false
       endif;                                                                // if rolling back

       end-proc;                                                             // put entity status


      **********************************************************************************************
      *  ENTITY DUPLICATION FUNCTIONS (INCLUDING THOSE TO SUPPORT SQL FUNCTION OVERLOADING)
      **********************************************************************************************

       dcl-proc dupEntity export;                                            // duplicate entity

       dcl-pi dupEntity like(EntHeadO.EntityID);                             // duplicate entity
         EntityID   like(EntHeadO.EntityID)   const;                         // entity ID
         NewLegacyN like(EntHeadO.LegacyN)    const;                         // new legacy numer ID
         NewLegacyA like(EntHeadO.LegacyA)    const;                         // new legacy alpha ID
         Descriptor like(EntHeadO.Descriptor) const options(*nopass);        // free form note text
       end-pi;                                                               // duplicate entity

       dcl-s newEntityID like(EntHeadO.EntityID);                            // new entity ID
       dcl-s ClassX      like(EntHeadO.Class);                               // entity class
       dcl-s ParentIDx   like(EntHeadO.ParentID);                            // parent entity ID
       dcl-s DescriptorX like(EntHeadO.Descriptor);                          // general descriptor
       dcl-s PropertyX   like(EntPropO.Property);                            // property nickname
       dcl-s DataTypeX   like(EntPropO.DataType);                            // property data type

       if SessionMomentActive();                                             // if session moment
         return 0;                                                           // no entity created
       endif;                                                                // if session moment

       ClassX    = getClass(EntityID);                                       // entity class
       ParentIDx = getParentID(EntityID);                                    // parent entity ID

       if getEntityID(ParentIDx:ClassX:newLegacyN:newLegacyA) > 0;           // if already exists
         return 0;                                                           // cannot create it
       endif;                                                                // if already exists

       if %parms >= 4;                                                       // if descriptor passed
         DescriptorX = Descriptor;                                           // use it as metadata
       endif;                                                                // if descriptor passed

       newEntityID =
         newEntity(ParentIDx:ClassX:newLegacyN:newLegacyA:DescriptorX);      // new entity

       exec sql declare dupEntityC1 cursor for
         select property, datatype from entprop where class = :ClassX;       // data types for class

       exec sql open dupEntityC1;                                            // open cursor
       exec sql fetch from dupEntityC1 into :PropertyX, :DataTypeX;          // fetch first property

       dow sqlcod = 0;                                                       // while more types

         if DataTypeX = 'FLAG';                                              // if flag type
           putFlag(newEntityID:PropertyX:getFlag(EntityID:PropertyX));       // put current value
         elseif DataTypeX = 'NOTE';                                          // or note type
           putNote(newEntityID:PropertyX:getNote(EntityID:PropertyX));       // put current value
         elseif DataTypeX = 'DATE';                                          // or date type
           putDate(newEntityID:PropertyX:getDate(EntityID:PropertyX));       // put current value
         elseif DataTypeX = 'NUMB';                                          // or numb(er) type
           putNumb(newEntityID:PropertyX:getNumb(EntityID:PropertyX));       // put current value
         elseif DataTypeX = 'LINK';                                          // or link type
           putLink(newEntityID:PropertyX:getLink(EntityID:PropertyX));       // put current value
         elseif DataTypeX = 'NOTX';                                          // or encrypted note
           putNotx(newEntityID:PropertyX:getNotx(EntityID:PropertyX));       // put current value
         elseif DataTypeX = 'NUMX';                                          // or encrypted number
           putNumx(newEntityID:PropertyX:getNumx(EntityID:PropertyX));       // put current value
         endif;                                                              // if flag type

         exec sql fetch from dupEntityC1 into :PropertyX, :DataTypeX;        // fetch next property

       enddo;                                                                // while more types

       exec sql close dupEntityC1;                                           // close cursor

       return newEntityID;                                                   // new entity ID

       end-proc;                                                             // duplicate entity

      **********************************************************************************************

       dcl-proc dupEntityND export;                                          // duplicate entity

       dcl-pi dupEntityND like(EntHeadO.EntityID);                           // duplicate entity
         EntityID   like(EntHeadO.EntityID)   const;                         // entity ID
         NewLegacyN like(EntHeadO.LegacyN)    const;                         // new legacy numer ID
         Descriptor like(EntHeadO.Descriptor) const;                         // free form note text
       end-pi;                                                               // duplicate entity

       dcl-s NewLegacyAx like(EntHeadO.LegacyA);                             // new legacy alpha ID

       monitor;                                                              // catch all errors
         return dupEntity(EntityID:NewLegacyN:NewLegacyAx:Descriptor);       // new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // no new entity ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // duplicate entity

      **********************************************************************************************

       dcl-proc dupEntityN export;                                           // duplicate entity

       dcl-pi dupEntityN like(EntHeadO.EntityID);                            // duplicate entity
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyN like(EntHeadO.LegacyN)  const;                           // new legacy numer ID
       end-pi;                                                               // duplicate entity

       dcl-s NewLegacyAx like(EntHeadO.LegacyA);                             // new legacy alpha ID

       monitor;                                                              // catch all errors
         return dupEntity(EntityID:NewLegacyN:NewLegacyAx);                  // new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // no new entity ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // duplicate entity

      **********************************************************************************************

       dcl-proc dupEntityAD export;                                          // duplicate entity

       dcl-pi dupEntityAD like(EntHeadO.EntityID);                           // duplicate entity
         EntityID   like(EntHeadO.EntityID)   const;                         // entity ID
         NewLegacyA like(EntHeadO.LegacyA)    const;                         // new legacy alpha ID
         Descriptor like(EntHeadO.Descriptor) const;                         // free form note text
       end-pi;                                                               // duplicate entity

       dcl-s NewLegacyNx like(EntHeadO.LegacyN);                             // new legacy numer ID

       monitor;                                                              // catch all errors
         return dupEntity(EntityID:NewLegacyNx:NewLegacyA:Descriptor);       // new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // no new entity ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // duplicate entity

      **********************************************************************************************

       dcl-proc dupEntityA export;                                           // duplicate entity

       dcl-pi dupEntityA like(EntHeadO.EntityID);                            // duplicate entity
         EntityID   like(EntHeadO.EntityID) const;                           // entity ID
         NewLegacyA like(EntHeadO.LegacyA)  const;                           // new legacy alpha ID
       end-pi;                                                               // duplicate entity

       dcl-s NewLegacyNx like(EntHeadO.LegacyN);                             // new legacy numer ID

       monitor;                                                              // catch all errors
         return dupEntity(EntityID:NewLegacyNx:NewLegacyA);                  // new entity ID
       on-error *all;                                                        // on any error
         return 0;                                                           // no new entity ID
       endmon;                                                               // catch all errors

       end-proc;                                                             // duplicate entity

      **********************************************************************************************

       dcl-proc copyEntity export;                                           // copy entity

       dcl-pi copyEntity like(EntHeadO.EntityID);                            // copy entity
         EntityID like(EntHeadO.EntityID) const;                             // entity ID to copy
         ParentID like(EntHeadO.EntityID) const;                             // new parent ID
       end-pi;                                                               // copy entity

       dcl-s ClassX       like(EntHeadO.Class);                              // entity class
       dcl-s LegacyAx     like(EntHeadO.LegacyA);                            // legacy ID alpha
       dcl-s LegacyNx     like(EntHeadO.LegacyN);                            // legacy ID numeric
       dcl-s DescriptorX  like(EntHeadO.Descriptor);                         // general descriptor
       dcl-s ErrorIDx     like(EntHeadO.EntityID);                           // error entity ID
       dcl-s ParentIDx    like(EntHeadO.EntityID);                           // parent entity ID
       dcl-s NewEntityIDx like(EntHeadO.EntityID);                           // new entity ID
       dcl-s PropertyX    like(EntPropO.Property);                           // property name
       dcl-s DataTypeX    like(EntPropO.DataType);                           // data type

       if SessionMomentActive();                                             // if session moment
         return 0;                                                           // no entity created
       endif;                                                                // if session moment

       ClassX      = getClass(EntityID);                                     // entity class
       LegacyAx    = getLegacyA(EntityID);                                   // legacy ID alpha
       LegacyNx    = getLegacyN(EntityID);                                   // legacy ID numeric
       DescriptorX = getDescriptor(EntityID);                                // general descriptor

       if not ValidParentClass(ParentID : ClassX);                           // if inv parent class
         ErrorIDx = newEntityA(ParentID : 'CLASSERROR' : ClassX : InvPrnt);  // create error entity
       elseif getEntityID(ParentIDx : ClassX : LegacyNx : LegacyAx) > 0;     // or already exists
         ErrorIDx = newEntityA(EntityID : 'CLASSERROR' : ClassX : EntExst);  // create error entity
       endif;                                                                // if already exists

       if ErrorIDx > 0;                                                      // if error entity
         putNote(ErrorIDx : 'FUNCTION' : GuiltyOutputProc());                // function in error
         return 0;                                                           // return false
       endif;                                                                // if error entity

       newEntityIDx =
         newEntity(ParentID : ClassX : LegacyNx : LegacyAx : DescriptorX);   // new entity

       if newEntityIDx > 0;                                                  // if new entity ID

         exec sql declare copyEntityC1 cursor for
           select property, datatype from entprop where class = :ClassX;     // data types for class

         exec sql open copyEntityC1;                                         // open cursor
         exec sql fetch from copyEntityC1 into :PropertyX, :DataTypeX;       // fetch first property

         dow sqlcod = 0;                                                     // while more types

           if DataTypeX = 'FLAG';                                            // if flag type
             putFlag(newEntityIDx:PropertyX:getFlag(EntityID:PropertyX));    // put current value
           elseif DataTypeX = 'NOTE';                                        // or note type
             putNote(newEntityIDx:PropertyX:getNote(EntityID:PropertyX));    // put current value
           elseif DataTypeX = 'DATE';                                        // or date type
             putDate(newEntityIDx:PropertyX:getDate(EntityID:PropertyX));    // put current value
           elseif DataTypeX = 'NUMB';                                        // or numb(er) type
             putNumb(newEntityIDx:PropertyX:getNumb(EntityID:PropertyX));    // put current value
           elseif DataTypeX = 'LINK';                                        // or link type
             putLink(newEntityIDx:PropertyX:getLink(EntityID:PropertyX));    // put current value
           elseif DataTypeX = 'NOTX';                                        // or encrypted note
             putNotx(newEntityIDx:PropertyX:getNotx(EntityID:PropertyX));    // put current value
           elseif DataTypeX = 'NUMX';                                        // or encrypted number
             putNumx(newEntityIDx:PropertyX:getNumx(EntityID:PropertyX));    // put current value
           endif;                                                            // if flag type

           exec sql fetch from copyEntityC1 into :PropertyX, :DataTypeX;     // fetch next property

         enddo;                                                              // while more types

         exec sql close copyEntityC1;                                        // close cursor

       endif;                                                                // if new entity ID

       return newEntityIDx;                                                  // new entity ID

       end-proc;                                                             // copy entity

      **********************************************************************************************
      *  INTERNAL SUPPORT FUNCTIONS (NOT EXPORTED)
      **********************************************************************************************

       // Checks to see if a new entity being created has a parent whose class
       //   meets the PartnerClass requirement (if any) in ENTPROP.

       dcl-proc ValidParentClass;                                            // valid parent class

       dcl-pi ValidParentClass ind;                                          // valid parent class
         ParentID like(EntHeadO.ParentID) const;                             // parent entity
         NewClass like(EntHeadO.Class)    const;                             // new entity class
       end-pi;                                                               // valid parent class

       dcl-s PartnerClassX like(EntPropO.PartClass);                         // req'd partner class

       exec sql
         select ifnull(PartClass, ' ') into :PartnerClassX
           from entprop
             where Class = :NewClass and Property = ' ';                     // req'd partner class

       return (PartnerClassX = *blanks or
                 getClass(ParentID) = PartnerClassX);                        // true if none/match

       end-proc;                                                             // valid parent class

      **********************************************************************************************

       // Checks to see if a new link property value being assigned meets
       //   the PartnerClass requirement (if any) in ENTPROP.

       dcl-proc ValidLinkClass;                                              // valid link class

       dcl-pi ValidLinkClass ind;                                            // valid link class
         EntityID like(EntLinkO.EntityID) const;                             // entity ID
         Property like(EntLinkO.Property) const;                             // property nickname
         NewLink  like(EntLinkO.EntityID) const;                             // new link value
       end-pi;                                                               // valid link class

       dcl-s ClassX        like(EntHeadO.Class);                             // entity class
       dcl-s PartnerClassX like(EntPropO.PartClass);                         // req'd partner class

       ClassX = getClass(EntityID);                                          // entity class

       exec sql
         select ifnull(PartClass, ' ') into :PartnerClassX
           from entprop
             where Class = :ClassX and Property = :Property;                 // req'd partner class

       return (PartnerClassX = *blanks or
                 getClass(NewLink) = PartnerClassX);                         // true if none/match

       end-proc;                                                             // valid link class

      **********************************************************************************************

       // Fills the common portion of a property value record.

       dcl-proc FillPropValue;                                               // fill prop value recd

       dcl-pi FillPropValue pointer;                                         // fill prop value recd
         EntityID like(EntNoteO.EntityID) const;                             // entity ID
         Property like(EntNoteO.Property) const;                             // property nickname
       end-pi;                                                               // fill prop value recd

       dcl-ds PropValueX extname('ENTNOTE') inz qualified static end-ds;     // property value recd

       clear PropValueX;                                                     // clear all fields

       PropValueX.EntityID   = EntityID;                                     // entity ID
       PropValueX.Property   = Property;                                     // property nickname
       PropValueX.ChangeJnam = pgmsts.jobnam;                                // change job name
       PropValueX.ChangeUser = pgmsts.curusr;                                // change user stamp
       PropValueX.ChangeJnum = pgmsts.jobnum;                                // change job number
       PropValueX.ChangeProg = GuiltyPgm(pgmsts.pgmnam);                     // change prog stamp

       exec sql set :PropValueX.ChangeTime = CURRENT_TIMESTAMP;              // change time stamp

       return %addr(PropValueX);                                             // address of recd base

       end-proc;                                                             // fill prop value recd

      **********************************************************************************************

       // Generates a time-based legacy numeric value for entities without legacy identifiers.

       dcl-proc LegacyNumValue export;                                       // legacy numeric value

       dcl-pi LegacyNumValue like(EntHeadO.LegacyN) end-pi;                  // legacy numeric value

       dcl-s TimeIndex timestamp(3);                                         // time stamp index

       TimeIndex = %timestamp();                                             // current time stamp

       return %dec(TimeIndex);                                               // expressed as big int

       end-proc;                                                             // legacy numeric value

