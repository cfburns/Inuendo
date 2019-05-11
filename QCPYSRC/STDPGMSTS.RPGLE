      **********************************************************************************************
      *                                                                                            *
      *  STANDARD PROGRAM STATUS DATA STRUCTURE DEFINITION.                                        *
      *                                                                                            *
      *  Copyright (C) 2012, 2019  Christopher F. Burns Sr.                                        *
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

       dcl-ds pgmsts psds qualified;                                         // program status d/s
         pgmnam *proc;                                                       // program name
         pgmlib char(10) pos(81);                                            // program library
         jobnam char(10) pos(244);                                           // job name
         usrprf char(10) pos(254);                                           // orig user profile
         jobnum char(6)  pos(264);                                           // job number
         curusr char(10) pos(358);                                           // curr user profile
       end-ds;                                                               // program status d/s

