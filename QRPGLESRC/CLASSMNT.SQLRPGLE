      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - CLASS MAINTENANCE                                           *
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

      /copy qcpysrc,stdhpgm                                                  // standard h-specs

       dcl-f classmntfm workstn sfile(classmnts1:sflrr1)
                                sfile(classmnts2:sflrr2);                    // maintenance screens

      /copy qcpysrc,stdentinp                                                // std entity input fnc
      /copy qcpysrc,stdpgmsts                                                // program status DS

       dcl-ds Ind qualified based(iptr);                                     // indicator array
         All         char(99);                                               // all indicators
         Exit        ind overlay(All:03);                                    // F3=Exit
         Search      ind overlay(All:04);                                    // F4=Search
         Create      ind overlay(All:06);                                    // F6=Create
         Cancel      ind overlay(All:12);                                    // F12=Cancel
         Resequence  ind overlay(All:20);                                    // F20=Resequence
         Print       ind overlay(All:21);                                    // F21=Print
         ClsSFLDSP   ind overlay(All:31);                                    // class SFL display
         ClsNamEnab  ind overlay(All:32);                                    // class name enable
         ClsDesEnab  ind overlay(All:33);                                    // class desc enable
         ClsOptEnab  ind overlay(All:36);                                    // class option enable
         PrpSFLDSP   ind overlay(All:41);                                    // prop SFL display
         PrpNamEnab  ind overlay(All:42);                                    // prop name enable
         PrpTypEnab  ind overlay(All:43);                                    // prop type enable
         PrpSeqEnab  ind overlay(All:44);                                    // prop seqn enable
         PrpDesEnab  ind overlay(All:45);                                    // prop desc enable
         PrpOptEnab  ind overlay(All:46);                                    // prop option enable
         PrpSchEnab  ind overlay(All:47);                                    // prop search typ enab
         PrpClsEnab  ind overlay(All:48);                                    // prop link class enab
         ClsNamReqd  ind overlay(All:71);                                    // class name required
         ClsDesReqd  ind overlay(All:72);                                    // class desc required
         ClsNamExist ind overlay(All:73);                                    // class name exists
         ClsEntExist ind overlay(All:74);                                    // class entities exist
         ClsInvPar   ind overlay(All:75);                                    // class invalid parent
         ClsErrors   char(10) overlay(All:71);                               // all class errors
         PrpNamReqd  ind overlay(All:81);                                    // prop name required
         PrpTypReqd  ind overlay(All:82);                                    // prop type required
         PrpSeqReqd  ind overlay(All:83);                                    // prop seqn required
         PrpDesReqd  ind overlay(All:84);                                    // prop desc required
         PrpNamExist ind overlay(All:85);                                    // prop name exists
         PrpValExist ind overlay(All:86);                                    // prop values exist
         PrpMetaData ind overlay(All:87);                                    // prop used by metadta
         PrpInvLink  ind overlay(All:88);                                    // prop invalid lnk cls
         PrpErrors   char(10) overlay(All:81);                               // all property errors
       end-ds;                                                               // indicator array

       dcl-ds EntHead extname('ENTHEAD') template qualified end-ds;          // entity header layout
       dcl-ds EntProp extname('ENTPROP') template qualified end-ds;          // entity props layout

       dcl-s TypesClass like(EntHeadI.Class) inz('DATATYPE');                // data types class
       dcl-s c1FindSv like(c1Find);                                          // save find argument
       dcl-s iptr pointer inz(%addr(*in));                                   // ptr to indicators
       dcl-s sflrr1 packed(5);                                               // sfl record number
       dcl-s sflrr2 packed(5);                                               // sfl record number
       dcl-s FetchErrors int(5) dim(10);                                     // sql fetch errors


       dou *inlr;                                                            // until user exits

         ShowClasses();                                                      // show class list

         if Ind.Exit;                                                        // if F3 to exit
           *inlr = *on;                                                      // end of program
         elseif Ind.Create;                                                  // or F6 to create
           EditClasses('A');                                                 // edit in add mode
         elseif c1Find <> c1FindSv;                                          // or find class
           c1FindSv = c1Find;                                                // save find argument
         else;                                                               // enter pressed
           RevwClasses();                                                    // review class SFL
         endif;                                                              // if F3 to exit

       enddo;                                                                // until f3 pressed

       exec sql close DataTypesX1;                                           // close cursor


       // one time initialization;

       begsr *inzsr;                                                         // initialization

       // cursor for class subfile

       exec sql declare ShowClassesX1 cursor for
         select char(class), char(descriptor), char(partclass) from entprop
           where class >= :c1FindSv and property <= ' '
             order by 1;                                                     // class level

       // cursor for class subfile

       exec sql declare ShowPropsX1 cursor for
         select char(property),   char(datatype), sequencer,
                char(descriptor), char(partclass)
           from entprop
             where class = :c2class and property > ' '
               order by 3;                                                   // properties for class

       // cursor for data types rotary search in property edit window

       exec sql declare DataTypesX1 scroll cursor for
         select char(legacya), entityID from enthead
           where parentID = :FounderID and class = :TypesClass
             order by 1;                                                     // valid data types

       exec sql open DataTypesX1;                                            // open cursor

       endsr;                                                                // initialization

      **********************************************************************************************

       dcl-proc ShowClasses;                                                 // show classes

       c1find         = *blanks;                                             // clear search value
       c1usrprf       = pgmsts.usrprf;                                       // user profile
       c1pgmnam       = pgmsts.pgmnam;                                       // program name
       Ind.ClsSFLDSP  = *off;                                                // SFL clear mode
       Ind.ClsOptEnab = *off;                                                // class opt disabled

       write classmntc1;                                                     // clear subfile
       clear classmnts1;                                                     // clear all fields

       Ind.ClsSFLDSP = *on;                                                  // SFL display mode
       sflrr1        = 0;                                                    // SFL record number

       exec sql open ShowClassesX1;                                          // open cursor

       dou sqlcod <> 0 or %eof(classmntfm);                                  // until no more class

         exec sql fetch from ShowClassesX1
           into :s1class, :s1descrip, :s1parclass
             indicator :FetchErrors;                                         // fetch next row

         if sqlcod = 0;                                                      // if valid fetch
           sflrr1 += 1;                                                      // sfl record number
           Ind.ClsOptEnab = *on;                                             // class option enable
           write classmnts1;                                                 // class sfl record
           clear classmnts1;                                                 // clear all fields
         endif;                                                              // if valid fetch

       enddo;                                                                // until no more class

       if sflrr1 = 0;                                                        // if no classes
         sflrr1 += 2;                                                        // sfl record number
         s1descrip = 'NO CLASSES TO DISPLAY';                                // no classes message
         write classmnts1;                                                   // class sfl record
       endif;                                                                // if no classes

       exec sql close ShowClassesX1;                                         // close cursor

       write classmntk1;                                                     // function keys
       exfmt classmntc1;                                                     // class subfile

       end-proc;                                                             // show classes

      **********************************************************************************************

       dcl-proc RevwClasses;                                                 // review classes

       sflrr1 = 0;                                                           // SFL record number
       readc classmnts1;                                                     // read for 1st option

       dow not %eof(classmntfm);                                             // while not sfl end

         if s1option = 'C';                                                  // if change option
           EditClasses(s1option);                                            // editing window

         elseif s1option = 'D';                                              // or delete option
           EditClasses(s1option);                                            // editing window

         elseif s1option = 'P';                                              // or properties option

           dou Ind.Exit or Ind.Cancel;                                       // until exit or cancel

             ShowProps();                                                    // drill down to props

             if Ind.Exit;                                                    // if F3 to exit
               *inlr = *on;                                                  // close all files
               return;                                                       // terminate program
             elseif Ind.Cancel;                                              // or F12 to cancel
               leave;                                                        // terminate loop
             elseif Ind.Create;                                              // or F6 to create
               EditProps('A');                                               // edit in add mode
             elseif Ind.Resequence;                                          // or F20 to resequence
               ResequenceProps();                                            // resequence props
             else;                                                           // enter pressed
               RevwProps();                                                  // review props SFL
             endif;                                                          // if F3 to exit

           enddo;                                                            // until exit or cancel
         endif;                                                              // if change option

         readc classmnts1;                                                   // read for 1st option

       enddo;                                                                // while not sfl end

       end-proc;                                                             // review classes

      **********************************************************************************************

       dcl-proc EditClasses;                                                 // class edit window

       dcl-pi EditClasses;                                                   // class edit window
         Action char(1) const;                                               // editing action
       end-pi;                                                               // class edit window

       dcl-s ClassCount packed(1);                                           // count of classes
       dcl-s FirstEntity like(EntHeadI.EntityID);                            // first entity head

       clear classmntw1;                                                     // clear all fields

       Ind.ClsNamEnab = (Action = 'A');                                      // class name enable
       Ind.ClsDesEnab = (Action = 'A' or Action = 'C');                      // class desc enable

       if Action = 'A';                                                      // if adding
         w1action  = 'ADD';                                                  // prompt text
       elseif Action = 'C';                                                  // or changing
         w1action   = 'CHANGE';                                              // prompt text
         w1class    = s1class;                                               // class name
         w1descrip  = s1descrip;                                             // class description
         w1parclass = s1parclass;                                            // req'd parent class
       elseif Action = 'D';                                                  // or deleting
         w1action   = 'DELETE';                                              // prompt text
         w1class    = s1class;                                               // class name
         w1descrip  = s1descrip;                                             // class description
         w1parclass = s1parclass;                                            // req'd parent class
         exec sql select entityID into :FirstEntity from enthead
           where class = :w1class fetch first row only;                      // see if any entities
       endif;                                                                // if adding

       dou Ind.Cancel or Ind.ClsErrors = *zeros;                             // until canc or valid

         exfmt classmntw1;                                                   // class edit window
         Ind.ClsErrors = *zeros;                                             // clear all errors

         if not Ind.Cancel;                                                  // if enter pressed

           if Action = 'A';                                                  // if adding class

             Ind.ClsNamReqd = (w1class    = *blanks);                        // class name required
             Ind.ClsDesReqd = (w1descrip  = *blanks);                        // class desc required
             Ind.ClsInvPar  = (w1parclass > *blanks
                                 and not ValidClass(w1parclass));            // invalid parent class

             if Ind.ClsErrors = *zeros;                                      // if no errors yet
               exec sql select count(*) into :ClassCount from entprop
                 where class = trim(:w1class) and property <= ' ';           // see if class exists
               Ind.ClsNamExist = (ClassCount > 0);                           // class exists error
             endif;                                                          // if no errors yet

             if Ind.ClsErrors = *zeros;                                      // if no class errors
               exec sql insert into entprop (class, descriptor, partclass)
                 values(trim(:w1class), trim(:w1descrip),
                                        trim(:w1parclass));                  // create class header
             endif;                                                          // if no class errors

           elseif Action = 'C';                                              // or changing class

             Ind.ClsDesReqd = (w1descrip = *blanks);                         // class desc required
             Ind.ClsInvPar  = (w1parclass > *blanks
                                 and not ValidClass(w1parclass));            // invalid parent class

             if Ind.ClsErrors = *zeros;                                      // if no class errors
               exec sql update entprop
                 set descriptor = trim(:w1descrip),
                     partclass  = trim(:w1parclass)
                   where class = trim(:w1class) and property <= ' ';         // update class header
             endif;                                                          // if no class errors

           elseif Action = 'D';                                              // or deleting class

             Ind.ClsEntExist = (FirstEntity > 0);                            // see if entity exist

             if Ind.ClsErrors = *zeros;                                      // if no class errors
               exec sql delete from entprop where class = :w1class;          // delete class & props
             endif;                                                          // if no class errors

           endif;                                                            // if adding class
         endif;                                                              // if enter pressed
       enddo;                                                                // until valid or canc

       end-proc;                                                             // class edit window

      **********************************************************************************************

       dcl-proc ShowProps;                                                   // show properties

       c2class        = s1class;                                             // class name
       c2descrip      = s1descrip;                                           // class description
       c2usrprf       = pgmsts.usrprf;                                       // user profile
       c2pgmnam       = pgmsts.pgmnam;                                       // program name
       Ind.PrpSFLDSP  = *off;                                                // SFL clear mode
       Ind.PrpOptEnab = *off;                                                // prop opt disabled

       write classmntc2;                                                     // clear subfile
       clear classmnts2;                                                     // clear all fields

       Ind.PrpSFLDSP  = *on;                                                 // SFL display mode
       sflrr2         = 0;                                                   // SFL record number

       exec sql open ShowPropsX1;                                            // open cursor

       dou sqlcod <> 0 or %eof(classmntfm);                                  // until no more class

         exec sql fetch from ShowPropsX1
           into :s2property, :s2datatype, :s2sequence,
                :s2descrip,  :s2lnkclass
             indicator :FetchErrors;                                         // fetch first row

         if sqlcod = 0;                                                      // if valid fetch
           sflrr2 += 1;                                                      // sfl record number
           Ind.PrpOptEnab = *on;                                             // class option enable
           write classmnts2;                                                 // class sfl record
           clear classmnts2;                                                 // clear all fields
         endif;                                                              // if valid fetch

       enddo;                                                                // while more classes

       if sflrr2 = 0;                                                        // if no classes
         sflrr2 += 2;                                                        // sfl record number
         s2descrip = 'NO PROPERTIES TO DISPLAY';                             // no props message
         write classmnts2;                                                   // class sfl record
       endif;                                                                // if no classes

       exec sql close ShowPropsX1;                                           // close cursor

       write classmntk2;                                                     // function keys
       exfmt classmntc2;                                                     // class subfile

       end-proc;                                                             // show properties

      **********************************************************************************************

       dcl-proc RevwProps;                                                   // review properties

       sflrr2 = 0;                                                           // SFL record number
       readc classmnts2;                                                     // read for 1st option

       dow not %eof(classmntfm);                                             // while not sfl end

         if s2option = 'C';                                                  // if change option
           EditProps(s2option);                                              // editing window
         elseif s2option = 'D';                                              // or delete option
           EditProps(s2option);                                              // editing window
         endif;                                                              // if change option

         readc classmnts2;                                                   // read for next option

       enddo;                                                                // while not sfl end

       end-proc;                                                             // review properties

      **********************************************************************************************

       dcl-proc EditProps;                                                   // props edit window

       dcl-pi EditProps;                                                     // props edit window
         Action char(1) const;                                               // editing action
       end-pi;                                                               // props edit window

       dcl-s PropCount packed(1);                                            // count of properties
       dcl-s FirstEntity like(EntHeadI.EntityID);                            // first entity head
       dcl-s TypeEntity  like(EntHeadI.EntityID);                            // data type entity
       dcl-s SQLStmt varchar(256);                                           // SQL statement


       clear classmntw2;                                                     // clear all fields

       Ind.PrpNamEnab = (Action = 'A');                                      // prop name enable
       Ind.PrpTypEnab = (Action = 'A');                                      // prop datatype enable
       Ind.PrpSchEnab = (Action = 'A');                                      // prop search typ enab
       Ind.PrpSeqEnab = (Action = 'A' or Action = 'C');                      // prop sequence enable
       Ind.PrpDesEnab = (Action = 'A' or Action = 'C');                      // prop desc enable

       if Action = 'A';                                                      // if adding

         exec sql
           fetch current from DataTypesX1 into :w2datatype, :TypeEntity;     // fetch this data type

         if sqlcod <> 0;                                                     // if unsuccessful
           exec sql
             fetch first from DataTypesX1 into :w2datatype, :TypeEntity;     // fetch first type
         endif;                                                              // if unsuccessful

         w2action   = 'ADD';                                                 // action text
         w2typedesc = getDescriptor(TypeEntity);                             // data type descriptor

       elseif Action = 'C';                                                  // or changing

         w2action   = 'CHANGE';                                              // prompt text
         w2property = s2property;                                            // property nickname
         w2datatype = s2datatype;                                            // property data type
         w2sequence = s2sequence;                                            // property sequence
         w2descrip  = s2descrip;                                             // property descriptor
         TypeEntity = getEntityID(FounderID:'DATATYPE':0:w2datatype);        // data type entity
         w2typedesc = getDescriptor(TypeEntity);                             // data type descriptor
         w2lnkclass = s2lnkclass;                                            // req'd link class

       elseif Action = 'D';                                                  // or deleting

         w2action   = 'DELETE';                                              // action text
         w2property = s2property;                                            // property nickname
         w2datatype = s2datatype;                                            // property data type
         w2sequence = s2sequence;                                            // property sequence
         w2descrip  = s2descrip;                                             // class description
         TypeEntity = getEntityID(FounderID:'DATATYPE':0:w2datatype);        // data type entity
         w2typedesc = getDescriptor(TypeEntity);                             // data type descriptor
         w2lnkclass = s2lnkclass;                                            // req'd link class

       endif;                                                                // if adding

       dou Ind.Cancel or Ind.PrpErrors = *zeros and not Ind.Search;          // until canc or valid

         Ind.PrpClsEnab = (w2datatype = 'LINK');                             // enable link class

         exfmt classmntw2;                                                   // props edit window

         Ind.PrpErrors = *zeros;                                             // clear all errors

         if Ind.Search;                                                      // if search data type

           exec sql
             fetch next from DataTypesX1 into :w2datatype, :TypeEntity;      // fetch next data type

           if sqlcod <> 0;                                                   // if unsuccessful
             exec sql
               fetch first from DataTypesX1 into :w2datatype, :TypeEntity;   // fetch first type
           endif;                                                            // if unsuccessful

           TypeEntity = getEntityID(FounderID:'DATATYPE':0:w2datatype);      // data type entity
           w2typedesc = getDescriptor(TypeEntity);                           // data type descriptor

         elseif not Ind.Cancel;                                              // or enter pressed

           if Action = 'A';                                                  // if adding class

             Ind.PrpNamReqd  = (w2property = *blanks);                       // prop name required
             Ind.PrpDesReqd  = (w2descrip = *blanks);                        // prop desc required
             Ind.PrpTypReqd  =
               (getEntityID(FounderID:'DATATYPE':0:w2datatype) = 0);         // prop type required

             Ind.PrpMetaData = (w2property = 'CLASS'      or
                                w2property = 'PARENTID'   or
                                w2property = 'DESCRIPTOR' or
                                w2property = 'LEGACYN'    or
                                w2property = 'LEGACYA'    or
                                w2property = 'STATUS');                      // prop used by metadta

             Ind.PrpInvLink  = (w2lnkclass > *blanks
                                 and not ValidClass(w2lnkclass));            // invalid link class

             if Ind.PrpErrors = *zeros;                                      // if no errors yet
               exec sql select count(*) into :PropCount from entprop
                 where class    = trim(:c2class)
                   and property = trim(:w2property);                         // see if prop exists
               Ind.PrpNamExist = (PropCount > 0);                            // prop exists error
             endif;                                                          // if no errors yet

             if Ind.PrpErrors = *zeros;                                      // if no class errors
               exec sql
                 insert into entprop
                   (class,     property,   datatype,
                    sequencer, descriptor, partclass)
                 values(trim(:c2class), trim(:w2property), trim(:w2datatype),
                        :w2sequence, trim(:w2descrip), trim(:w2lnkclass));   // create property
             endif;                                                          // if no class errors

           elseif Action = 'C';                                              // or changing class

             Ind.PrpDesReqd = (w2descrip = *blanks);                         // prop desc required
             Ind.PrpInvLink = (w2lnkclass > *blanks
                                 and not ValidClass(w2lnkclass));            // invalid link class

             if Ind.PrpErrors = *zeros;                                      // if no prop errors
               exec sql update entprop
                 set descriptor = trim(:w2descrip), sequencer = :w2sequence,
                     partclass  = trim(:w2lnkclass)
                   where class = trim(:c2class)
                     and property = trim(:w2property);                       // update property recd
             endif;                                                          // if no prop errors

           elseif Action = 'D';                                              // or deleting prop

             SQLStmt = 'select entityid from enthead h join '
               + 'ENT' + %trim(w2datatype) + ' s on h.entityid = s.entityid'
               + ' and h.class = ' + squote + %trim(c2class) + squote
               + ' and s.property = ' + squote + %trim(w2property) + squote
               + ' optimize for 1 row';                                      // any subtable entries

             exec sql prepare EditPropsS1 from :SQLStmt;                     // prepare cursor
             exec sql declare EditPropsC1 cursor for EditPropsS1;            // declare cursor
             exec sql open EditPropsC1;                                      // open cursur
             exec sql fetch from EditPropsC1 into :FirstEntity;              // one fetch enough
             exec sql close EditPropsC1;                                     // close cursor

             Ind.PrpValExist = (FirstEntity <> 0);                           // prop values exist

             if Ind.PrpErrors = *zeros;                                      // if no prop errors
               exec sql delete from entprop
                 where class = trim(:c2class)
                   and property = trim(:w2property);                         // delete property
             endif;                                                          // if no prop errors

           endif;                                                            // if adding class
         endif;                                                              // if enter pressed
       enddo;                                                                // until valid or canc

       Ind.Cancel = *off;                                                    // just back up one

       end-proc;                                                             // props edit window

      **********************************************************************************************

       dcl-proc ResequenceProps;                                             // resequence props

       sflrr2 = 0;                                                           // SFL record number
       readc classmnts2;                                                     // read 1st property

       dow not %eof(classmntfm);                                             // while not sfl end

         s2sequence = sflrr2 * 10;                                           // new sequence number

         exec sql update entprop
           set sequencer = :s2sequence
             where class = :c2class and property = :s2property;              // update property recd

         update classmnts2 %fields(s2sequence);                              // update SFL record
         readc classmnts2;                                                   // read next property

       enddo;                                                                // while not sfl end

       end-proc;                                                             // resquence props

      **********************************************************************************************
