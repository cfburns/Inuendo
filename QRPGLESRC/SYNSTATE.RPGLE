      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - SYNCHRONIZE STATE ENTITIES                                  *
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
      *                                                                                            *
      *  ASSUME THAT A FILE "STATE" HAS AN ALPHA FIELD "STSTAT" (STATE CODE) AND AND ALPHA         *
      *    FIELD "STNAME" (STATE NAME).                                                            *
      *                                                                                            *
      *  ESTABLISH TRIGGER ON "STATE" FOR INSERT, DELETE AND UPDATE EVENTS, EACH CALLING THIS      *
      *    PROGRAM.  KEEPS "ENTHEAD" IN SYNCH WITH "STATE".                                        *
      *                                                                                            *
      *  COMMANDS:                                                                                 *
      *    ADDPFTRG FILE(STATE) TRGTIME(*AFTER) TRGEVENT(*INSERT) PGM(SYNSTATE) TRG(SYNSTATEI)     *
      *    ADDPFTRG FILE(STATE) TRGTIME(*AFTER) TRGEVENT(*DELETE) PGM(SYNSTATE) TRG(SYNSTATED)     *
      *    ADDPFTRG FILE(STATE) TRGTIME(*AFTER) TRGEVENT(*UPDATE) PGM(SYNSTATE) TRG(SYNSTATEU)     *
      *                                                                                            *
      **********************************************************************************************

      /copy qcpysrc,stdhpgm                                                  // std h-specs for pgm

       dcl-ds imgbef extname('STATE') qualified based(bp) end-ds;            // record image before
       dcl-ds imgaft extname('STATE') qualified based(ap) end-ds;            // record image after

       dcl-s StateID like(EntHeadO.EntityID);                                // state entity ID

      /copy qcpysrc,stdentinp                                                // std input funcs
      /copy qcpysrc,stdentout                                                // std output funcs
      /copy qcpysrc,stdtrghdr                                                // std trigger header

       StateID =
         newEntityA(FounderID : 'STATE' : imgaft.ststat : imgaft.stname);    // new state entity ID

       // Or, if you prefer, do a getEntityID first and then do a newEntity
       //   in the event the result is zero.

       if TrigBuffer.EventCode = '2';                                        // if delete event
         putStatus(StateID : 'D');                                           // flag as disabled
       endif;                                                                // if delete event

       // If subtable PUT's were necessary, they would go here.

       *inlr = *on;                                                          // end of program

