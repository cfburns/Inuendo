      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - SYNCHRONIZE CUSTOMER ENTITIES (SAMPLE)                      *
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
      *                                                                                            *
      *  ESTABLISH TRIGGER ON "CUSMS" FOR INSERT, DELETE AND UPDATE EVENTS, EACH CALLING THIS      *
      *    PROGRAM.  KEEPS "ENTHEAD" IN SYNCH WITH "CUSMS".                                        *
      *                                                                                            *
      *  COMMANDS:                                                                                 *
      *    ADDPFTRG FILE(CUSMS) TRGTIME(*AFTER) TRGEVENT(*INSERT) PGM(SYNCUST) TRG(SYNCUSTI)       *
      *    ADDPFTRG FILE(CUSMS) TRGTIME(*AFTER) TRGEVENT(*DELETE) PGM(SYNCUST) TRG(SYNCUSTD)       *
      *    ADDPFTRG FILE(CUSMS) TRGTIME(*AFTER) TRGEVENT(*UPDATE) PGM(SYNCUST) TRG(SYNCUSTU)       *
      *                                                                                            *
      **********************************************************************************************


      /copy qcpysrc,stdhpgm                                                  // std h-specs for pgm

       dcl-ds imgbef extname('CUSMS') qualified based(bp) end-ds;            // record image before
       dcl-ds imgaft extname('CUSMS') qualified based(ap) end-ds;            // record image after

       dcl-s AddressID   like(EntHeadO.EntityID);                            // address entity ID
       dcl-s AddrBookID  like(EntHeadO.EntityID);                            // addr book entity ID
       dcl-s CompanyID   like(EntHeadO.EntityID);                            // company entity ID
       dcl-s CustomerID  like(EntHeadO.EntityID);                            // customer entity ID
       dcl-s CustClassID like(EntHeadO.EntityID);                            // cust cls entity ID
       dcl-s TransID     like(EntHeadO.EntityID);                            // incremental trans ID
       dcl-s PhoneID     like(EntHeadO.EntityID);                            // phone trans ID

       dcl-s ThisPerdStart date;                                             // this perd start date
       dcl-s LastPerdStart date;                                             // last perd start date
       dcl-s PrevPerdStart date;                                             // prev perd start date

       dcl-s ThisYearStart date;                                             // this year start date
       dcl-s LastYearStart date;                                             // last year start date
       dcl-s PrevYearStart date;                                             // prev year start date

       dcl-s FirstSyn ind;                                                   // 1st synch for cust

      /copy qcpysrc,stdentinp                                                // std input funcs
      /copy qcpysrc,stdentout                                                // std output funcs
      /copy qcpysrc,stdtrghdr                                                // std trigger header

       // Customer is subordinate to Company, so the Company must be identified first.
       // Certain things must happen only the first time the Customer is synchronized.

       CompanyID  = newEntityN(  FounderID : 'COMPANY'  : imgaft.cmcono);    // company entity ID
       CustomerID = getEntityIDn(CompanyID : 'CUSTOMER' : imgaft.cmcsno);    // customer entity ID

       if CustomerID = 0;                                                    // if no cust entity
         FirstSyn = *on;                                                     // set 1st synch flag
         CustomerID = newEntityN(CompanyID : 'CUSTOMER' : imgaft.cmcsno
                                                        : imgaft.cmcsnm);    // customer entity ID
       endif;                                                                // if no cust entity

       if TrigBuffer.EventCode = '2';                                        // if delete event
         putStatus(CustomerID : 'D');                                        // flag as disabled
         return;                                                             // end altogether
       elseif TrigBuffer.EventCode = '3';                                    // or update event
         putDescriptor(CustomerID : imgaft.cmcsnm);                          // customer name
       endif;                                                                // if delete event

       // Bill to address will be a separate entity of the ADDRESS class, subordinate to
       //   an ADDRBOOK entity.  We gave the address book a legacy numeric ID of 1 just for kicks.
       //   Note the ADDRESS entity is created only if it doesn't exist yet.  COUNTRY and STATE
       //   entities exist already, as they were created in the STATE synchronizaiton trigger.

       AddrBookID = newEntityN(CompanyID : 'ADDRBOOK' : 1);                  // address book ID
       AddressID  = getLink(CustomerID:'BILLTO');                            // get address ID

       if AddressID = 0;                                                     // if no address yet
         AddressID = newEntityA(AddrBookID : 'ADDRESS' : ' ');               // address entity ID
         putLink(CustomerID : 'BILLTO' : AddressID);                         // put link value
       endif;                                                                // if no address yet

       putNote(AddressID : 'LINE1'   : imgaft.cmcad1);                       // address line 1
       putNote(AddressID : 'LINE2'   : imgaft.cmcad2);                       // address line 2
       putNote(AddressID : 'LINE3'   : imgaft.cmcad3);                       // address line 3
       putNote(AddressID : 'LINE4'   : imgaft.cmcad4);                       // address line 4
       putNote(AddressID : 'CITY'    : imgaft.cmcity);                       // city name
       putLink(AddressID : 'STATE'   :
                 getEntityIDa(FounderID:'STATE':imgaft.cmstat));             // state entity ID
       putNote(AddressID : 'ZIP'     : imgaft.cmzip4);                       // postal code
       putLink(AddressID : 'COUNTRY' :
                 getEntityIDa(FounderID:'COUNTRY':imgaft.cmctid));           // country entity ID

       // Purchasing phone number will be a separate entity of the PHONE class, subordinate to
       //   a CUSTOMER entity.  Note the PHONE entity is created if it doesn't exist yet.

       if FirstSyn or imgaft.cmpccd <> imgbef.cmpccd
                   or imgaft.cmpuar <> imgbef.cmpuar
                   or imgaft.cmpuph <> imgbef.cmpuph
                   or imgaft.cmpoex <> imgbef.cmpoex
                   or imgaft.cmpcnt <> imgbef.cmpcnt;                        // if field changes

         PhoneID = getLink(CustomerID : 'PURCHASING');                       // existing entity ID

         if PhoneID = 0;                                                     // if no phone entity
           PhoneID = newEntityN(CustomerID : 'PHONE' : 0 : imgaft.cmpcnt);   // new phone entity
           putLink(CustomerID : 'PURCHASING' : PhoneID);                     // phone entity link
         else;                                                               // entity exists
           putDescriptor(PhoneID : imgaft.cmpcnt);                           // update descriptor
         endif;                                                              // if no phone entity

         putNote(PhoneID : 'COUNTRY'   : imgaft.cmpccd);                     // country code
         putNumb(PhoneID : 'AREA'      : imgaft.cmpuar);                     // area code
         putNumb(PhoneID : 'PREFIX'    : %div(imgaft.cmpuph:10000));         // 3 digit exchange
         putNumb(PhoneID : 'LINE'      : %rem(imgaft.cmpuph:10000));         // 4 digit line number
         putNumb(PhoneID : 'EXTENSION' : imgaft.cmpoex);                     // extension number

       endif;                                                                // if field changes

       // Accounts payable phone number will be a separate entity of the PHONE class, subordinate to
       //   a CUSTOMER entity.  Note the PHONE entity is created if it doesn't exist yet.

       if FirstSyn or imgaft.cmaccd <> imgbef.cmaccd
                   or imgaft.cmapar <> imgbef.cmapar
                   or imgaft.cmapph <> imgbef.cmapph
                   or imgaft.cmapex <> imgbef.cmapex
                   or imgaft.cmcont <> imgbef.cmcont;                        // if field changes

         PhoneID = getLink(CustomerID : 'ACCTPAYABLE');                      // existing entity ID

         if PhoneID = 0;                                                     // if no phone entity
           PhoneID = newEntityN(CustomerID : 'PHONE' : 0 : imgaft.cmcont);   // new phone entity
           putLink(CustomerID : 'ACCTPAYABLE' : PhoneID);                    // phone entity link
         else;                                                               // entity exists
           putDescriptor(PhoneID : imgaft.cmcont);                           // update descriptor
         endif;                                                              // if no phone entity

         putNote(PhoneID : 'COUNTRY'   : imgaft.cmaccd);                     // country code
         putNumb(PhoneID : 'AREA'      : imgaft.cmapar);                     // area code
         putNumb(PhoneID : 'PREFIX'    : %div(imgaft.cmapph:10000));         // 3 digit exchange
         putNumb(PhoneID : 'LINE'      : %rem(imgaft.cmapph:10000));         // 4 digit line number
         putNumb(PhoneID : 'EXTENSION' : imgaft.cmapex);                     // extension number

       endif;                                                                // if field changes

       // Accounts payable fax number will be a separate entity of the PHONE class, subordinate to
       //   a CUSTOMER entity.  Note the PHONE entity is created if it doesn't exist yet.

       if FirstSyn or imgaft.cmfxcd <> imgbef.cmfxcd
                   or imgaft.cmfxac <> imgbef.cmfxac
                   or imgaft.cmfxph <> imgbef.cmfxph
                   or imgaft.cmfxex <> imgbef.cmfxex;                        // if field changes

         PhoneID = getLink(CustomerID : 'FAX');                              // existing entity ID

         if PhoneID = 0;                                                     // if no phone entity
           PhoneID = newEntityN(CustomerID : 'PHONE' : 0 : 'FAX');           // new phone entity
           putLink(CustomerID : 'FAX' : PhoneID);                            // phone entity link
         endif;                                                              // if no phone entity

         putNote(PhoneID : 'COUNTRY'   : imgaft.cmfxcd);                     // country code
         putNumb(PhoneID : 'AREA'      : imgaft.cmfxac);                     // area code
         putNumb(PhoneID : 'PREFIX'    : %div(imgaft.cmfxph:10000));         // 3 digit exchange
         putNumb(PhoneID : 'LINE'      : %rem(imgaft.cmfxph:10000));         // 4 digit line number
         putNumb(PhoneID : 'EXTENSION' : imgaft.cmfxex);                     // extension number

       endif;                                                                // if field changes

       // Dates are in numeric YYMMDD format in the legacy file.  On a first synchronization,
       //   they will be output only if they are non-zero.

       if FirstSyn and imgaft.cmeced > 0
       or imgaft.cmeced <> imgbef.cmeced;                                    // if field changes
         putDateN(CustomerID : 'CERTEXPIRE'    : imgaft.cmeced : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmlpdt > 0
       or imgaft.cmlpdt <> imgbef.cmlpdt;                                    // if field changes
         putDateN(CustomerID : 'LASTPAYMENT'   : imgaft.cmlpdt : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfsdt > 0
       or imgaft.cmfsdt <> imgbef.cmfsdt;                                    // if field changes
         putDateN(CustomerID : 'FIRSTSALE'     : imgaft.cmfsdt : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmlsdt > 0
       or imgaft.cmlsdt <> imgbef.cmlsdt;                                    // if field changes
         putDateN(CustomerID : 'LASTSALE'      : imgaft.cmlsdt : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcrrp > 0
       or imgaft.cmcrrp <> imgbef.cmcrrp;                                    // if field changes
         putDateN(CustomerID : 'LASTCREDREPT'  : imgaft.cmcrrp : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmnxrv > 0
       or imgaft.cmnxrv <> imgbef.cmnxrv;                                    // if field changes
         putDateN(CustomerID : 'NEXTREVIEW'    : imgaft.cmnxrv : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmlcnd > 0
       or imgaft.cmlcnd <> imgbef.cmlcnd;                                    // if field changes
         putDateN(CustomerID : 'LAST CONTACT'  : imgaft.cmlcnd : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmhcdt > 0
       or imgaft.cmhcdt <> imgbef.cmhcdt;                                    // if field changes
         putDateN(CustomerID : 'HIGHCREDIT'    : imgaft.cmhcdt : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcadt > 0
       or imgaft.cmcadt <> imgbef.cmcadt;                                    // if field changes
         putDateN(CustomerID : 'ADDED'         : imgaft.cmcadt : '*YMD');    // put date to subtable
       endif;                                                                // if field changes

       // Flags are simply one byte characters in the legacy file.  On a first synchronization,
       //   they will be output only if they are non-blank.

       if FirstSyn and imgaft.cmprti > *blank
       or imgaft.cmprti <> imgbef.cmprti;                                    // if field changes
         putFlag(CustomerID : 'PRINTINVOICE'   : imgaft.cmprti);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmprta > *blank
       or imgaft.cmprta <> imgbef.cmprta;                                    // if field changes
         putFlag(CustomerID : 'PRINTACK'       : imgaft.cmprta);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmprtr > *blank
       or imgaft.cmprtr <> imgbef.cmprtr;                                    // if field changes
         putFlag(CustomerID : 'PRINTSTATEMENT' : imgaft.cmprtr);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmprtd > *blank
       or imgaft.cmprtd <> imgbef.cmprtd;                                    // if field changes
         putFlag(CustomerID : 'PRINTLETTER'    : imgaft.cmprtd);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmprtq > *blank
       or imgaft.cmprtq <> imgbef.cmprtq;                                    // if field changes
         putFlag(CustomerID : 'PRINTQUOTE'     : imgaft.cmprtq);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmemin > *blank
       or imgaft.cmemin <> imgbef.cmemin;                                    // if field changes
         putFlag(CustomerID : 'EMAILINVOICE'   : imgaft.cmemin);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmemak > *blank
       or imgaft.cmemak <> imgbef.cmemak;                                    // if field changes
         putFlag(CustomerID : 'EMAILACK'       : imgaft.cmemak);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmemsm > *blank
       or imgaft.cmemsm <> imgbef.cmemsm;                                    // if field changes
         putFlag(CustomerID : 'EMAILSTATEMENT' : imgaft.cmemsm);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmemdl > *blank
       or imgaft.cmemdl <> imgbef.cmemdl;                                    // if field changes
         putFlag(CustomerID : 'EMAILLETTER'    : imgaft.cmemdl);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmemqr > *blank
       or imgaft.cmemqr <> imgbef.cmemqr;                                    // if field changes
         putFlag(CustomerID : 'EMAILQUOTE'     : imgaft.cmemqr);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfxin > *blank
       or imgaft.cmfxin <> imgbef.cmfxin;                                    // if field changes
         putFlag(CustomerID : 'FAXINVOICE'     : imgaft.cmfxin);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfxak > *blank
       or imgaft.cmfxak <> imgbef.cmfxak;                                    // if field changes
         putFlag(CustomerID : 'FAXACK'         : imgaft.cmfxak);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfxsm > *blank
       or imgaft.cmfxsm <> imgbef.cmfxsm;                                    // if field changes
         putFlag(CustomerID : 'FAXSTATEMENT'   : imgaft.cmfxsm);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfxdl > *blank
       or imgaft.cmfxdl <> imgbef.cmfxdl;                                    // if field changes
         putFlag(CustomerID : 'FAXLETTER'      : imgaft.cmfxdl);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfxqr > *blank
       or imgaft.cmfxqr <> imgbef.cmfxqr;                                    // if field changes
         putFlag(CustomerID : 'FAXQUOTE'       : imgaft.cmfxqr);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmeiin > *blank
       or imgaft.cmeiin <> imgbef.cmeiin;                                    // if field changes
         putFlag(CustomerID : 'EDIINVOICE'     : imgaft.cmeiin);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmeiak > *blank
       or imgaft.cmeiak <> imgbef.cmeiak;                                    // if field changes
         putFlag(CustomerID : 'EDIACK'         : imgaft.cmeiak);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmeias > *blank
       or imgaft.cmeias <> imgbef.cmeias;                                    // if field changes
         putFlag(CustomerID : 'EDIASN'         : imgaft.cmeias);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmeiih > *blank
       or imgaft.cmeiih <> imgbef.cmeiih;                                    // if field changes
         putFlag(CustomerID : 'HOLDEDIINVOICE' : imgaft.cmeiih);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmeiah > *blank
       or imgaft.cmeiah <> imgbef.cmeiah;                                    // if field changes
         putFlag(CustomerID : 'HOLDEDIACK'     : imgaft.cmeiah);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmeash > *blank
       or imgaft.cmeash <> imgbef.cmeash;                                    // if field changes
         putFlag(CustomerID : 'HOLDEDIASN'     : imgaft.cmeash);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmebin > *blank
       or imgaft.cmebin <> imgbef.cmebin;                                    // if field changes
         putFlag(CustomerID : 'EBILLINVOICE'   : imgaft.cmebin);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmebsm > *blank
       or imgaft.cmebsm <> imgbef.cmebsm;                                    // if field changes
         putFlag(CustomerID : 'EBILLSTATEMENT' : imgaft.cmebsm);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmporq > *blank
       or imgaft.cmporq <> imgbef.cmporq;                                    // if field changes
         putFlag(CustomerID : 'POREQUIRED'     : imgaft.cmporq);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfetc > *blank
       or imgaft.cmfetc <> imgbef.cmfetc;                                    // if field changes
         putFlag(CustomerID : 'FEDEXCISETAX'   : imgaft.cmfetc);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtxcd > *blank
       or imgaft.cmtxcd <> imgbef.cmtxcd;                                    // if field changes
         putFlag(CustomerID : 'TAXABLE'        : imgaft.cmtxcd);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfnch > *blank
       or imgaft.cmfnch <> imgbef.cmfnch;                                    // if field changes
         putFlag(CustomerID : 'LATECHARGES'    : imgaft.cmfnch);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmbfoi > *blank
       or imgaft.cmbfoi <> imgbef.cmbfoi;                                    // if field changes
         putFlag(CustomerID : 'FORWARDOROPEN'  : imgaft.cmbfoi);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmshcd > *blank
       or imgaft.cmshcd <> imgbef.cmshcd;                                    // if field changes
         putFlag(CustomerID : 'SALESHISTORY'   : imgaft.cmshcd);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmsusp > *blank
       or imgaft.cmsusp <> imgbef.cmsusp;                                    // if field changes
         putFlag(CustomerID : 'SUSPEND'        : imgaft.cmsusp);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcibo > *blank
       or imgaft.cmcibo <> imgbef.cmcibo;                                    // if field changes
         putFlag(CustomerID : 'CREDEXCLUDEBO'  : imgaft.cmcibo);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmciso > *blank
       or imgaft.cmciso <> imgbef.cmciso;                                    // if field changes
         putFlag(CustomerID : 'CREDEXCLUDESO'  : imgaft.cmciso);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmacbo > *blank
       or imgaft.cmacbo <> imgbef.cmacbo;                                    // if field changes
         putFlag(CustomerID : 'ACCEPTBO'       : imgaft.cmacbo);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtdcd > *blank
       or imgaft.cmtdcd <> imgbef.cmtdcd;                                    // if field changes
         putFlag(CustomerID : 'TRADEDISCOUNT'  : imgaft.cmtdcd);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmexdf > *blank
       or imgaft.cmexdf <> imgbef.cmexdf;                                    // if field changes
         putFlag(CustomerID : 'EXTDESC'        : imgaft.cmexdf);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmaspk > *blank
       or imgaft.cmaspk <> imgbef.cmaspk;                                    // if field changes
         putFlag(CustomerID : 'ASNPACKINFO'    : imgaft.cmaspk);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmitdp > *blank
       or imgaft.cmitdp <> imgbef.cmitdp;                                    // if field changes
         putFlag(CustomerID : 'ITEMDESCPRINT'  : imgaft.cmitdp);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmazsh > *blank
       or imgaft.cmazsh <> imgbef.cmazsh;                                    // if field changes
         putFlag(CustomerID : 'ZEROSHIP'       : imgaft.cmazsh);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmckrs > *blank
       or imgaft.cmckrs <> imgbef.cmckrs;                                    // if field changes
         putFlag(CustomerID : 'CHECKRESTRICT'  : imgaft.cmckrs);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmmsds > *blank
       or imgaft.cmmsds <> imgbef.cmmsds;                                    // if field changes
         putFlag(CustomerID : 'SENDMSDS'       : imgaft.cmmsds);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmpppl > *blank
       or imgaft.cmpppl <> imgbef.cmpppl;                                    // if field changes
         putFlag(CustomerID : 'PRICEPICK'      : imgaft.cmpppl);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmprst > *blank
       or imgaft.cmprst <> imgbef.cmprst;                                    // if field changes
         putFlag(CustomerID : 'STATEMENTS'     : imgaft.cmprst);             // put flag to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmshto > *blank
       or imgaft.cmshto <> imgbef.cmshto;                                    // if field changes
         putFlag(CustomerID : 'SHIPTOEXIST'    : imgaft.cmshto);             // put flag to subtable
       endif;                                                                // if field changes

       // Notes are simply character fields in the legacy file.  On a first synchronization,
       //   they will be output only if they are non-blank.

       if FirstSyn and imgaft.cmnknm > *blanks
       or imgaft.cmnknm <> imgbef.cmnknm;                                    // if field changes
         putNote(CustomerID : 'NICKNAME'       : imgaft.cmnknm);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmus5a > *blanks
       or imgaft.cmus5a <> imgbef.cmus5a;                                    // if field changes
         putNote(CustomerID : 'USERFIELD1'     : imgaft.cmus5a);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmus5b > *blanks
       or imgaft.cmus5b <> imgbef.cmus5b;                                    // if field changes
         putNote(CustomerID : 'USERFIELD2'     : imgaft.cmus5b);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmus5c > *blanks
       or imgaft.cmus5c <> imgbef.cmus5c;                                    // if field changes
         putNote(CustomerID : 'USERFIELD3'     : imgaft.cmus5c);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmus5d > *blanks
       or imgaft.cmus5d <> imgbef.cmus5d;                                    // if field changes
         putNote(CustomerID : 'USERFIELD4'     : imgaft.cmus5d);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmus5e > *blanks
       or imgaft.cmus5e <> imgbef.cmus5e;                                    // if field changes
         putNote(CustomerID : 'USERFIELD5'     : imgaft.cmus5e);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmus5f > *blanks
       or imgaft.cmus5f <> imgbef.cmus5f;                                    // if field changes
         putNote(CustomerID : 'USERFIELD6'     : imgaft.cmus5f);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmsicc > *blanks
       or imgaft.cmsicc <> imgbef.cmsicc;                                    // if field changes
         putNote(CustomerID : 'SIC'            : imgaft.cmsicc);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmerpi > *blanks
       or imgaft.cmerpi <> imgbef.cmerpi;                                    // if field changes
         putNote(CustomerID : 'ERPSYSTEMID'    : imgaft.cmerpi);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmictc > *blanks
       or imgaft.cmictc <> imgbef.cmictc;                                    // if field changes
         putNote(CustomerID : 'ICTERMS'        : imgaft.cmictc);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmnmpp > *blanks
       or imgaft.cmnmpp <> imgbef.cmnmpp;                                    // if field changes
         putNote(CustomerID : 'ICTERMSPLACE'   : imgaft.cmnmpp);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcgid > *blanks
       or imgaft.cmcgid <> imgbef.cmcgid;                                    // if field changes
         putNote(CustomerID : 'EXTDESCGROUP'   : imgaft.cmcgid);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtpid > *blanks
       or imgaft.cmtpid <> imgbef.cmtpid;                                    // if field changes
         putNote(CustomerID : 'TRADPARTNER'    : imgaft.cmtpid);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmus30 > *blanks
       or imgaft.cmus30 <> imgbef.cmus30;                                    // if field changes
         putNote(CustomerID : 'USERAREA'       : imgaft.cmus30);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcsrt > *blanks
       or imgaft.cmcsrt <> imgbef.cmcsrt;                                    // if field changes
         putNote(CustomerID : 'SORTWORD'       : imgaft.cmcsrt);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmwhsq > *blanks
       or imgaft.cmwhsq <> imgbef.cmwhsq;                                    // if field changes
         putNote(CustomerID : 'WHSESEQ'        : imgaft.cmwhsq);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmusr1 > *blanks
       or imgaft.cmusr1 <> imgbef.cmusr1;                                    // if field changes
         putNote(CustomerID : 'USERCODE1'      : imgaft.cmusr1);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmusr2 > *blanks
       or imgaft.cmusr2 <> imgbef.cmusr2;                                    // if field changes
         putNote(CustomerID : 'USERCODE2'      : imgaft.cmusr2);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmusr3 > *blanks
       or imgaft.cmusr3 <> imgbef.cmusr3;                                    // if field changes
         putNote(CustomerID : 'USERCODE3'      : imgaft.cmusr3);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmrs03 > *blanks
       or imgaft.cmrs03 <> imgbef.cmrs03;                                    // if field changes
         putNote(CustomerID : 'RESERVED'       : imgaft.cmrs03);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmdshv > *blanks
       or imgaft.cmdshv <> imgbef.cmdshv;                                    // if field changes
         putNote(CustomerID : 'DFTSHIPVIA'     : imgaft.cmdshv);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmdmsn > *blanks
       or imgaft.cmdmsn <> imgbef.cmdmsn;                                    // if field changes
         putNote(CustomerID : 'DFTMISCNOTE'    : imgaft.cmdmsn);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmexno > *blanks
       or imgaft.cmexno <> imgbef.cmexno;                                    // if field changes
         putNotx(CustomerID : 'TAXCERT'        : imgaft.cmexno);             // put note to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cminus > *blanks
       or imgaft.cminus <> imgbef.cminus;                                    // if field changes
         putNote(CustomerID : 'INUSEWS'        : imgaft.cminus);             // put note to subtable
       endif;                                                                // if field changes

       // Numbers comprise any non-date zoned or packed decimal fields in the legacy file.
       //   On a first synchronization, they will be output only if they are non-zero.

       if FirstSyn and imgaft.cmsaid > 0
       or imgaft.cmsaid <> imgbef.cmsaid;                                    // if field changes
         putNumb(CustomerID : 'SATRANS'        : imgaft.cmsaid);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtp01 > 0
       or imgaft.cmtp01 <> imgbef.cmtp01;                                    // if field changes
         putNumb(CustomerID : 'TRANSID1'       : imgaft.cmtp01);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtp02 > 0
       or imgaft.cmtp02 <> imgbef.cmtp02;                                    // if field changes
         putNumb(CustomerID : 'TRANSID2'       : imgaft.cmtp02);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtp03 > 0
       or imgaft.cmtp03 <> imgbef.cmtp03;                                    // if field changes
         putNumb(CustomerID : 'TRANSID3'       : imgaft.cmtp03);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtp04 > 0
       or imgaft.cmtp04 <> imgbef.cmtp04;                                    // if field changes
         putNumb(CustomerID : 'TRANSID4'       : imgaft.cmtp04);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmwamd > 0
       or imgaft.cmwamd <> imgbef.cmwamd;                                    // if field changes
         putNumb(CustomerID : 'WGTAMTDUE'      : imgaft.cmwamd);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmrvdy > 0
       or imgaft.cmrvdy <> imgbef.cmrvdy;                                    // if field changes
         putNumb(CustomerID : 'REVIEWDAYS'     : imgaft.cmrvdy);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmstop > 0
       or imgaft.cmstop <> imgbef.cmstop;                                    // if field changes
         putNumb(CustomerID : 'STOP'           : imgaft.cmstop);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmarid > 0
       or imgaft.cmarid <> imgbef.cmarid;                                    // if field changes
         putNumb(CustomerID : 'ARTRANSID'      : imgaft.cmarid);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcrlm > 0
       or imgaft.cmcrlm <> imgbef.cmcrlm;                                    // if field changes
         putNumx(CustomerID : 'CREDITLIMIT'    : imgaft.cmcrlm);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmecrl > 0
       or imgaft.cmecrl <> imgbef.cmecrl;                                    // if field changes
         putNumb(CustomerID : 'EARLYWARNING'   : imgaft.cmecrl);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmwopc > 0
       or imgaft.cmwopc <> imgbef.cmwopc;                                    // if field changes
         putNumb(CustomerID : 'WRITEOFFPCT'    : imgaft.cmwopc);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmwoal > 0
       or imgaft.cmwoal <> imgbef.cmwoal;                                    // if field changes
         putNumb(CustomerID : 'WRITEOFFAMT'    : imgaft.cmwoal);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmomal > 0
       or imgaft.cmomal <> imgbef.cmomal;                                    // if field changes
         putNumb(CustomerID : 'ORDERMININUM'   : imgaft.cmomal);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmprbk > 0
       or imgaft.cmprbk <> imgbef.cmprbk;                                    // if field changes
         putNumb(CustomerID : 'PRICEBUCKET'    : imgaft.cmprbk);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtgpd > 0
       or imgaft.cmtgpd <> imgbef.cmtgpd;                                    // if field changes
         putNumb(CustomerID : 'TARGPYMTDAYS'   : imgaft.cmtgpd);             // put numb to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmhcam > 0
       or imgaft.cmhcam <> imgbef.cmhcam;                                    // if field changes
         putNumb(CustomerID : 'HIGHCREDITAMT'  : imgaft.cmhcam);             // put numb to subtable
       endif;                                                                // if field changes

       // Links are different animal.  Whenever a field in the legacy file has a limited number
       //   of possibilities, our best bet is to create a class for it.  That way, a new entity
       //   of that class will be created to represent each value encoutered in the file.  Then,
       //   a link property is created to point to that new entity.  On first synchronization,
       //   only non-blank or non-zero values are considered.

       if FirstSyn and imgaft.cmarcs > 0
       or imgaft.cmarcs <> imgbef.cmarcs;                                    // if field changes
         putLink(CustomerID : 'ARCUSTOMER'     :
                 newEntityN(CompanyID  : 'ARCUSTOMER'     : imgaft.cmarcs)); // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmhqcs > 0
       or imgaft.cmhqcs <> imgbef.cmhqcs;                                    // if field changes
         putLink(CustomerID : 'HQCUSTOMER'     :
                 newEntityN(CompanyID  : 'HQCUSTOMER'     : imgaft.cmhqcs)); // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmrp#1 > 0
       or imgaft.cmrp#1 <> imgbef.cmrp#1;                                    // if field changes
         putLink(CustomerID : 'SALESREP1'      :
                 newEntityN(CompanyID  : 'SALESREP'     : imgaft.cmrp#1));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmrp#2 > 0
       or imgaft.cmrp#2 <> imgbef.cmrp#2;                                    // if field changes
         putLink(CustomerID : 'SALESREP2'      :
                 newEntityN(CompanyID  : 'SALESREP'     : imgaft.cmrp#2));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmrp#3 > 0
       or imgaft.cmrp#3 <> imgbef.cmrp#3;                                    // if field changes
         putLink(CustomerID : 'SALESREP3'      :
                 newEntityN(CompanyID  : 'SALESREP'     : imgaft.cmrp#3));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmstor > *blanks
       or imgaft.cmstor <> imgbef.cmstor;                                    // if field changes
         putLink(CustomerID : 'STORE'          :
                 newEntityA(CompanyID  : 'STORE'        : imgaft.cmstor));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmgeoc > 0
       or imgaft.cmgeoc <> imgbef.cmgeoc;                                    // if field changes
         putLink(CustomerID : 'GEOCODE'        :
                 newEntityN(CompanyID  : 'GEOCODE'      : imgaft.cmgeoc));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmfobc > *blanks
       or imgaft.cmfobc <> imgbef.cmfobc;                                    // if field changes
         putLink(CustomerID : 'FOBCODE'        :
                 newEntityA(CompanyID  : 'FOBCODE'      : imgaft.cmfobc));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcrid > *blanks
       or imgaft.cmcrid <> imgbef.cmcrid;                                    // if field changes
         putLink(CustomerID : 'CORPGROUP'      :
                 newEntityA(CompanyID  : 'CORPGROUP'    : imgaft.cmcrid));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmdfsh > *blanks
       or imgaft.cmdfsh <> imgbef.cmdfsh;                                    // if field changes
         putLink(CustomerID : 'SHIPTO'         :
                 newEntityA(CustomerID : 'SHIPTO'       : imgaft.cmdfsh));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmdfwh > *blanks
       or imgaft.cmdfwh <> imgbef.cmdfwh;                                    // if field changes
         putLink(CustomerID : 'WAREHOUSE'      :
                 newEntityA(CompanyID  : 'WAREHOUSE'    : imgaft.cmdfwh));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmrout > *blanks
       or imgaft.cmrout <> imgbef.cmrout;                                    // if field changes
         putLink(CustomerID : 'ROUTE'          :
                 newEntityA(CompanyID  : 'ROUTE'        : imgaft.cmrout));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmpacd > *blanks
       or imgaft.cmpacd <> imgbef.cmpacd;                                    // if field changes
         putLink(CustomerID : 'PAYMENTCODE'    :
                 newEntityA(CompanyID  : 'PAYMENTCODE'  : imgaft.cmpacd));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcsgl > *blanks
       or imgaft.cmcsgl <> imgbef.cmcsgl;                                    // if field changes
         putLink(CustomerID : 'CUSTGLCODE'     :
                 newEntityA(CompanyID  : 'CUSTGLCODE'   : imgaft.cmcsgl));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcacd > *blanks
       or imgaft.cmcacd <> imgbef.cmcacd;                                    // if field changes
         putLink(CustomerID : 'CARRIER'        :
                 newEntityA(CompanyID  : 'CARRIER'      : imgaft.cmcacd));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmctxc > *blanks
       or imgaft.cmctxc <> imgbef.cmctxc;                                    // if field changes
         putLink(CustomerID : 'TAXCLASS'       :
                 newEntityA(CompanyID  : 'TAXCLASS'     : imgaft.cmctxc));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmrbcl > *blanks
       or imgaft.cmrbcl <> imgbef.cmrbcl;                                    // if field changes
         putLink(CustomerID : 'REBATECLASS'    :
                 newEntityA(CompanyID  : 'REBATECLASS'  : imgaft.cmrbcl));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmagcd > *blanks
       or imgaft.cmagcd <> imgbef.cmagcd;                                    // if field changes
         putLink(CustomerID : 'ARAGING'        :
                 newEntityA(CompanyID  : 'ARAGING'      : imgaft.cmagcd));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtmcd > *blanks
       or imgaft.cmtmcd <> imgbef.cmtmcd;                                    // if field changes
         putLink(CustomerID : 'ARTERMS'        :
                 newEntityA(CompanyID  : 'ARTERMS'      : imgaft.cmtmcd));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmprds > 0
       or imgaft.cmprds <> imgbef.cmprds;                                    // if field changes
         putLink(CustomerID : 'PRICEDISC'      :
                 newEntityN(CompanyID  : 'PRICEDISC'    : imgaft.cmprds));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmarrp > *blanks
       or imgaft.cmarrp <> imgbef.cmarrp;                                    // if field changes
         putLink(CustomerID : 'ARCALLREP'      :
                 newEntityA(CompanyID  : 'ARCALLREP'    : imgaft.cmarrp));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcsct > *blanks
       or imgaft.cmcsct <> imgbef.cmcsct;                                    // if field changes
         putLink(CustomerID : 'CUSTCONTRACT'   :
                 newEntityA(CompanyID  : 'CUSTCONTRACT' : imgaft.cmcsct));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcbcd > *blanks
       or imgaft.cmcbcd <> imgbef.cmcbcd;                                    // if field changes
         putLink(CustomerID : 'CONSBILL'       :
                 newEntityA(CompanyID  : 'CONSBILL'     : imgaft.cmcbcd));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmcscm > 0
       or imgaft.cmcscm <> imgbef.cmcscm;                                    // if field changes
         putLink(CustomerID : 'CUSTCOMMIT'     :
                 newEntityN(CompanyID  : 'CUSTCOMMIT'   : imgaft.cmcscm));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtxbd > *blanks
       or imgaft.cmtxbd <> imgbef.cmtxbd;                                    // if field changes
         putLink(CustomerID : 'TAXBODY'        :
                 newEntityA(CompanyID  : 'TAXBODY'      : imgaft.cmtxbd));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmhlmx > *blanks
       or imgaft.cmhlmx <> imgbef.cmhlmx;                                    // if field changes
         putLink(CustomerID : 'HOLDMATRIX'     :
                 newEntityA(CompanyID  : 'HOLDMATRIX'   : imgaft.cmhlmx));   // put link to subtable
       endif;                                                                // if field changes

       if FirstSyn and imgaft.cmtrno > *blanks
       or imgaft.cmtrno <> imgbef.cmtrno;                                    // if field changes
         putLink(CustomerID : 'TERRITORY'      :
                 newEntityA(CompanyID  : 'TERRITORY'    : imgaft.cmtrno));   // put link to subtable
       endif;                                                                // if field changes

       // customer class/subclass (two level dependence)

       if FirstSyn and imgaft.cmcscl > *blanks
       or imgaft.cmcscl <> imgbef.cmcscl
       or imgaft.cmcssc <> imgbef.cmcssc;                                    // if field changes
         CustClassID = newEntityA(CompanyID : 'CUSTCLASS' : imgaft.cmcscl);  // new cus class entity
         putLink(CustomerID : 'CUSTCLASS' : CustClassID);                    // put link to subtable
         putLink(CustomerID : 'CUSTSUBCLASS'   :
                 newEntityA(CustClassID  : 'CUSTSUBCLASS' : imgaft.cmcssc)); // put link to subtable
       endif;                                                                // if field changes

       // And now, the transaction systhesis portion of our show.  Fasten your seat belts.
       //
       // Many of the statistics kept at this level have three different buckets:
       //   -- Month to date
       //   -- Year to date
       //   -- Previous year total
       //
       // Going forward, we'll be able to capture the deltas in the M-T-D buckets
       //   whenever they change, and create an associated transaction.  However,
       //   on the FIRST synchronization, we must account for previous activity.
       //   Therefore we will create dummy transactions:
       //
       //   -- For month to date buckets, take the BEFORE image, and date the
       //      transaction as the start of the fiscal period.
       //
       //   -- For year to date buckets, take the BEFORE image, subtract out the
       //      current month, then date transaction as the start of the fiscal year.
       //
       //   -- For previous year buckets, take the either image, and date the
       //      transaction as the start of the previous fiscal year.
       //
       //   The reason we use the starting date is because we don't know the actual
       //     date, and we want our summation business rules to yield an accurate
       //     result when the date range argument spans the entire year or period.

       if FirstSyn;                                                          // if first time synch

         ThisPerdStart = %date - %days(%subdt(%date:*d)) + %days(1);         // this perd start date
         LastPerdStart = ThisPerdStart - %months(1);                         // last perd start date
         PrevPerdStart = ThisPerdStart - %months(2);                         // prev perd start date

         ThisYearStart = ThisPerdStart
                       - %months(%subdt(ThisPerdStart:*m) - 1);              // this year start date

         LastYearStart = ThisYearStart - %years(1);                          // last year start date

         // sales

         if imgbef.cmslmd > 0;                                               // if MTD sales before
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'SALES');                          // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmslmd);                    // prev MTD sales
           putDate(TransID : 'EFFECTIVE': ThisPerdStart);                    // effective date
         endif;                                                              // if MTD sales before

         if imgbef.cmslyd > 0;                                               // if YTD sales before
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'SALES');                          // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmslyd - imgbef.cmslmd);    // prev YTD sales
           putDate(TransID : 'EFFECTIVE': ThisYearStart);                    // effective date
         endif;                                                              // if YTD sales before

         if imgbef.cmslly > 0;                                               // if sales last year
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'SALES');                          // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmslly);                    // last year sales
           putDate(TransID : 'EFFECTIVE': LastYearStart);                    // effective date
         endif;                                                              // if sales last year

         // costs

         if imgbef.cmcsmd > 0;                                               // if MTD costs before
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'COSTS');                          // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmcsmd);                    // prev MTD costs
           putDate(TransID : 'EFFECTIVE': ThisPerdStart);                    // effective date
         endif;                                                              // if MTD costs before

         if imgbef.cmcsyd > 0;                                               // if YTD costs before
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'COSTS');                          // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmcsyd - imgbef.cmcsmd);    // prev YTD costs
           putDate(TransID : 'EFFECTIVE': ThisYearStart);                    // effective date
         endif;                                                              // if YTD costs before

         if imgbef.cmcsly > 0;                                               // if costs last year
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'COSTS');                          // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmcsly);                    // last year costs
           putDate(TransID : 'EFFECTIVE': LastYearStart);                    // effective date
         endif;                                                              // if costs last year

         // number of orders

         if imgbef.cmormd > 0;                                               // if MTD orders before
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'ORDERS');                         // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmormd);                    // prev MTD num orders
           putDate(TransID : 'EFFECTIVE': ThisPerdStart);                    // effective date
         endif;                                                              // if MTD orders before

         if imgbef.cmoryd > 0;                                               // if YTD orders before
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'ORDERS');                         // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmoryd - imgbef.cmormd);    // prev YTD num orders
           putDate(TransID : 'EFFECTIVE': ThisYearStart);                    // effective date
         endif;                                                              // if YTD orders before

         if imgbef.cmorly > 0;                                               // if orders last year
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'ORDERS');                         // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmorly);                    // last year num orders
           putDate(TransID : 'EFFECTIVE': LastYearStart);                    // effective date
         endif;                                                              // if orders last year

         // drop ship sales

         if imgbef.cmdsmd > 0;                                               // if MTD DS sales befr
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'DROPSALES');                      // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmdsmd);                    // prev MTD DS sales
           putDate(TransID : 'EFFECTIVE': ThisPerdStart);                    // effective date
         endif;                                                              // if MTD DS sales befr

         if imgbef.cmdsyd > 0;                                               // if YTD DS sales befr
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'DROPSALES');                      // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmdsyd - imgbef.cmdsmd);    // prev YTD DS sales
           putDate(TransID : 'EFFECTIVE': ThisYearStart);                    // effective date
         endif;                                                              // if YTD DS sales befr

         if imgbef.cmdsly > 0;                                               // if DS sales last yr
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'DROPSALES');                      // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmdsly);                    // last year DS sales
           putDate(TransID : 'EFFECTIVE': LastYearStart);                    // effective date
         endif;                                                              // if DS sales last yr

         // drop ship costs

         if imgbef.cmdcmd > 0;                                               // if MTD DS costs befr
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'DROPCOSTS');                      // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmdcmd);                    // prev MTD DS costs
           putDate(TransID : 'EFFECTIVE': ThisPerdStart);                    // effective date
         endif;                                                              // if MTD DS costs befr

         if imgbef.cmdcyr > 0;                                               // if YTD DS costs befr
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'DROPCOSTS');                      // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmdcyr - imgbef.cmdcmd);    // prev YTD DS costs
           putDate(TransID : 'EFFECTIVE': ThisYearStart);                    // effective date
         endif;                                                              // if YTD DS costs befr

         if imgbef.cmdcly > 0;                                               // if DS costs last yr
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'DROPCOSTS');                      // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmdcly);                    // last year DS costs
           putDate(TransID : 'EFFECTIVE': LastYearStart);                    // effective date
         endif;                                                              // if DS costs last yr

         // total invoices & amounts (since the dawn of time)
         //   in future might be based on invoice entities instead

         if imgbef.cmtoin > 0;                                               // if invc count prior
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'INVOICECOUNT');                   // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmtoin);                    // prev invoice count
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if invc count prior

         if imgbef.cmtiam > 0;                                               // if invc amt prior
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'INVOICEAMT');                     // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmtiam);                    // prev invoice amt
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if invc amt prior

         // international currency adjustments (since forever)

         if imgbef.cmrvtd > 0;                                               // if IC adjust prior
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'ICADJUST');                       // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmrvtd);                    // prev IC adjustments
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if IC adjust prior

         // unposted cash

         if imgbef.cmunpc > 0;                                               // if unpost cash prior
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'UNPOSTCASH');                     // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmunpc);                    // prev unpost cash
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if unpost cash prior

         // pay days (oldest bucket is based on forever)

         if imgbef.cmpdtm > 0;                                               // if pay days this mon
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'PAYDAYS');                        // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmpdtm);                    // pay days this month
           putDate(TransID : 'EFFECTIVE': ThisPerdStart);                    // effective date
         endif;                                                              // if pay days this mon

         if imgbef.cmpdlm > 0;                                               // if pay days last mon
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'PAYDAYS');                        // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmpdlm);                    // pay days last month
           putDate(TransID : 'EFFECTIVE': LastPerdStart);                    // effective date
         endif;                                                              // if pay days last mon

         if imgbef.cmpdpm > 0;                                               // if pay days all prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'PAYDAYS');                        // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmpdpm);                    // pay days all prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if pay days all prev

         // number of invoices paid (oldest bucket is based on forever)

         if imgbef.cmiptm > 0;                                               // if invcs pd this mon
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'INVOICESPAID');                   // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmiptm);                    // invcs pd this month
           putDate(TransID : 'EFFECTIVE': ThisPerdStart);                    // effective date
         endif;                                                              // if invcs pd this mon

         if imgbef.cmiplm > 0;                                               // if invcs pd last mon
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'INVOICESPAID');                   // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmiplm);                    // invcs pd last month
           putDate(TransID : 'EFFECTIVE': LastPerdStart);                    // effective date
         endif;                                                              // if invcs pd last mon

         if imgbef.cmippm > 0;                                               // if invcs pd all prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'INVOICESPAID');                   // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmippm);                    // invcs pd all prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if invcs pd all prev

         // open order value (probably temporary until more order entry files migrated)

         if imgbef.cmopor > 0;                                               // if open orders prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'OPENORDERS');                     // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmpdpm);                    // open orders prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if open orders prev

         // all time charges, credit and adjustments (possibly temporary)

         if imgbef.cmchtd > 0;                                               // if charges prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'CHARGES');                        // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmchtd);                    // charges prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if charges prev

         if imgbef.cmcrtd > 0;                                               // if credit prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'CREDIT');                         // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmcrtd);                    // credit prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if credit prev

         if imgbef.cmajtd > 0;                                               // if adjustments prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'ADJUSTMENTS');                    // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmajtd);                    // adjustments prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if adjustments prev

         // finance charges, assessed and paid (possibly temporary)

         if imgbef.cmtfnc > 0;                                               // if F/C assessed prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'FCASSESSED');                     // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmtfnc);                    // F/C assessed prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if F/C assessed prev

         if imgbef.cmfncp > 0;                                               // if F/C paid prev
           TransID = newEntityN(CustomerID : 'INCREMENT' : 0);               // new increment entity
           putNote(TransID : 'NICKNAME' : 'FCPAID');                         // trans nickname
           putNumb(TransID : 'AMOUNT'   : imgbef.cmfncp);                    // F/C paid prev
           putDate(TransID : 'EFFECTIVE': *loval);                           // effective date
         endif;                                                              // if F/C paid prev

       endif;                                                                // if first time synch

       // Synthesized transactions for normal bucket deltas.
       //   Only current M-T-D buckets are normally updated by ERP.

       if imgaft.cmslmd <> imgbef.cmslmd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'SALES');                            // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmslmd - imgbef.cmslmd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmcsmd <> imgbef.cmcsmd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'COSTS');                            // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmcsmd - imgbef.cmcsmd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmormd <> imgbef.cmormd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'ORDERS');                           // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmormd - imgbef.cmormd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmdsmd <> imgbef.cmdsmd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'DROPSALES');                        // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmdsmd - imgbef.cmdsmd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmdcmd <> imgbef.cmdcmd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'DROPCOSTS');                        // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmdcmd - imgbef.cmdcmd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmtoin <> imgbef.cmtoin;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'INVOICECOUNT');                     // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmtoin - imgbef.cmtoin);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmtiam <> imgbef.cmtiam;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'INVOICEAMT');                       // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmtiam - imgbef.cmtiam);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmrvtd <> imgbef.cmrvtd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'ICADJUST');                         // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmrvtd - imgbef.cmrvtd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmunpc <> imgbef.cmunpc;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'UNPOSTCASH');                       // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmunpc - imgbef.cmunpc);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmpdtm <> imgbef.cmpdtm;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'PAYDAYS');                          // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmpdtm - imgbef.cmpdtm);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmopor <> imgbef.cmopor;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'OPENORDERS');                       // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmopor - imgbef.cmopor);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmiptm <> imgbef.cmiptm;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'INVOICESPAID');                     // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmiptm - imgbef.cmiptm);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmchtd <> imgbef.cmchtd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'CHARGES');                          // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmchtd - imgbef.cmchtd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmcrtd <> imgbef.cmcrtd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'CREDIT');                           // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmcrtd - imgbef.cmcrtd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmajtd <> imgbef.cmajtd;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'ADJUSTMENTS');                      // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmajtd - imgbef.cmajtd);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmtfnc <> imgbef.cmtfnc;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'FCASSESSED');                       // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmtfnc - imgbef.cmtfnc);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       if imgaft.cmfncp <> imgbef.cmfncp;                                    // if bucket changes
         TransID = newEntityN(CustomerID : 'INCREMENT' : 0);                 // new increment entity
         putNote(TransID : 'NICKNAME' : 'FCPAID');                           // trans nickname
         putNumb(TransID : 'AMOUNT'   : imgaft.cmfncp - imgbef.cmfncp);      // capture this delta
         putDate(TransID : 'EFFECTIVE': %date());                            // effective date
       endif;

       *inlr = *on;                                                          // end of program

