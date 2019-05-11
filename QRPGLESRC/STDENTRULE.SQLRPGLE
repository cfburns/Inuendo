      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY BUSINESS RULES (PROCEDURES)                 *
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

       dcl-f stdentrule workstn sfile(schents1:sflrr1) indds(Ind) usropn;    // pop-up windows

       dcl-ds Ind qualified;                                                 // dspf indicators
         All       char(99);                                                 // all indicators
         Cancel    ind overlay(All:12);                                      // f12 to cancel
         SFLDsp    ind overlay(All:31);                                      // sfl display
         SFLOpt    ind overlay(All:36);                                      // sfl enable option
         NumSearch ind overlay(All:37);                                      // numeric search
       end-ds;                                                               // dspf indicators

       dcl-ds SnapShotRS occurs(2048) qualified;                             // snapshot result set
         Property   like(EntPropR.Descriptor);                               // property name
         Descriptor like(EntPropR.Descriptor);                               // property descriptor
         Value      like(EntPropR.Descriptor);                               // property value
       end-ds;                                                               // snapshot result set

       dcl-s SnapShotRow   like(EntPropR.Sequencer);                         // snapshot row number
       dcl-s sflrr1        like(EntPropR.Sequencer);                         // sfl record number

      /copy qcpysrc,stdentinp                                                // std ent input funcs
      /copy qcpysrc,stdentout                                                // std ent output funcs
      /copy qcpysrc,stdentrule                                               // std ent rules
      /copy qcpysrc,stdcrypfnc                                               // std crypto funcs


      **********************************************************************************************
      *  HELPER FUNCTIONS FOR INTEGRITY AND AUDIT SUPPORT
      **********************************************************************************************

       dcl-proc Ancestor export;                                             // ancestor entity ID

       dcl-pi Ancestor like(EntHeadR.EntityID);                              // ancestor entity ID
         Descendant like(EntHeadR.EntityID) const;                           // descendant entity ID
         AncesClass like(EntHeadR.Class)    const;                           // ancestor class
       end-pi;                                                               // ancestor entity ID

       dcl-s AncestorID like(EntHeadR.EntityID);                             // ancestor entity ID

       AncestorID = getParentID(Descendant);                                 // start at descendant

       dow AncestorID > 0 and getClass(AncestorID) <> AncesClass;            // while not match cls
         AncestorID = getParentID(AncestorID);                               // up one generation
       enddo;                                                                // while not match cls

       return AncestorID;                                                    // return ancestor ID

       end-proc;                                                             // ancestor entity ID

      **********************************************************************************************

       dcl-proc HasChildren export;                                          // entity has children

       dcl-pi HasChildren ind;                                               // entity has children
         EntityID like(EntHeadR.EntityID) const;                             // entity ID
       end-pi;                                                               // entity has children

       dcl-s NumChildren like(EntHeadR.EntityID);                            // number of children

       exec sql select ifnull(count(*), 0) into :NumChildren from enthead
         where parentid = :EntityID;                                         // number of children

       return (NumChildren > 0);                                             // true if positive

       end-proc;                                                             // entity has children


      **********************************************************************************************
      *  STORED PROCEDURES PRODUCING RESULT SETS
      **********************************************************************************************

       dcl-proc SnapShot export;                                             // entity snapshot

       dcl-pi SnapShot;                                                      // entity snapshot
         EntityID like(EntHeadR.EntityID)   const;                           // entity ID
         Moment   like(EntHeadR.CreateTime) const options(*nopass);          // moment in time
       end-pi;                                                               // entity snapshot

       dcl-s MomentX like(EntHeadR.CreateTime);                              // moment in time

       monitor;                                                              // catch all errors

         clear SnapShotRS;                                                   // clear result set
         clear SnapShotRow;                                                  // clear result set row

         if %parms >= 2;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

         SnapShotLevel(EntityID : MomentX : 0);                              // top level properties

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       exec sql set result sets with return to client
         array :SnapShotRS for :SnapShotRow rows;                            // return result set

       end-proc;                                                             // entity snapshot

      **********************************************************************************************

       dcl-proc SnapShotLevel;                                               // entity snapshot

       dcl-pi SnapShotLevel;                                                 // entity snapshot
         EntityID like(EntHeadR.EntityID)   const;                           // entity ID
         Moment   like(EntHeadR.CreateTime) const;                           // moment in time
         Level    like(EntPropR.Sequencer)  const;                           // indentation level
       end-pi;                                                               // entity snapshot

       dcl-ds EntPropX likeds(EntPropR) dim(1000) inz;                       // entprop record

       dcl-s ClassX      like(EntHeadR.Class);                               // entity class
       dcl-s Index       like(EntPropR.Sequencer);                           // array index
       dcl-s PropCountX  like(EntPropR.Sequencer);                           // property count
       dcl-s ValueX      like(EntNoteR.Value);                               // characterized value
       dcl-s LinkIDx     like(EntHeadR.EntityID);                            // link entity ID
       dcl-s IndentX     like(EntHeadR.Descriptor);                          // indent spacing
       dcl-s SpacerX     like(EntNoteR.Value);                               // spacer work field
       dcl-s LegacyNx    like(EntHeadR.LegacyN);                             // legacy ID numeric
       dcl-s LegacyAx    like(EntHeadR.LegacyA);                             // legacy ID alpha
       dcl-s DescriptorX like(EntHeadR.Descriptor);                          // description

       monitor;                                                              // catch all errors

         for Index = 1 to (Level * 4);                                       // for each level
           SpacerX += ' ';                                                   // indent accordingly
         endfor;                                                             // for each level

         ClassX = getClass(EntityID);                                        // get entity class

         exec sql select ifnull(count(*), 0) into :PropCountX from entprop
           where class = :ClassX and Property > ' ';                         // how many properties

         exec sql declare SnapShotC1 cursor for
           select * from entprop where class = :ClassX and Property > ' '
             order by sequencer;                                             // properties for class

         exec sql open SnapShotC1;                                           // open cursor
         exec sql fetch from SnapShotC1 for :PropCountX rows into :EntPropX; // fetch property recd
         exec sql close SnapShotC1;                                          // close cursor

         for Index = 1 to PropCountX;                                        // until no more rows

           if EntPropX(Index).DataType = 'NUMB';                             // if number type
             ValueX =
               %char(getNumb(EntityID:EntPropX(Index).Property:Moment));     // retrieve and cast

           elseif EntPropX(Index).DataType = 'FLAG';                         // or flag type
             ValueX =
               getFlag(EntityID:EntPropX(Index).Property:Moment);            // retrieve only

           elseif EntPropX(Index).DataType = 'DATE';                         // or date type
             ValueX =
               getDateA(EntityID:EntPropX(Index).Property:'*ISO':Moment);    // retrieve and cast

           elseif EntPropX(Index).DataType = 'NOTE';                         // or note type
             ValueX =
               getNote(EntityID:EntPropX(Index).Property:Moment);            // retrieve only

           elseif EntPropX(Index).DataType = 'NOTX';                         // or encryp note type
             ValueX =
               getNotX(EntityID:EntPropX(Index).Property:Moment);            // retrieve only

           elseif EntPropX(Index).DataType = 'NUMX';                         // if encryp numb type
             ValueX =
               %char(getNumX(EntityID:EntPropX(Index).Property:Moment));     // retrieve and cast

           elseif EntPropX(Index).DataType = 'DATX';                         // or encryp date type
             ValueX =
               %char(getDatX(EntityID:EntPropX(Index).Property:Moment));     // retrieve only

           elseif EntPropX(Index).DataType = 'LINK';                         // or link type

             LinkIDx  =  getLink(EntityID:EntPropX(Index).Property:Moment);  // link entity ID
             LegacyNx = getNumb(LinkIDx:'LEGACYN':Moment);                   // link legacy ID numer
             LegacyAx = getNote(LinkIDx:'LEGACYA':Moment);                   // link legacy ID alpha
             ValueX   = '';                                                  // reset desc to null

             if LegacyNx > 0;                                                // if legacy ID numeric
               ValueX += %char(LegacyNx) + ' ';                              // show that metadata
             endif;                                                          // if legacy ID numeric

             if LegacyAx > *blanks;                                          // if legacy ID alpha
               ValueX += LegacyAx + ' ';                                     // show that metadata
             endif;                                                          // if legacy ID alpha

             ValueX += getNote(LinkIDx:'DESCRIPTOR':Moment);                 // show link's metadata

           endif;                                                            // if number

           SnapShotRow += 1;                                                 // snapshot row number
           %occur(SnapShotRS) = SnapShotRow;                                 // set DS occurrence

           SnapShotRS.Property   = SpacerX + EntPropX(Index).Property;       // property name
           SnapShotRS.Descriptor = SpacerX + EntPropX(Index).Descriptor;     // property descriptor
           SnapShotRS.Value      = SpacerX + ValueX;                         // property value

           if EntPropX(Index).DataType = 'LINK' and LinkIDx > 0;             // if link property
             SnapShotLevel(LinkIDx : Moment : (Level + 1));                  // down to next level
           endif;                                                            // if link property

         endfor;                                                             // until no more rows

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       end-proc;                                                             // entity snapshot

      **********************************************************************************************

       dcl-proc PropertyLife export;                                         // property life story

       dcl-pi PropertyLife;                                                  // property life story
         EntityID like(EntNoteR.EntityID)   const;                           // entity ID
         Property like(EntNoteR.Property)   const;                           // property nickname
         Moment   like(EntNoteR.ChangeTime) const options(*nopass);          // moment in time
       end-pi;                                                               // property life story

       dcl-ds ResultSet occurs(1000) qualified based(rptr);                  // result set
         ChangeTime like(EntNoteR.ChangeTime);                               // change time stamp
         ChangeUser like(EntNoteR.ChangeUser);                               // change user profile
         ChangeJnam like(EntNoteR.ChangeJnam);                               // change job name
         ChangeJnum like(EntNoteR.ChangeJnum);                               // change job number
         ChangeProg like(EntNoteR.ChangeProg);                               // change program
         Value      like(EntNoteR.Value);                                    // property value
       end-ds;                                                               // result set

       dcl-ds *n;                                                            // type conversion
         ChrNumbX char(25);                                                  // character number
         DecNumbX zoned(25:7) overlay(ChrNumbX);                             // number value
       end-ds;                                                               // type conversion

       dcl-s SQLStm    like(EntNoteR.Value);                                 // sql statement
       dcl-s MomentX   like(EntNoteR.ChangeTime);                            // moment in time
       dcl-s DataTypeX like(EntPropR.DataType);                              // property data type
       dcl-s SubTableX like(EntPropR.DataType);                              // subtable name
       dcl-s Index     like(EntPropR.Sequencer);                             // array index
       dcl-s ValueX    like(EntNoteR.Value);                                 // characterized value
       dcl-s ClassX    like(EntNoteR.Value);                                 // characterized value

       monitor;                                                              // catch all errors

         rptr   = %alloc(%len(ResultSet));                                   // allocate row space
         ClassX = getClass(EntityID);                                        // get entity class

         exec sql select datatype into :DataTypeX from entprop
           where class = :ClassX and property = :Property;                   // get property's type

         if DataTypeX > *blanks;                                             // if valid data type

           if %parms >= 3;                                                   // if moment provided
             MomentX = Moment;                                               // use it
           else;                                                             // no moment provided
             MomentX = getSessionMoment();                                   // use session moment
           endif;                                                            // if moment provided

           SQLStm = 'SELECT ChangeTime, ChangeUser, ChangeJnam, ChangeJnum,'
                  + ' ChangeProg, char(Value)';                              // start sql statement

           SQLStm += ' FROM ENT' + DataTypeX
                  +  ' WHERE entityid = ' + %char(EntityID)
                  +  ' AND property = ' + sQuote + Property + sQuote
                  +  ' AND changetime <= ' + sQuote + %char(MomentX) + sQuote
                  +  ' ORDER BY 1';                                          // rest of SQL stmt

           exec sql prepare PropertyLifeS1 from :SQLStm;                     // prepare statement
           exec sql declare PropertyLifeC1 cursor for PropertyLifeS1;        // declare cursor
           exec sql open PropertyLifeC1;                                     // open cursor

           dou sqlcod <> 0;                                                  // until no more rows

             Index += 1;                                                     // result set index
             rptr = %realloc(rptr:(Index * %len(ResultSet)));                // allocate row space
             %occur(ResultSet) = Index;                                      // set DS occurrence

             exec sql fetch from PropertyLifeC1
               into :ResultSet.ChangeTime, :ResultSet.ChangeUser,
                    :ResultSet.ChangeJnam, :ResultSet.ChangeJnum,
                    :ResultSet.ChangeProg, :ResultSet.Value;                 // fetch change recd

             if sqlcod <> 0;                                                 // if unsuccessful
               Index -= 1;                                                   // decrement row count
             elseif DataTypeX = 'NOTX';                                      // or encrypted note
               ResultSet.Value = Decrypt(ResultSet.Value);                   // decrypt value
             elseif DataTypeX = 'NUMX';                                      // or encrypted number
               ChrNumbX = Decrypt(ResultSet.Value);                          // decrypt value
               ResultSet.Value = %trim(%editc(DecNumbX:'N'));                // show as edited numb
             elseif DataTypeX = 'DATX';                                      // or encrypted date
               ResultSet.Value = Decrypt(ResultSet.Value);                   // decrypt value
             endif;                                                          // if unsuccessful

           enddo;                                                            // until no more rows

           exec sql close PropertyLifeC1;                                    // close cursor

         endif;                                                              // if valid property

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       exec sql set result sets with return to client
         array :ResultSet for :Index rows;                                   // return result set

       end-proc;                                                             // property life story

      **********************************************************************************************

       dcl-proc EntityList export;                                           // entity list

       dcl-pi EntityList;                                                    // entity list
         ParentID   like(EntHeadR.ParentID)   const;                         // parent entity ID
         Class      like(EntHeadR.Class)      const;                         // entity class
         LegacyA    like(EntHeadR.LegacyA)    const;                         // legacy ID alpha
         LegacyN    like(EntHeadR.LegacyN)    const;                         // legacy ID numeric
         Descriptor like(EntHeadR.Descriptor) const;                         // descriptor
       end-pi;                                                               // entity list

       dcl-s SQLStatement varchar(512);                                      // SQL statement
       dcl-s LegacyNx like(EntHeadR.LegacyN);                                // legacy ID numeric

       // determine whether this class uses the alpha or numeric legacy value.

       exec sql select legacyn into :LegacyNx from enthead
         where parentid = :ParentID and class = :Class
           fetch first row only;                                             // get legacy num value

       SQLStatement
         = 'select class, entityid, descriptor, legacya, legacyn'
         + '  from enthead'
         + '  where parentid = ' + %char(ParentID)
         + '    and class = ' + sQuote + Class + sQuote;                     // build SQL statement

       if Descriptor > *blanks;                                              // if descrip search
         SQLStatement +=
           ' and descriptor >= ' + sQuote + Descriptor + sQuote;             // descrip condition
       elseif Ind.NumSearch;                                                 // if numeric search
         SQLStatement += ' and legacyn >= ' + %editc(LegacyN:'3');           // legacy condition
       else;                                                                 // alpha search
         SQLStatement += ' and legacya >= ' + sQuote + LegacyA + sQuote;     // legacy condition
       endif;                                                                // if numeric search

       SQLStatement += ' order by ';                                         // order by clause

       if Descriptor > *blanks;                                              // if searching descrip
         SQLStatement += '3';                                                // sort on that column
       elseif LegacyA > *blanks;                                             // or searching legacy
         SQLStatement += '4, 5';                                             // sort on that column
       elseif LegacyN > 0;                                                   // or searching legacy
         SQLStatement += '5';                                                // sort on that column
       elseif LegacyNx > 0;                                                  // or num legacy is dft
         SQLStatement += '5, 3';                                             // sort on that column
       else;                                                                 // or chr legacy is dft
         SQLStatement += '4, 3';                                             // sort on that column
       endif;                                                                // if searching descrip

       exec sql prepare SearchEntityS2 from :SQLStatement;                   // prepare statement
       exec sql declare SearchEntityC2 cursor for SearchEntityS2;            // declare cursor
       exec sql open SearchEntityC2;                                         // open cursor

       end-proc;                                                             // entity list

      **********************************************************************************************

       dcl-proc EntityLife export;                                           // entity life story

       dcl-pi EntityLife;                                                    // entity list
        EntityID like(EntHeadR.EntityID)   const;                            // parent entity ID
        Moment   like(EntHeadR.CreateTime) const options(*nopass);           // moment in time
       end-pi;                                                               // entity list

       dcl-ds ResultSet occurs(1000) qualified based(rptr);                  // result set
         EntityID  like(EntHeadR.EntityID);                                  // change time stamp
         EventTime like(EntHeadR.CreateTime);                                // change user profile
         EventUser like(EntHeadR.CreateUser);                                // change user profile
         EventJnam like(EntHeadR.CreateJnam);                                // change job name
         EventJnum like(EntHeadR.CreateJnum);                                // change job number
         EventProg like(EntHeadR.CreateProg);                                // change program
         Property  like(EntNoteR.Property);                                  // property nickname
         DataType  like(EntPropR.DataType);                                  // data type
         Value     like(EntNotxR.Value);                                     // property value
       end-ds;                                                               // result set

       dcl-ds *n;                                                            // type conversion
         ChrNumbX char(25);                                                  // character number
         DecNumbX zoned(25:7) overlay(ChrNumbX);                             // number value
       end-ds;                                                               // type conversion

       dcl-s MomentX    like(EntHeadR.CreateTime);                           // moment in time
       dcl-s Index      like(EntPropR.Sequencer);                            // array index
       dcl-s LinkValueX like(EntLinkR.Value);                                // link property value
       dcl-s LegacyNx   like(EntHeadR.LegacyN);                              // legacy numeric ID
       dcl-s LegacyAx   like(EntHeadR.LegacyA);                              // legacy alpha ID

       monitor;                                                              // catch all errors

         rptr   = %alloc(%len(ResultSet));                                   // allocate row space

         if %parms >= 2;                                                     // if moment provided
           MomentX = Moment;                                                 // use it
         else;                                                               // no moment provided
           MomentX = getSessionMoment();                                     // use session moment
         endif;                                                              // if moment provided

       on-error *all;                                                        // on any error

       endmon;                                                               // catch all errors

       exec sql declare EntityLifeC1 cursor for

         select entityid,   createtime, createuser, createjnam,
                createjnum, createprog, 'ENTITYID', ' ', varchar(entityid)
           from enthead
             where entityid = :EntityID and createtime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'DATE', varchar(value)
           from entdate
             where entityid = :EntityID and changetime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'FLAG', varchar(value)
           from entflag
             where entityid = :EntityID and changetime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'LINK', varchar(value)
           from entlink
             where entityid = :EntityID and changetime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'NOTE', varchar(value)
           from entnote
             where entityid = :EntityID and changetime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'NOTX', varchar(value)
           from entnotx
             where entityid = :EntityID and changetime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'NUMB', varchar(value)
           from entnumb
             where entityid = :EntityID and changetime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'NUMX', varchar(value)
           from entnumx
             where entityid = :EntityID and changetime <= :MomentX

         union

         select entityid,   changetime, changeuser, changejnam,
                changejnum, changeprog, property, 'DATX', varchar(value)
           from entdatx
             where entityid = :EntityID and changetime <= :MomentX

         order by 1, 2;                                                      // all property detail

       exec sql open EntityLifeC1;                                           // open cursor

       dou sqlcod <> 0;                                                      // until no more rows

         Index += 1;                                                         // result set index
         rptr = %realloc(rptr:(Index * %len(ResultSet)));                    // allocate row space
         %occur(ResultSet) = Index;                                          // set DS occurrence

         exec sql fetch from EntityLifeC1
           into :ResultSet.EntityID,   :ResultSet.EventTime,
                :ResultSet.EventUser,  :ResultSet.EventJnam,
                :ResultSet.EventJnum,  :ResultSet.EventProg,
                :ResultSet.Property,   :ResultSet.DataType,
                :ResultSet.Value;                                            // fetch entity events

         if sqlcod <> 0;                                                     // if unsuccessful

           Index -= 1;                                                       // decrement row count

         elseif ResultSet.DataType = 'NOTX';                                 // or encrypted note

           ResultSet.Value = Decrypt(ResultSet.Value);                       // decrypt value

         elseif ResultSet.DataType = 'NUMX';                                 // or encrypted number

           ChrNumbX = Decrypt(ResultSet.Value);                              // decrypt value
           ResultSet.Value = %trim(%editc(DecNumbX:'N'));                    // show as edited numb

         elseif ResultSet.DataType = 'DATX';                                 // or encrypted date

           ResultSet.Value = Decrypt(ResultSet.Value);                       // decrypt value

         elseif ResultSet.DataType = 'LINK';                                 // or link property

           LinkValueX =
             getLink(ResultSet.EntityID : ResultSet.Property : MomentX);     // true link value

           LegacyNx = getNumb(LinkValueX : 'LEGACYN' : MomentX);             // legacy ID numeric
           LegacyAx = getNote(LinkValueX : 'LEGACYA' : MomentX);             // legacy ID alpha

           if LegacyNx > 0 or LegacyAx > ' ';                                // if either legacy ID
             ResultSet.Value += ': LEGACY - '
                             +  %trim(%editc(LegacyNx:'Z'))  + ' '
                             +  LegacyAx;                                    // show with link ID
           endif;                                                            // if either legacy ID

         endif;                                                              // if unsuccessful

       enddo;                                                                // until no more rows

       exec sql close EntityLifeC1;                                          // close cursor

       exec sql set result sets with return to client
         array :ResultSet for :Index rows;                                   // return result set

       end-proc;                                                             // entity life story


      **********************************************************************************************
      *  SEARCH FOR ENTITY (5250 INTERFACE)
      **********************************************************************************************

       dcl-proc SearchEntity export;                                         // search for entity

       dcl-pi SearchEntity like(EntHeadR.EntityID);                          // search for entity
         ParentID like(EntHeadR.ParentID) const;                             // parent entity ID
         Class    like(EntHeadR.Class)    const;                             // ancestor class
         PrevID   like(EntHeadR.EntityID) const options(*nopass);            // previous entity ID
       end-pi;                                                               // search for entity

       dcl-s EntityIDx   like(EntHeadR.EntityID);                            // entity ID
       dcl-s ParentIDx   like(EntHeadR.ParentID);                            // parent entity ID
       dcl-s ClassX      like(EntHeadR.Class);                               // entity class
       dcl-s DescriptorX like(EntHeadR.Descriptor);                          // descriptor
       dcl-s LegacyAx    like(EntHeadR.LegacyA);                             // legacy ID alpha
       dcl-s LegacyNx    like(EntHeadR.LegacyN);                             // legacy ID numeric
       dcl-s SelectedIDx like(EntHeadR.EntityID);                            // selected entity ID
       dcl-s PrevIDx     like(EntHeadR.EntityID);                            // previous entity ID

       dcl-s RSLocator sqltype(RESULT_SET_LOCATOR);                          // locator for RS

       // determine whether this class uses the alpha or numeric legacy value.

       exec sql select legacyn into :LegacyNx from enthead
         where parentid = :ParentID and class = :Class
           fetch first row only;

       Ind.NumSearch = (LegacyNx <> 0);                                      // ctl numeric search

       if %parms >= 3;                                                       // if prev ID passed
         PrevIDx = PrevID;                                                   // use prev ID parm
       endif;                                                                // if prev ID passed

       c1pardesc  = getDescriptor(ParentID);                                 // parent descriptor
       c1parclass = getClass(ParentID);                                      // parent entity
       c1schclass = class;                                                   // search class

       if Ind.NumSearch;                                                     // if numeric search
         c1parlegn = getLegacyN(ParentID);                                   // parent legacy numer
       else;                                                                 // alpha search
         c1parlega = getLegacyA(ParentID);                                   // parent legacy alpha
       endif;                                                                // if no alpha legacy

       open stdentrule;                                                      // open display file

       dou Ind.Cancel or SelectedIDx > 0;                                    // until cancel or selc

         Ind.SFLDsp = *off;                                                  // sfl clear mode
         Ind.SFLOpt = *off;                                                  // sfl disable option
         ParentIDx  = ParentID;                                              // parent entity ID
         Classx     = Class;                                                 // class to search

         write schentc1;                                                     // clear subfile
         clear schents1;                                                     // clear all fields
         clear sflrr1;                                                       // subfile record num

         Ind.SFLDsp = *on;                                                   // sfl display mode

         exec sql call EntityList(:ParentIDx, :Classx, :c1schlega,
                                  :c1schlegn, :c1schdesc);                   // builds result set

         exec sql associate result set locator (:RSLocator)
                    with procedure EntityList;                               // finds RS in memory

         exec sql allocate SearchEntityC1 cursor for result set :RSLocator;  // works like a declare

         dou sqlcod <> 0 or %eof(stdentrule);                                // until no more entity

           exec sql fetch from SearchEntityC1
             into :ClassX, :EntityIDx, :DescriptorX, :LegacyAx, :LegacyNx;   // fetch next entity

           if sqlcod = 0;                                                    // if successful fetch

             s1entityid    = EntityIDx;                                      // entity unique ID
             s1class       = ClassX;                                         // entity class
             s1descrip     = DescriptorX;                                    // entity descriptor
             Ind.SFLOpt    = *on;                                            // sfl enable option
             sflrr1       += 1;                                              // sfl record number

             if Ind.NumSearch;                                               // if numeric is dft
               evalr s1legacya = %editc(LegacyNx:'4');                       // legacy numeric
             else;                                                           // alpha search
               s1legacya = LegacyAx;                                         // legacy alpha
             endif;                                                          // if numeric is dft

             write schents1;                                                 // write sfl record

           endif;                                                            // if successful fetch
         enddo;                                                              // while more entities

         if sflrr1 = 0;                                                      // if subfile empty
           sflrr1  = 2;                                                      // sfl record number
           s1descrip = 'NO ENTITIES FOUND';                                  // no entities text
           write schents1;                                                   // write sfl record
         endif;                                                              // if subfile empty

         exec sql close SearchEntityC1;                                      // close cursor

         exfmt schentc1;                                                     // show pop-up window

         if Ind.Cancel;                                                      // if f12 pressed
           SelectedIDx = PrevIDx;                                            // use previous ID
           leave;                                                            // exit looping
         endif;                                                              // if f12 pressed

         readc schents1;                                                     // look for selection

         dow not %eof(stdentrule);                                           // while more sfl recd
           if s1select > *blanks;                                            // if entity selected
             SelectedIDx = s1entityID;                                       // selected entity ID
             leave;                                                          // stop looping
           endif;                                                            // if entity selected
           readc schents1;                                                   // look for selection
         enddo;                                                              // while more sfl recd

       enddo;                                                                // until cancel or selc

       close stdentrule;                                                     // close display file
       return SelectedIDx;                                                   // selected entity ID

       end-proc;                                                             // search for entity

      **********************************************************************************************
