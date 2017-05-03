      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD CRYPTOGRAPHY FUNCTIONS                             *
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

       ctl-opt
         nomain
         ccsid(*char:*jobrun);                                               // special h-specs

      /copy qcpysrc,stdcrypfnc                                               // protytpes, work stg

      **********************************************************************************************
      *  ENCRYPTION
      **********************************************************************************************

       dcl-proc Encrypt export;                                              // encrypt a string

       dcl-pi Encrypt like(EntNotxC.Value);                                  // encrypt a string
         PlainString like(EntNoteC.Value) const;                             // plain text string
       end-pi;                                                               // encrypt a string

       dcl-s EncryptedString like(EntNotxC.Value);                           // encrypted string

       exec sql
         set :EncryptedString = encrypt_aes(:PlainString,
PASS        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
           );                                                                // apply encryption

       return EncryptedString;                                               // encrypted string

       end-proc;                                                             // encrypt a string


      **********************************************************************************************
      *  DECRYPTION
      **********************************************************************************************

       dcl-proc Decrypt export;                                              // decrypt a string

       dcl-pi Decrypt like(EntNoteC.Value);                                  // decrypt a string
         EncryptedString like(EntNotxC.Value) const;                         // encrypted string
       end-pi;                                                               // decrypt a string

       dcl-s PlainString like(EntNoteC.Value);                               // plain text string

       exec sql
         set :PlainString =
            decrypt_char(cast(:EncryptedString as varchar(510) for bit data),
PASS        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
           );                                                                // apply decryption

       return PlainString;                                                   // plain text string

       end-proc;                                                             // decrypt a string

      **********************************************************************************************
