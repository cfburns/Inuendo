/******************************************************************************/
/*                                                                            */
/*  Inuendo 1.2 (Alpha release) - INSTALLATION COMMAND                        */
/*                                                                            */
/*  Copyright (C) 2012, 2017  Christopher F. Burns Sr.                        */
/*    c/o The Inuendo Project (http://inuendo.us).                            */
/*                                                                            */
/*  This program is free software: you can redistribute it and/or modify      */
/*  it under the terms of the GNU General Public License as published by      */
/*  the Free Software Foundation, either version 3 of the License, or         */
/*  (at your option) any later version.                                       */
/*                                                                            */
/*  This program is distributed in the hope that it will be useful,           */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of            */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             */
/*  GNU General Public License for more details.                              */
/*                                                                            */
/*  You should have received a copy of the GNU General Public License         */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.     */
/*                                                                            */
/******************************************************************************/

             CMD        PROMPT('Install Inuendo Database')

             PARM       KWD(OBJLIB) TYPE(*NAME) MIN(1) +
                          PROMPT('Object Library')

             PARM       KWD(DTALIB) TYPE(*NAME) REL(*NE OBJLIB) +
                          MIN(1) PROMPT('Data Library')

             PARM       KWD(USRPRF) TYPE(*NAME) MIN(1) PROMPT('Owner +
                          User Profile')

             PARM       KWD(PASPHR) TYPE(*CHAR) LEN(64) MIN(1) +
                          FULL(*YES) PROMPT('AES Encryption +
                          Passphrase')

             PARM       KWD(ENBJRN) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Enable +
                          Journaling')

