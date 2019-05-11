      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 - STANDARD 5250 UTILITIES                                                     *
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

      **********************************************************************************************
      *  POP-UP WINDOW PROMPTS FOR VARIOUS DATA TYPES.
      **********************************************************************************************

       dcl-pr PromptDate like(EntDateI.Value);                               // prompt for date
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntDateI.Value) const options(*nopass);             // default value
       end-pr;                                                               // prompt for date

       dcl-pr PromptFlag like(EntFlagI.Value);                               // prompt for flag
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntFlagI.Value) const options(*nopass);             // default value
       end-pr;                                                               // prompt for flag

       dcl-pr PromptNote like(EntNoteI.Value);                               // prompt for note
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntNoteI.Value) const options(*nopass);             // default value
       end-pr;                                                               // prompt for note

       dcl-pr PromptNumb like(EntNumbI.Value);                               // prompt for number
         PromptText like(EntNoteI.Value) const;                              // text for prompt
         Required   like(EntFlagI.Value) const options(*nopass);             // required entry
         DftValue   like(EntNumbI.Value) const options(*nopass);             // default value
       end-pr;                                                               // prompt for number

