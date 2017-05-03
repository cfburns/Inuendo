      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - WHO DONE IT FUNCTIONS (w/SQL WRAPPERS)                      *
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

      /copy qcpysrc,stdhsrvpgm                                               // std h-specs srvpgm
      /copy qcpysrc,stdpgmsts                                                // program status DS
      /copy qcpysrc,whodunnit                                                // who done it funcs

      **********************************************************************************************
      *  PROTOTYPES, WORKING STORAGE FOR QWVRCSTK API.
      **********************************************************************************************

       dcl-pr RtvStkEnt extpgm('QWVRCSTK');                                  // retrieve stack API
         RecvVari like(RecvData);                                            // receiver variable
         RecvLeng like(RecvLeng) const;                                      // receiver length
         RecvForm like(RecvForm) const;                                      // receiver format
         IdenInfo like(JIDF0100) const;                                      // job i/d info
         IdenForm like(JobIDFmt) const;                                      // job i/d format
         ErroCode like(ErrorCode);                                           // error code
       end-pr;                                                               // retrieve stack API

       dcl-ds JIDF0100 qualified;                                            // job i/d info 100
         Job_Name char(10) inz('*');                                         // job name
         UserProf char(10);                                                  // user profile
         Job_Numb char(6);                                                   // job number
         Job_Iden char(16);                                                  // internal job i/d
         Reserved char(2) inz(x'0000');                                      // reserved
         ThrdIndc int(10) inz(1);                                            // thread indicator
         ThrdIden char(8) inz(x'0000000000000000');                          // thread identifier
       end-ds;                                                               // job i/d info 100

       dcl-ds Head based(HeadPtr) qualified;                                 // receiver var header
         ByteRetn int(10);                                                   // bytes returned
         ByteAval int(10);                                                   // bytes available
         EntrThrd int(10);                                                   // num of entry thread
         OffsEntr int(10);                                                   // offset to entries
         EntrRetn int(10);                                                   // num of entry return
         ThrdIden char(8);                                                   // thread i/d
         InfoStat char(1);                                                   // info status
         Reserved char(1);                                                   // reserved
       end-ds;                                                               // receiver var header

       dcl-ds Detl based(DetlPtr) qualified;                                 // receiver data dtl
         LengEntr int(10);                                                   // len of call stk ent
         StmtDisp int(10);                                                   // displ to stmt i/d
         StmtCoun int(10);                                                   // num of stmt i/d
         ProcDisp int(10);                                                   // displ to proc name
         ProcLeng int(10);                                                   // len of proc name
         ReqsLevl int(10);                                                   // request level
         ProgName char(10);                                                  // program name
         ProgLibr char(10);                                                  // program lib name
       end-ds;                                                               // receiver data dtl

       dcl-ds ErrorCode qualified;                                           // std error code
         ByteProv int(10) inz(%len(ErrorCode));                              // bytes provided
         ByteAval int(10) inz;                                               // bytes available
         ExcpIden char(7);                                                   // exception identifier
         Reserved char(1);                                                   // reserved
         ExcpData char(64);                                                  // exception data
       end-ds;                                                               // std error code

       dcl-s RecvData char(4096);                                            // receiver variable
       dcl-s RecvLeng int(10) inz(%len(RecvData));                           // receiver length
       dcl-s RecvForm char(8) inz('CSTK0100');                               // receiver format
       dcl-s JobIDFmt char(8) inz('JIDF0100');                               // job i/d format
       dcl-s ProcWork char(32) based(PNamPtr);                               // procedure name work
       dcl-s ProcIden varchar(32);                                           // procedure identifier
       dcl-s StkCount like(Head.EntrRetn);                                   // stack counter

      **********************************************************************************************
      *  PROTOTYPES, WORKING STORAGE FOR QUSROBJD API.
      **********************************************************************************************

       dcl-pr RtvObjDsc extpgm('QUSROBJD');                                  // retrieve obj dsc API
         RecvVari like(OBJD0100);                                            // receiver variable
         RecvLeng like(RecvLeng)  const;                                     // receiver length
         RecvForm like(RecvForm)  const;                                     // receiver format
         ObjLibr  char(20)        const;                                     // object/library name
         ObjType  char(10)        const;                                     // object type
         ErroCode like(ErrorCode);                                           // error code
       end-pr;                                                               // retrieve obj dsc API

       dcl-ds OBJD0100 qualified;                                            // QUSROBJD receiver
         ByteRetn   int(10);                                                 // bytes provided
         ByteAval   int(10) inz(%len(OBJD0100));                             // bytes available
         ObjName   char(10);                                                 // object name
         ObjLibr   char(10);                                                 // object library
         ObjType   char(10);                                                 // object type
         RetnLibr  char(10);                                                 // return library
         ASPNo      int(10);                                                 // ASP number
         ObjOwner  char(10);                                                 // object owner
         ObjDomain char(2);                                                  // object domain
         CrtDatTim char(13);                                                 // create date/time
         CngDatTim char(13);                                                 // change date/time
       end-ds;                                                               // QUSROBJD receiver

      **********************************************************************************************
      *  FIRED BY A USER PROGRAM (RPG FRIENDLY)
      **********************************************************************************************

      *  This function determines whether a user program is in the job stack.
      *    and optionally whether the current statement number is in a list
      *    of up to five statements.

       dcl-proc FiredByPgm export;                                           // fired by program

       dcl-pi FiredByPgm ind;                                                // fired by program
         ProgName char(10) const;                                            // program name
         IOStm1   char(10) const options(*nopass);                           // i/o statement 1
         IOStm2   char(10) const options(*nopass);                           // i/o statement 2
         IOStm3   char(10) const options(*nopass);                           // i/o statement 3
         IOStm4   char(10) const options(*nopass);                           // i/o statement 4
         IOStm5   char(10) const options(*nopass);                           // i/o statement 5
       end-pi;                                                               // fired by program

       dcl-s StatementID char(10) based(StmtPtr);                            // statement ID

       RtvStkEnt(RecvData : RecvLeng : RecvForm :
                 JIDF0100 : JobIDFmt : ErrorCode);                           // retrieve pgm stack

       HeadPtr  = %addr(RecvData);                                           // align to header
       DetlPtr  = %addr(RecvData) + Head.OffsEntr;                           // align to 1st detail
       StkCount = 1;                                                         // stack counter

       dow Detl.ProgName <> ProgName and StkCount < Head.EntrRetn;           // while no pgm match
         DetlPtr  += Detl.LengEntr;                                          // align to next detail
         StkCount += 1;                                                      // stack counter
       enddo;                                                                // while no pgm match

       if Detl.ProgName <> ProgName;                                         // if no program match
         return *off;                                                        // return false
       elseif %parms = 1;                                                    // or match & no stmt
         return *on;                                                         // return true
       else;                                                                 // match with statement
         StmtPtr = DetlPtr + Detl.StmtDisp;                                  // align to stmt i/d
         return ((%parms > 1 and StatementID = IOStm1) or
                 (%parms > 2 and StatementID = IOStm2) or
                 (%parms > 3 and StatementID = IOStm3) or
                 (%parms > 4 and StatementID = IOStm4) or
                 (%parms > 5 and StatementID = IOStm5));                     // return true or false
       endif;                                                                // if program match

       end-proc;                                                             // fired by program

      **********************************************************************************************
      *  FIRED BY A USER PROGRAM (SQL FRIENDLY) - 1 PARAMETER
      **********************************************************************************************

       dcl-proc FiredByPgm1 export;                                          // fired by program

       dcl-pi FiredByPgm1 ind;                                               // fired by program
         ProgName char(10) const;                                            // program name
       end-pi;                                                               // fired by program

       return FiredByPgm(ProgName);                                          // true if in stack

       end-proc;                                                             // fired by program

      **********************************************************************************************
      *  GUILTY PROGRAM (RPG & SQL FRIENDLY)
      **********************************************************************************************

      *  This function determines which user program in a library other than
      *    the Inuendo object library, is deepest in the program stack.  This
      *    is often used by trigger programs to determine which user program
      *    caused the trigger to fire.  The optional StartPoint allows you to
      *    specify a program name in the stack from which to begin the search
      *    outward.  If the start point is not in the stack, it is ignored.
      *    Trigger programs whose purpose is to map legacy data to Inuendo in
      *    real time, may be placed in the Inuendo object library so that
      *    they are ignored in the search.  An alternative is to specify the
      *    trigger program name as the StartPoint.
      *
      *  Normal Inuendo operations use this function to determine which user
      *    application program requested a PUT operation, so that ENTHEAD
      *    field CREATEPROG or subtable field CHANGEPROG is accurate.

       dcl-proc GuiltyPgm export;                                            // guilty program

       dcl-pi GuiltyPgm char(10);                                            // guilty program
         StartPoint char(10) const options(*nopass);                         // starting point
       end-pi;                                                               // guilty program

       // Retrieve program stack

       RtvStkEnt(RecvData : RecvLeng : RecvForm :
                 JIDF0100 : JobIDFmt : ErrorCode);                           // retrieve pgm stack

       HeadPtr  = %addr(RecvData);                                           // align to header
       DetlPtr  = %addr(RecvData) + Head.OffsEntr;                           // align to 1st detail
       StkCount = 1;                                                         // stack counter

       // If starting point specified, advance stack pointer accordingly

       if %parms >= 1 and StartPoint > *blanks;                              // if starting point

         dow Detl.ProgName <> StartPoint and StkCount < Head.EntrRetn;       // while no pgm match
           DetlPtr  += Detl.LengEntr;                                        // align to next detail
           StkCount += 1;                                                    // stack counter
         enddo;                                                              // while no pgm match

         if Detl.ProgName <> StartPoint and StkCount = Head.EntrRetn;        // if not in stack
           DetlPtr  = %addr(RecvData) + Head.OffsEntr;                       // reset stack pointer
           StkCount = 1;                                                     // reset stack counter
         elseif StkCount = Head.EntrRetn;                                    // or no more entries
           return *blanks;                                                   // no user pgm match
         endif;                                                              // if not in stack

       endif;                                                                // if starting point

       // Search stack for application program in user library

       dou StkCount = Head.EntrRetn or
             %subst(Detl.ProgName:1:1) <> 'Q'
               and Detl.ProgLibr <> pgmsts.pgmlib
               and Detl.ProgName <> StartPoint
               and ErrorCode.ExcpIden = *blanks;                             // until guilty app pgm

         DetlPtr += Detl.LengEntr;                                           // point to next detail
         StkCount = StkCount + 1;                                            // stack counter

         reset ErrorCode;                                                    // reset error code

         RtvObjDsc(OBJD0100 : %len(OBJD0100) : 'OBJD0100' :
                   Detl.ProgName + Detl.ProgLibr : '*PGM' : ErrorCode);      // see if it's a *PGM

       enddo;                                                                // until guilty app pgm

       // The last stack entry will never be a user program

       if StkCount = Head.EntrRetn;                                          // if end of stack
         return *blanks;                                                     // no matching usr pgm
       else;                                                                 // match was found
         return Detl.ProgName;                                               // return guilty pgm
       endif;                                                                // if end of stack

       end-proc;                                                             // guilty program

      **********************************************************************************************
      *  GUILTY PROGRAM (SQL FRIENDLY, NO PARAMETERS)
      **********************************************************************************************

       dcl-proc GuiltyPgm0 export;                                           // guilty program

       dcl-pi GuiltyPgm0 char(10);                                           // guilty program
       end-pi;                                                               // guilty program

       return GuiltyPgm(*blanks);                                            // invoke base function

       end-proc;                                                             // guilty program

      **********************************************************************************************
      *  FIRED BY A PROCEDURE (RPG FRIENDLY)
      **********************************************************************************************

      *  This function determines whether a user procedure is in the job stack
      *    and optionally whether it is within a specified service program.

       dcl-proc FiredByProc export;                                          // fired by procedure

       dcl-pi FiredByProc ind;                                               // fired by procedure
         ProcName   char(32) const;                                          // program name
         ServicePgm char(10) const options(*nopass);                         // service program name
       end-pi;                                                               // fired by procedure

       RtvStkEnt(RecvData : RecvLeng : RecvForm :
                 JIDF0100 : JobIDFmt : ErrorCode);                           // retrieve pgm stack

       HeadPtr  = %addr(RecvData);                                           // align to header
       DetlPtr  = %addr(RecvData) + Head.OffsEntr;                           // align to 1st detail
       StkCount = 1;                                                         // stack counter
       PNamPtr  = DetlPtr + Detl.ProcDisp;                                   // proc name pointer
       ProcIden = %subst(ProcWork:1:Detl.ProcLeng);                          // procedure identifier

       dow StkCount < Head.EntrRetn and
             (ProcIden <> ProcName or
              %parms >= 2 and Detl.ProgName <> ServicePgm);                  // while no proc match
         DetlPtr += Detl.LengEntr;                                           // align to next detail
         PNamPtr  = DetlPtr + Detl.ProcDisp;                                 // proc name pointer
         ProcIden = %subst(ProcWork:1:Detl.ProcLeng);                        // procedure identifier
         StkCount = StkCount + 1;                                            // stack counter
       enddo;                                                                // while no pgm match

       if StkCount <= Head.EntrRetn and
            ProcIden = ProcName and
              (%parms = 1 or Detl.ProgName = ServicePgm);                    // if proc name match
         return *on;                                                         // return true
       else;                                                                 // no pgm/proc match
         return *off;                                                        // return false
       endif;                                                                // if pgm/proc match

       end-proc;                                                             // fired by procedure

      **********************************************************************************************
      *  FIRED BY A PROCEDURE (SQL FRIENDLY) - 1 PARAMETER
      **********************************************************************************************

       dcl-proc FiredByProc1 export;                                         // fired by procedure

       dcl-pi FiredByProc1 ind;                                              // fired by procedure
         ProcName char(32) const;                                            // program name
       end-pi;                                                               // fired by procedure

       return FiredByProc(ProcName);                                         // true if in stack

       end-proc;                                                             // fired by procedure

      **********************************************************************************************
      *  FIRED BY A PROCEDURE (SQL FRIENDLY) - 2 PARAMETERS
      **********************************************************************************************

       dcl-proc FiredByProc2 export;                                         // fired by procedure

       dcl-pi FiredByProc2 ind;                                              // fired by procedure
         ProcName   char(32) const;                                          // program name
         ServicePgm char(10) const;                                          // service program name
       end-pi;                                                               // fired by procedure

       return FiredByProc(ProcName:ServicePgm);                              // true if in stack

       end-proc;                                                             // fired by procedure

      **********************************************************************************************
      *  GUILTY OUTPUT PROCEDURE
      **********************************************************************************************

      *  This function determines which STDENTOUT procedure is in the current
      *    job stack.  It is used for error reporting.  The procedure in
      *    service program STDENTOUT that is highest in the job stack is used.

       dcl-proc GuiltyOutputProc export;                                     // guilty output proc

       dcl-pi GuiltyOutputProc varchar(254) end-pi;                          // guilty output proc

       dcl-s GuiltyProc varchar(254);                                        // guilty procedure

       RtvStkEnt(RecvData : RecvLeng : RecvForm :
                 JIDF0100 : JobIDFmt : ErrorCode);                           // retrieve pgm stack

       HeadPtr  = %addr(RecvData);                                           // align to header
       DetlPtr  = %addr(RecvData) + Head.OffsEntr;                           // align to 1st detail
       StkCount = 1;                                                         // stack counter

       dou StkCount = Head.EntrRetn;                                         // until top of stack

         DetlPtr += Detl.LengEntr;                                           // align to next detail
         PNamPtr  = DetlPtr + Detl.ProcDisp;                                 // proc name pointer
         ProcIden = %subst(ProcWork:1:Detl.ProcLeng);                        // procedure identifier

         if Detl.ProgName = 'STDENTOUT' and Detl.ProgLibr = pgmsts.pgmlib;   // if output procedure
           GuiltyProc = ProcIden;                                            // capture proc name
         endif;                                                              // if output procedure

         StkCount = StkCount + 1;                                            // stack counter

       enddo;                                                                // until top of stack

       return GuiltyProc;                                                    // return proc name

       end-proc;                                                             // guilty output proc

