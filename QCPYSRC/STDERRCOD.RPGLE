      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ERROR CODE FOR IBM SUPPLIED API'S                  *
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

       dcl-ds ErrorCode qualified;                                           // error code
         BytPrv int(10) inz(%len(ErrorCode));                                // bytes provided
         BytAvl int(10) inz;                                                 // bytes available
         MsgCod char(7);                                                     // message code
         NotUsd char(1);                                                     // not used
         MsgDta char(64);                                                    // message data
       end-ds;                                                               // error code

