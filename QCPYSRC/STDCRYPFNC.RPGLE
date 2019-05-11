      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD CRYPTOGRAPHY FUNCTIONS                             *
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


      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntNoteC ext extname('ENTNOTE') qualified template end-ds;     // record template
       dcl-ds EntNumbC ext extname('ENTNUMB') qualified template end-ds;     // record template
       dcl-ds EntNotxC ext extname('ENTNOTX') qualified template end-ds;     // record template
       dcl-ds EntNumxC ext extname('ENTNUMX') qualified template end-ds;     // record template
       dcl-ds EntDatxC ext extname('ENTDATX') qualified template end-ds;     // record template


      **********************************************************************************************
      *  ENCRYPTION
      **********************************************************************************************

       dcl-pr Encrypt like(EntNotxC.Value);                                  // encrypt a string
         PlainString like(EntNoteC.Value) const;                             // plain text string
       end-pr;                                                               // encrypt a string


      **********************************************************************************************
      *  DECRYPTION
      **********************************************************************************************

       dcl-pr Decrypt like(EntNoteC.Value);                                  // decrypt a string
         EncryptedString like(EntNotxC.Value) const;                         // encrypted string
       end-pr;                                                               // decrypt a string

      **********************************************************************************************
