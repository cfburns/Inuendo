      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - USER SPACE API'S (PROTOTYPES & STORAGE)                     *
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

       dcl-pr CrtUsrSpc extpgm('QUSCRTUS');                                  // create user space
         QualName like(UsrSpcQual) const;                                    // qualified name
         ExtnAttr char(10) const;                                            // extended attribute
         InitSize int(10)  const;                                            // initial size
         InitValu char(1)  const;                                            // initial value
         PublAuth char(10) const;                                            // public authority
         TextDesc char(50) const;                                            // text description
         ReplOptn char(10) const;                                            // replace option
         ErroCode like(ErrorCode);                                           // error code
       end-pr;                                                               // create user space

       dcl-pr ChgUsrSpc extpgm('QUSCHGUS');                                  // change user space
         QualName like(UsrSpcQual) const;                                    // qualified name
         StrtPosn int(10)  const;                                            // starting position
         LengData int(10)  const;                                            // length of data
         InptData like(UsrSpcData) const;                                    // input data
         ForcAuxl char(1)  const;                                            // force to aux storage
         ErroCode like(ErrorCode);                                           // error code
       end-pr;                                                               // change user space

       dcl-pr RtvUsrSpc extpgm('QUSRTVUS');                                  // retrieve user space
         QualName like(UsrSpcQual) const;                                    // qualified name
         StrtPosn int(10) const;                                             // starting position
         LengData int(10) const;                                             // length of data
         RecvVari like(UsrSpcData);                                          // receiver variable
         ErroCode like(ErrorCode);                                           // error code
       end-pr;                                                               // retrieve user space

       dcl-pr RtvPtrSpc extpgm('QUSPTRUS');                                  // rtv ptr to user spc
         QualName like(UsrSpcQual) const;                                    // qualified name
         RetnAddr pointer;                                                   // return address
         ErroCode like(ErrorCode);                                           // error code
       end-pr;                                                               // rtv ptr to user spc

       dcl-pr DltUsrSpc extpgm('QUSDLTUS');                                  // delete user space
         QualName like(UsrSpcQual) const;                                    // qualified name
         ErroCode like(ErrorCode);                                           // error code
       end-pr;                                                               // delete user space

       dcl-ds UsrSpcQual qualified;                                          // qualfied name
         Object  char(10);                                                   // object name
         Library char(10);                                                   // library name
       end-ds;                                                               // qualfied name

       dcl-s UsrSpcData char(50);                                            // user space data fld

