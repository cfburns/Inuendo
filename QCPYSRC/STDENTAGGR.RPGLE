      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD ENTITY AGGREGATE FUNCTIONS                         *
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
      *  AVERAGE FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-pr EntityAvgM like(EntNumbA.Value);                               // entity child avg
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pr;                                                               // entity child avg

       dcl-pr EntityAvg like(EntNumbA.Value);                                // entity child avg
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pr;                                                               // entity child avg


      **********************************************************************************************
      *  MAXIMUM FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-pr EntityMaxM like(EntNumbA.Value);                               // entity child max
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pr;                                                               // entity child max

       dcl-pr EntityMax like(EntNumbA.Value);                                // entity child max
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pr;                                                               // entity child max


      **********************************************************************************************
      *  MINIMUM FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-pr EntityMinM like(EntNumbA.Value);                               // entity child min
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pr;                                                               // entity child min

       dcl-pr EntityMin like(EntNumbA.Value);                                // entity child min
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pr;                                                               // entity child min


      **********************************************************************************************
      *  SUM FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-pr EntitySumM like(EntNumbA.Value);                               // entity child sum
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pr;                                                               // entity child sum

       dcl-pr EntitySum like(EntNumbA.Value);                                // entity child sum
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Property   like(EntNumbA.Property)   const;                         // property nickname
       end-pr;                                                               // entity child sum


      **********************************************************************************************
      *  COUNT FUNCTIONS (WITH/WITHOUT MOMENT)
      **********************************************************************************************

       dcl-pr EntityCountM like(EntNumbA.Value);                             // entity child count
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
         Moment     like(EntNumbA.ChangeTime) const;                         // change time stamp
       end-pr;                                                               // entity child count

       dcl-pr EntityCount like(EntNumbA.Value);                              // entity child count
         EntityID   like(EntNumbA.EntityID)   const;                         // entity ID
         Class      like(EntHeadA.Class)      const;                         // child entity class
       end-pr;                                                               // entity child count


      **********************************************************************************************
      *  WORKING STORAGE TEMPLATES AND CONSTANTS
      **********************************************************************************************

       dcl-ds EntHeadA ext extname('ENTHEAD') qualified template end-ds;     // record template
       dcl-ds EntPropA ext extname('ENTPROP') qualified template end-ds;     // record template
       dcl-ds EntDateA ext extname('ENTDATE') qualified template end-ds;     // record template
       dcl-ds EntFlagA ext extname('ENTFLAG') qualified template end-ds;     // record template
       dcl-ds EntLinkA ext extname('ENTLINK') qualified template end-ds;     // record template
       dcl-ds EntNoteA ext extname('ENTNOTE') qualified template end-ds;     // record template
       dcl-ds EntNumbA ext extname('ENTNUMB') qualified template end-ds;     // record template
       dcl-ds EntNotXA ext extname('ENTNOTX') qualified template end-ds;     // record template
       dcl-ds EntNumXA ext extname('ENTNUMX') qualified template end-ds;     // record template
       dcl-ds EntDatXA ext extname('ENTDATX') qualified template end-ds;     // record template

       dcl-s  AggrFunction char(3) template;                                 // field template

      **********************************************************************************************
