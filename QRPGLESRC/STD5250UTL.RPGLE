      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD 5250 UTILITIES                                     *
      *                                                                                            *
      *  Copyright (C) 2012, 2019  Christopher F. Burns Sr.                                        *
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

      /copy qcpysrc,stdhsrvpgm                                               // ctl specs for srvpgm
      /copy qcpysrc,stdentinp                                                // entity input funcs

      **********************************************************************************************
      *  POP-UP WINDOW PROMPTS FOR VARIOUS DATA TYPES.
      **********************************************************************************************

       dcl-proc PromptDate export;                                           // prompt for date

       dcl-pi PromptDate like(EntDateI.Value);                               // prompt for date
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntDateI.Value) const options(*nopass);             // default value
       end-pi;                                                               // prompt for date

       dcl-f std5250utl workstn include(PromptDate);                         // pop-up window
       dcl-ds PromptDateX likerec(PromptDate:*all) inz;                      // pop-up record

       PromptDateX.DateTxt = PromptText;                                     // text for prompt
       PromptDateX.DateTxt = %scanrpl('  ' : ' .' : PromptDateX.DateTxt :
                                      1 + %len(%trim(PromptDateX.DateTxt))); // add dotted line

       if %parms >= 3;                                                       // if default value
         PromptDateX.DateVal = DftValue;                                     // show in window
       endif;                                                                // if default value

       dou PromptDateX.DateVal <> *loval or
             (%parms >= 3 and Required = 'N');                               // until valid date
         exfmt PromptDate PromptDateX;                                       // show pop-up window
         evalr PromptDateX.DateErr = 'REQUIRED';                             // text for 2nd pop
       enddo;                                                                // until valid date

       return PromptDateX.DateVal;                                           // user specified value

       end-proc;                                                             // prompt for date

      **********************************************************************************************

       dcl-proc PromptFlag export;                                           // prompt for flag

       dcl-pi PromptFlag like(EntFlagI.Value);                               // prompt for flag
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntFlagI.Value) const options(*nopass);             // default value
       end-pi;                                                               // prompt for flag

       dcl-f std5250utl workstn include(PromptFlag);                         // pop-up window
       dcl-ds PromptFlagX likerec(PromptFlag:*all) inz;                      // pop-up record

       PromptFlagX.FlagTxt = PromptText;                                     // text for prompt
       PromptFlagX.FlagTxt = %scanrpl('  ' : ' .' : PromptFlagX.FlagTxt :
                                      1 + %len(%trim(PromptFlagX.FlagTxt))); // add dotted line

       if %parms >= 3;                                                       // if default value
         PromptFlagX.FlagVal = DftValue;                                     // show in window
       endif;                                                                // if default value

       dou PromptFlagX.FlagVal <> *blank or
             (%parms >= 3 and Required = 'N');                               // until valid flag
         exfmt PromptFlag PromptFlagX;                                       // show pop-up window
         evalr PromptFlagX.FlagErr = 'REQUIRED';                             // text for 2nd pop
       enddo;                                                                // until valid flag

       return PromptFlagX.FlagVal;                                           // user specified value

       end-proc;                                                             // prompt for flag

      **********************************************************************************************

       dcl-proc PromptNote export;                                           // prompt for note

       dcl-pi PromptNote like(EntNoteI.Value);                               // prompt for note
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntNoteI.Value) const options(*nopass);             // default value
       end-pi;                                                               // prompt for note

       dcl-f std5250utl workstn include(PromptNote);                         // pop-up window
       dcl-ds PromptNoteX likerec(PromptNote:*all) inz;                      // pop-up record

       dcl-s Note4Lin char(254) based(nPtr);                                 // four lines combined
       dcl-s nPtr pointer inz(%addr(PromptNoteX.NoteVal1));                  // ..starts at 1st line

       PromptNoteX.NoteTxt = PromptText;                                     // text for prompt
       PromptNoteX.NoteTxt = %scanrpl('  ' : ' .' : PromptNoteX.NoteTxt :
                                      1 + %len(%trim(PromptNoteX.NoteTxt))); // add dotted line

       if %parms >= 3;                                                       // if default value
         Note4Lin = DftValue;                                                // show in window
       endif;                                                                // if default value

       dou Note4Lin <> *blank or
             (%parms >= 3 and Required = 'N');                               // until valid note
         exfmt PromptNote PromptNoteX;                                       // show pop-up window
         evalr PromptNoteX.NoteErr = 'REQUIRED';                             // text for 2nd pop
       enddo;                                                                // until valid note

       return Note4Lin;                                                      // four lines combined

       end-proc;                                                             // prompt for note

      **********************************************************************************************

       dcl-proc PromptNumb export;                                           // prompt for number

       dcl-pi PromptNumb like(EntNumbI.Value);                               // prompt for number
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntNumbI.Value) const options(*nopass);             // default value
       end-pi;                                                               // prompt for number

       dcl-f std5250utl workstn include(PromptNumb);                         // pop-up window
       dcl-ds PromptNumbX likerec(PromptNumb:*all) inz;                      // pop-up record

       PromptNumbX.NumbTxt = PromptText;                                     // text for prompt
       PromptNumbX.NumbTxt = %scanrpl('  ' : ' .' : PromptNumbX.NumbTxt :
                                      1 + %len(%trim(PromptNumbX.NumbTxt))); // add dotted line

       if %parms >= 3;                                                       // if default value
         PromptNumbX.NumbVal = DftValue;                                     // show in window
       endif;                                                                // if default value

       dou PromptNumbX.NumbVal <> 0 or
             (%parms >= 3 and Required = 'N');                               // until valid number
         exfmt PromptNumb PromptNumbX;                                       // show pop-up window
         evalr PromptNumbX.NumbErr = 'REQUIRED';                             // text for 2nd pop
       enddo;                                                                // until valid number

       return PromptNumbX.NumbVal;                                           // user specified value

       end-proc;                                                             // prompt for number

      **********************************************************************************************
