      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - TEMPORAL INTEGRITY ENFORCEMENT (ENTHEAD)                    *
      *                                                                                            *
      *  Copyright (C) 2012, 2019  Christopher F. Burns Sr.                                        *
      *    c/o The Inuendo Project (http://inuendo.us).                                            *
      *                                                                                            *
      *  Apply as trigger program for delete and update events on ENTHEAD.                         *
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


      /copy qcpysrc,stdhpgm                                                  // std h-specs for pgm

       dcl-ds imgbef extname('ENTHEAD') qualified based(bp) end-ds;          // image before
       dcl-ds imgaft extname('ENTHEAD') qualified based(ap) end-ds;          // image after

       dcl-s ErrorIDx like(EntHeadO.EntityID);                               // error entity ID

      /copy qcpysrc,stdentout                                                // protytpes, work stg
      /copy qcpysrc,stdpgmsts                                                // program status DS
      /copy qcpysrc,whodunnit                                                // who done it funcs
      /copy qcpysrc,stdtrghdr                                                // std trigger header

       // Constraints should prevent any deletions if there are dependent
       // child entities or links.  This is just an added measure.

       if TrigBuffer.EventCode = '2';                                        // if delete event

         if not (FiredByProc('DELETEENTITY' : 'STDENTUTIL'));                // if not legitimate
           exec sql insert into EntHead overriding system value
             values(:imgbef);                                                // put entity back
           ErrorIDx =
             newEntityN(imgaft.EntityID : 'CLASSERROR' : 0 : IllHeadDel);    // create error entity
         endif;                                                              // if not legitimate

       // Updates should only be performed by metadata PUT functions.
       // The conditions are sequenced with performance in mind.

       elseif TrigBuffer.EventCode = '3';                                    // or update event

         if not (FiredByProc('PUTSTATUS'     : 'STDENTOUT')
              or FiredByProc('PUTDESCRIPTOR' : 'STDENTOUT')
              or FiredByProc('PUTLEGACYA'    : 'STDENTOUT')
              or FiredByProc('PUTLEGACYN'    : 'STDENTOUT')
              or FiredByProc('PUTPARENTID'   : 'STDENTOUT')
              or FiredByProc('PUTCLASS'      : 'STDENTOUT'));                // if not legitimate

           imgaft   = imgbef;                                                // cancel any changes
           ErrorIDx =
             newEntityN(imgaft.EntityID : 'CLASSERROR' : 0 : IllHeadUpd);    // create error entity

         endif;                                                              // if not legitimate

       endif;                                                                // if delete event

       // Error entity information.

       if ErrorIDx > 0;                                                      // if error entity
         putNote(ErrorIDx : 'FUNCTION' : GuiltyPgm(pgmsts.pgmnam));          // function in error
       endif;                                                                // if error entity

       *inlr = *on;                                                          // end of program

