      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD PROPERTY AGGREGATE FUNCTIONS                       *
      *                                                                                            *
      *  Copyright (C) 2012, 2017  Christopher F. Burns Sr.                                        *
      *    c/o The Inuendo Project (http://inuendo.us).                                            *
      *                                                                                            *
      *  Use RPG /COPY statement in application programs to include this member.                   *
      *                                                                                            *
      *  This program is free software: you can redistribute it and/or modify                      *
      *  it under the .erms of the GNU General Public License as published by                      *
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
      *  AVERAGE FUNCTIONS
      **********************************************************************************************

       dcl-pr PropertyAvgDuring like(EntNumbP.Value);                        // avg during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pr;                                                               // avg during interval

       dcl-pr PropertyAvgThrough like(EntNumbP.Value);                       // avg through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pr;                                                               // avg through moment

       dcl-pr PropertyAvgSince like(EntNumbP.Value);                         // avg since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pr;                                                               // avg since moment

       dcl-pr PropertyAvg like(EntNumbP.Value);                              // avg over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pr;                                                               // avg over entire life

      **********************************************************************************************
      *  MINIMUM FUNCTIONS
      **********************************************************************************************

       dcl-pr PropertyMinDuring like(EntNumbP.Value);                        // min during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pr;                                                               // min during interval

       dcl-pr PropertyMinThrough like(EntNumbP.Value);                       // min during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pr;                                                               // min through moment

       dcl-pr PropertyMinSince like(EntNumbP.Value);                         // min since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pr;                                                               // min since moment

       dcl-pr PropertyMin like(EntNumbP.Value);                              // min over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pr;                                                               // min mver entire life

      **********************************************************************************************
      *  MAXIMUM FUNCTIONS
      **********************************************************************************************

       dcl-pr PropertyMaxDuring like(EntNumbP.Value);                        // max during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pr;                                                               // max during interval

       dcl-pr PropertyMaxThrough like(EntNumbP.Value);                       // max during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pr;                                                               // max through moment

       dcl-pr PropertyMaxSince like(EntNumbP.Value);                         // max since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pr;                                                               // max since moment

       dcl-pr PropertyMax like(EntNumbP.Value);                              // max over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pr;                                                               // max over entire life

      **********************************************************************************************
      *  SUM FUNCTIONS
      **********************************************************************************************

       dcl-pr PropertySumDuring like(EntNumbP.Value);                        // sum during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pr;                                                               // sum during interval

       dcl-pr PropertySumThrough like(EntNumbP.Value);                       // sum through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pr;                                                               // sum through moment

       dcl-pr PropertySumSince like(EntNumbP.Value);                         // sum since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pr;                                                               // sum since moment

       dcl-pr PropertySum like(EntNumbP.Value);                              // sum over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pr;                                                               // sum over entire life

      **********************************************************************************************
      *  COUNT FUNCTIONS
      **********************************************************************************************

       dcl-pr PropertyCountDuring like(EntNumbP.Value);                      // count during intervl
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pr;                                                               // count during intervl

       dcl-pr PropertyCountThrough like(EntNumbP.Value);                     // count through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pr;                                                               // count through moment

       dcl-pr PropertyCountSince like(EntNumbP.Value);                       // count since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pr;                                                               // count since moment

       dcl-pr PropertyCount like(EntNumbP.Value);                            // count over life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pr;                                                               // count over life

      **********************************************************************************************
      *  MEAN FUNCTIONS
      **********************************************************************************************

       dcl-pr PropertyMeanDuring like(EntNumbP.Value);                       // mean during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pr;                                                               // mean during interval

       dcl-pr PropertyMeanThrough like(EntNumbP.Value);                      // mean through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pr;                                                               // mean through moment

       dcl-pr PropertyMeanSince like(EntNumbP.Value);                        // mean since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pr;                                                               // mean since moment

       dcl-pr PropertyMean like(EntNumbP.Value);                             // mean over life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pr;                                                               // mean over life

      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntHeadP ext extname('ENTHEAD') qualified template end-ds;     // record template
       dcl-ds EntPropP ext extname('ENTPROP') qualified template end-ds;     // record template
       dcl-ds EntDateP ext extname('ENTDATE') qualified template end-ds;     // record template
       dcl-ds EntFlagP ext extname('ENTFLAG') qualified template end-ds;     // record template
       dcl-ds EntLinkP ext extname('ENTLINK') qualified template end-ds;     // record template
       dcl-ds EntNoteP ext extname('ENTNOTE') qualified template end-ds;     // record template
       dcl-ds EntNumbP ext extname('ENTNUMB') qualified template end-ds;     // record template
       dcl-ds EntNotXP ext extname('ENTNOTX') qualified template end-ds;     // record template
       dcl-ds EntNumXP ext extname('ENTNUMX') qualified template end-ds;     // record template
       dcl-ds EntDatXP ext extname('ENTDATX') qualified template end-ds;     // record template

       dcl-s MaxDecimal packed(63:5) template;                               // max decimal size

