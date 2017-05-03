      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - TEMPORAL INTEGRITY ENFORCEMENT (ENTNOTX)                    *
      *                                                                                            *
      *  Copyright (C) 2012, 2017  Christopher F. Burns Sr.                                        *
      *    c/o The Inuendo Project (http://inuendo.us).                                            *
      *                                                                                            *
      *  Apply as trigger program for delete and update events on ENTNOTX.                         *
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


      /copy qcpysrc,stdhpgm                                                  // std h-spec for pgms

       dcl-ds imgbef extname('ENTNOTX') qualified based(bp) end-ds;          // image before
       dcl-ds imgaft extname('ENTNOTX') qualified based(ap) end-ds;          // image after

       dcl-s ErrorIDx like(EntHeadO.EntityID);                               // error entity ID

      /copy qcpysrc,stdentout                                                // std output funcs
      /copy qcpysrc,stdpgmsts                                                // program status DS
      /copy qcpysrc,whodunnit                                                // who done it funcs
      /copy qcpysrc,stdtrghdr                                                // std trigger header

       // Deletes allowed only from the DeleteEntity and RollBackJob procedures.

       if TrigBuffer.EventCode = '2';                                        // if delete event

         if not (FiredByProc('DELETEENTITY' : 'STDENTUTIL')
              or FiredByProc('ROLLBACKJOB'  : 'STDENTUTIL'));                // if not legitimate

           exec sql insert into EntNotx values(:imgbef);                     // put entry back
           ErrorIDx =
             newEntityN(imgaft.EntityID : 'PROPERROR' : 0 : IllPropDel);     // create error entity

         endif;                                                              // if not legitimate

       // Updates are not allowed under any circumstances.

       elseif TrigBuffer.EventCode = '3';                                    // or update event

         imgaft   = imgbef;                                                  // cancel any changes
         ErrorIDx =
           newEntityN(imgaft.EntityID : 'PROPERROR' : 0 : IllPropUpd);       // create error entity

       endif;                                                                // if delete event

       // Error entity information.

       if ErrorIDx > 0;                                                      // if error entity
         putNote(ErrorIDx : 'FUNCTION' : GuiltyPgm(pgmsts.pgmnam));          // function in error
         putNote(ErrorIDx : 'SUBTABLE' : TrigBuffer.FileName);               // property subtable
         putNote(ErrorIDx : 'PROPPATH' : imgaft.Property);                   // orig property path
         putLink(ErrorIDx : 'OWNER'    : imgaft.EntityID);                   // owner entity ID
       endif;                                                                // if error entity

       *inlr = *on;                                                          // end of program

