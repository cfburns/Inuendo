      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD TRIGGER PROGRAM HEADER                             *
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
      *                                                                                            *
      *  INSERT THIS /COPY AT THE END OF THE D-SPECS IN ANY TRIGGER PROGRAM.                       *
      *    NOTE THAT IT TRANSITIONS INTO THE C-SPECS, SO LOCATION IS IMPORTANT.
      *    USE "BP" AND "AP" AS THE BASING POINTERS FOR DATA STRUCTURES                            *
      *    REPRESENTING THE BEFORE AND AFTER RECORD IMAGES.                                        *
      *                                                                                            *
      **********************************************************************************************

       dcl-ds TrigBufferX qualified template;                                // trigger buffer
         FileName    char(10);                                               // physical file name
         LibraryName char(10);                                               // library name
         MemberName  char(10);                                               // member name
         EventCode   char(1);                                                // event code
         Timing      char(1);                                                // timing code
         CommitLock  char(1);                                                // commit lock code
         Reserved01  char(3);                                                // reserved
         CharSetID   int(10);                                                // character set ID
         RRNumber    int(10);                                                // relative record num
         Reserved02  char(4);                                                // reserved
         OrigOffset  int(10);                                                // orig recd offset
         OrigLength  int(10);                                                // orig recd length
         OrigNBMOff  int(10);                                                // orig bytmap offset
         OrigNBMLen  int(10);                                                // orig bytmap length
         NewOffset   int(10);                                                // new recd offset
         NewLength   int(10);                                                // new recd length
         NewNBMOff   int(10);                                                // new bytmap offset
         NewNBMLen   int(10);                                                // new bytmap length
       end-ds;                                                               // trigger buffer

       dcl-pi *n;                                                            // entry parameters
         TrigBuffer likeds(TrigBufferX);                                     // trig buffer
         TrigLength int(10);                                                 // trig buffer length
       end-pi;                                                               // entry parameters

       bp = %addr(TrigBuffer) + TrigBuffer.OrigOffset;                       // before img pointer
       ap = %addr(TrigBuffer) + TrigBuffer.NewOffset;                        // after img pointer

       if TrigBuffer.EventCode = '1';                                        // if insert event
         bp = ap;                                                            // share after image
       elseif TrigBuffer.EventCode = '2';                                    // or delete event
         ap = bp;                                                            // share before image
       endif;                                                                // if insert event

