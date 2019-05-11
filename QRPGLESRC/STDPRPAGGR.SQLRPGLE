      **********************************************************************************************
      *                                                                                            *
      *  Inuendo 1.2 (Alpha release) - STANDARD PROPERTY AGGREGATE FUNCTIONS                       *
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

      /copy qcpysrc,stdhsrvpgm                                               // h-spec for srvpgm

      /copy qcpysrc,stdentinp                                                // protytpes, wrk flds
      /copy qcpysrc,stdentout                                                // protytpes, wrk flds
      /copy qcpysrc,stdentrule                                               // protytpes, wrk flds
      /copy qcpysrc,stdprpaggr                                               // protytpes, wrk flds


      **********************************************************************************************
      *  AVERAGE FUNCTIONS
      **********************************************************************************************

       dcl-proc PropertyAvgDuring export;                                    // avg during interval

       dcl-pi PropertyAvgDuring like(EntNumbP.Value);                        // avg during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // avg during interval

       dcl-s ChangeTimeX    like(EntNumbP.ChangeTime);                       // change time work fld
       dcl-s FromMomentX    like(EntNumbP.ChangeTime);                       // from moment work
       dcl-s ToMomentX      like(EntNumbP.ChangeTime);                       // to moment work
       dcl-s ValueX         like(EntNumbP.Value);                            // value work field
       dcl-s PrevTimeX      like(EntNumbP.ChangeTime);                       // previous change time
       dcl-s PrevValueX     like(EntNumbP.Value);                            // previous value
       dcl-s ValueElapsedX  like(MaxDecimal);                                // value elapsed time
       dcl-s TotalElapsedX  like(MaxDecimal);                                // total elapsed time
       dcl-s TotalWeightedX like(MaxDecimal);                                // total weighted value
       dcl-s OwnerIDx       like(EntDateP.EntityID);                         // owner entity ID
       dcl-s PropertyX      like(EntNumbP.Property);                         // property nickname

       monitor;                                                              // catch all errors

         OwnerIDx = PropertyOwner(EntityID:Property);                        // owner entity ID

         if OwnerIDx > 0;                                                    // if valid owner

           PropertyX = FinalSegment(Property);                               // isolate last segment

           if ValidProperty(OwnerIDx : PropertyX : 'NUMB');                  // if NUMB property

             FromMomentX = FromMoment;                                       // from moment passed
             ToMomentX   = ToMoment;                                         // to moment passed

             SetAggrRange(OwnerIDx:PropertyX:FromMomentX:ToMomentX);         // set agr moment range

             PrevTimeX  = FromMomentX;                                       // previous moment
             PrevValueX = getNumb(OwnerIDx : PropertyX : FromMomentX);       // previous value

             exec sql declare PropertyAvgX1 cursor for
               select changetime, value from EntNumb
                 where entityid = :OwnerIDx and property = :PropertyX
                   and changetime between :FromMomentX and :ToMomentX
                     order by 1;                                             // changes in interval

             exec sql open PropertyAvgX1;                                    // open cursor

             exec sql fetch from PropertyAvgX1 into :ChangeTimeX, :ValueX;   // fetch first change

             dow sqlcod = 0;                                                 // while more changes

               ValueElapsedX   = %diff(ChangeTimeX : PrevTimeX : *ms);       // value elapsed time
               TotalElapsedX  += ValueElapsedX;                              // total elapsed time
               TotalWeightedX += PrevValueX * ValueElapsedX;                 // total weighted value
               PrevTimeX       = ChangeTimeX;                                // previous change time
               PrevValueX      = ValueX;                                     // previous value

               exec sql fetch from PropertyAvgX1 into :ChangeTimeX, :ValueX; // fetch next change

             enddo;                                                          // while more changes

             exec sql close PropertyAvgX1;                                   // close cursor

             ValueElapsedX   = %diff(ToMomentX : PrevTimeX : *ms);           // value elapsed time
             TotalElapsedX  += ValueElapsedX;                                // total elapsed time
             TotalWeightedX += PrevValueX * ValueElapsedX;                   // total weighted value

             if TotalWeightedX <> 0 and TotalElapsedX <> 0;                  // if we can calc avg
               return(h) (TotalWeightedX / TotalElapsedX);                   // weighted average
             else;                                                           // we can't calc avg
               return 0;                                                     // zero default
             endif;                                                          // if we can calc avg

           endif;                                                            // if NUMB property
         endif;                                                              // if valid owner

       on-error *all;                                                        // on any error

         return 0;                                                           // zero default

       endmon;                                                               // catch all errors

       end-proc;                                                             // avg during interval

      **********************************************************************************************

       dcl-proc PropertyAvgThrough export;                                   // avg through moment

       dcl-pi PropertyAvgThrough like(EntNumbP.Value);                       // avg through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pi;                                                               // avg through moment

       return PropertyAvgDuring(EntityID:Property:*loval:ThruMoment);        // avg through moment

       end-proc;                                                             // avg through moment

      **********************************************************************************************

       dcl-proc PropertyAvgSince export;                                     // avg since moment

       dcl-pi PropertyAvgSince like(EntNumbP.Value);                         // avg since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pi;                                                               // avg since moment

       return PropertyAvgDuring(EntityID:Property:FromMoment:*hival);        // avg since moment

       end-proc;                                                             // avg since moment

      **********************************************************************************************

       dcl-proc PropertyAvg export;                                          // avg over entire life

       dcl-pi PropertyAvg like(EntNumbP.Value);                              // avg over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pi;                                                               // avg over entire life

       return PropertyAvgDuring(EntityID:Property:*loval:*hival);            // avg over entire life

       end-proc;                                                             // avg over entire life

      **********************************************************************************************
      *  MINIMUM FUNCTIONS
      **********************************************************************************************

       dcl-proc PropertyMinDuring export;                                    // min during interval

       dcl-pi PropertyMinDuring like(EntNumbP.Value);                        // min during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // min during interval

       return
         PropertyMinMaxDuring(EntityID:Property:'N':FromMoment:ToMoment);    // min during interval

       end-proc;                                                             // min during interval

      **********************************************************************************************

       dcl-proc PropertyMinThrough export;                                   // min through moment

       dcl-pi PropertyMinThrough like(EntNumbP.Value);                       // min through momentl
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pi;                                                               // min through moment

       return PropertyMinDuring(EntityID:Property:*loval:ThruMoment);        // min through moment

       end-proc;                                                             // min through moment

      **********************************************************************************************

       dcl-proc PropertyMinSince export;                                     // min since moment

       dcl-pi PropertyMinSince like(EntNumbP.Value);                         // min since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pi;                                                               // min since moment

       return PropertyMinDuring(EntityID:Property:FromMoment:*hival);        // min since moment

       end-proc;                                                             // min since moment

      **********************************************************************************************

       dcl-proc PropertyMin export;                                          // min over entire life

       dcl-pi PropertyMin like(EntNumbP.Value);                              // min over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pi;                                                               // min over entire life

       return PropertyMinDuring(EntityID:Property:*loval:*hival);            // min over entire life

       end-proc;                                                             // min over entire life

      **********************************************************************************************
      *  MAXIMUM FUNCTIONS
      **********************************************************************************************

       dcl-proc PropertyMaxDuring export;                                    // max during interval

       dcl-pi PropertyMaxDuring like(EntNumbP.Value);                        // max during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // max during interval

       return
         PropertyMinMaxDuring(EntityID:Property:'X':FromMoment:ToMoment);    // max during interval

       end-proc;                                                             // max during interval

      **********************************************************************************************

       dcl-proc PropertyMaxThrough export;                                   // max through moment

       dcl-pi PropertyMaxThrough like(EntNumbP.Value);                       // max through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pi;                                                               // max through moment

       return PropertyMaxDuring(EntityID:Property:*loval:ThruMoment);        // max through moment

       end-proc;                                                             // max through moment

      **********************************************************************************************

       dcl-proc PropertyMaxSince export;                                     // max since moment

       dcl-pi PropertyMaxSince like(EntNumbP.Value);                         // max since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pi;                                                               // max since moment

       return PropertyMaxDuring(EntityID:Property:FromMoment:*hival);        // max since moment

       end-proc;                                                             // max since moment

      **********************************************************************************************

       dcl-proc PropertyMax export;                                          // max over entire life

       dcl-pi PropertyMax like(EntNumbP.Value);                              // max over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pi;                                                               // max over entire life

       return PropertyMaxDuring(EntityID:Property:*loval:*hival);            // max over entire life

       end-proc;                                                             // max over entire life

      **********************************************************************************************
      *  SUM FUNCTIONS
      **********************************************************************************************

       dcl-proc PropertySumDuring export;                                    // sum during interval

       dcl-pi PropertySumDuring like(EntNumbP.Value);                        // sum during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // sum during interval

       return
         PropertySumCountDuring(EntityID:Property:'S':FromMoment:ToMoment);  // sum during interval

       end-proc;                                                             // sum during interval

      **********************************************************************************************

       dcl-proc PropertySumThrough export;                                   // sum through moment

       dcl-pi PropertySumThrough like(EntNumbP.Value);                       // sum through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pi;                                                               // sum through moment

       return
         PropertySumDuring(EntityID:Property:*loval:ThruMoment);             // sum through moment

       end-proc;                                                             // sum through moment

      **********************************************************************************************

       dcl-proc PropertySumSince export;                                     // sum since moment

       dcl-pi PropertySumSince like(EntNumbP.Value);                         // sum since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pi;                                                               // sum since moment

       return
         PropertySumDuring(EntityID:Property:FromMoment:*hival);             // sum since moment

       end-proc;                                                             // sum since moment

      **********************************************************************************************

       dcl-proc PropertySum export;                                          // sum over entire life

       dcl-pi PropertySum like(EntNumbP.Value);                              // sum over entire life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pi;                                                               // sum over entire life

       return PropertySumDuring(EntityID:Property:*loval:*hival);            // sum over entire life

       end-proc;                                                             // sum over entire life

      **********************************************************************************************
      *  COUNT FUNCTIONS
      **********************************************************************************************

       dcl-proc PropertyCountDuring export;                                  // count during intervl

       dcl-pi PropertyCountDuring like(EntNumbP.Value);                      // count during intervl
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // count during intervl

       return
         PropertySumCountDuring(EntityID:Property:'C':FromMoment:ToMoment);  // count during intervl

       end-proc;                                                             // count during intervl

      **********************************************************************************************

       dcl-proc PropertyCountThrough export;                                 // count through moment

       dcl-pi PropertyCountThrough like(EntNumbP.Value);                     // count through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pi;                                                               // count through moment

       return
         PropertyCountDuring(EntityID:Property:*loval:ThruMoment);           // count through moment

       end-proc;                                                             // count through moment

      **********************************************************************************************

       dcl-proc PropertyCountSince export;                                   // count since moment

       dcl-pi PropertyCountSince like(EntNumbP.Value);                       // count since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pi;                                                               // count since moment

       return
         PropertyCountDuring(EntityID:Property:FromMoment:*hival);           // count since moment

       end-proc;                                                             // count since moment

      **********************************************************************************************

       dcl-proc PropertyCount export;                                        // count over life

       dcl-pi PropertyCount like(EntNumbP.Value);                            // count over life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pi;                                                               // count over life

       return PropertyCountDuring(EntityID:Property:*loval:*hival);          // count over life

       end-proc;                                                             // count over life

      **********************************************************************************************
      *  MEAN FUNCTIONS
      **********************************************************************************************

       dcl-proc PropertyMeanDuring export;                                   // mean during interval

       dcl-pi PropertyMeanDuring like(EntNumbP.Value);                       // mean during interval
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // mean during interval

       dcl-s CountX like(EntNumbP.Value);                                    // count during intervl

       monitor;                                                              // catch all errors

         CountX =
           PropertyCountDuring(EntityID:Property:FromMoment:ToMoment);       // count during intervl

         if CountX > 0;                                                      // if value set
           return
             PropertySumDuring(EntityID:Property:FromMoment:ToMoment) /
               CountX;                                                       // mean during interval
         else;                                                               // no value ever set
           return 0;                                                         // default value
         endif;                                                              // if value set

       on-error *all;                                                        // on any error

         return 0;                                                           // deault value

       endmon;                                                               // catch all errors

       end-proc;                                                             // sum during interval

      **********************************************************************************************

       dcl-proc PropertyMeanThrough export;                                  // mean through moment

       dcl-pi PropertyMeanThrough like(EntNumbP.Value);                      // mean through moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         ThruMoment like(EntNumbP.ChangeTime) const;                         // through moment
       end-pi;                                                               // mean through moment

       dcl-s CountX like(EntNumbP.Value);                                    // count through moment

       monitor;                                                              // catch all errors

         CountX =
           PropertyCountThrough(EntityID:Property:ThruMoment);               // count through moment

         if CountX > 0;                                                      // if value set
           return
             PropertySumThrough(EntityID:Property:ThruMoment) / CountX;      // mean through moment
         else;                                                               // no value ever set
           return 0;                                                         // default value
         endif;                                                              // if value set

       on-error *all;                                                        // on any error

         return 0;                                                           // deault value

       endmon;                                                               // catch all errors

       end-proc;                                                             // mean through moment

      **********************************************************************************************

       dcl-proc PropertyMeanSince export;                                    // mean since moment

       dcl-pi PropertyMeanSince like(EntNumbP.Value);                        // mean since moment
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime) const;                         // from moment
       end-pi;                                                               // mean since moment

       dcl-s CountX like(EntNumbP.Value);                                    // count since moment

       monitor;                                                              // catch all errors

         CountX =
           PropertyCountSince(EntityID:Property:FromMoment);                 // count since moment

         if CountX > 0;                                                      // if value set
           return
             PropertySumSince(EntityID:Property:FromMoment) / CountX;        // mean since moment
         else;                                                               // no value ever set
           return 0;                                                         // default value
         endif;                                                              // if value set

       on-error *all;                                                        // on any error

         return 0;                                                           // deault value

       endmon;                                                               // catch all errors

       end-proc;                                                             // mean since moment

      **********************************************************************************************

       dcl-proc PropertyMean export;                                         // mean over life

       dcl-pi PropertyMean like(EntNumbP.Value);                             // mean over life
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
       end-pi;                                                               // mean over life

       return PropertyMeanDuring(EntityID:Property:*loval:*hival);           // mean over life

       end-proc;                                                             // mean over life

      **********************************************************************************************
      *  HELPER FUNCTIONS
      **********************************************************************************************

       dcl-proc PropertyMinMaxDuring;                                        // min/max during intvl

       dcl-pi PropertyMinMaxDuring like(EntNumbP.Value);                     // min/max during intvl
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         MinOrMax   like(EntFlagP.Value)      const;                         // min (N) or max (X)
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // min/max during intvl

       dcl-s FromMomentX    like(EntNumbP.ChangeTime);                       // from moment work
       dcl-s ToMomentX      like(EntNumbP.ChangeTime);                       // to moment work
       dcl-s InitValueX     like(EntNumbP.Value);                            // value work field
       dcl-s MinMaxValueX   like(EntNumbP.Value);                            // min or max value
       dcl-s OwnerIDx       like(EntDateP.EntityID);                         // owner entity ID
       dcl-s PropertyX      like(EntNumbP.Property);                         // property nickname

       monitor;                                                              // catch all errors

         OwnerIDx = PropertyOwner(EntityID:Property);                        // owner entity ID

         if OwnerIDx > 0;                                                    // if valid owner

           PropertyX = FinalSegment(Property);                               // isolate last segment

           if ValidProperty(OwnerIDx : PropertyX : 'NUMB');                  // if NUMB property

             FromMomentX = FromMoment;                                       // from moment passed
             ToMomentX   = ToMoment;                                         // to moment passed

             SetAggrRange(OwnerIDx:PropertyX:FromMomentX:ToMomentX);         // set agr moment range
             InitValueX = getNumb(OwnerIDx:PropertyX:FromMomentX);           // initial moment value

             exec sql
               select case when :MinOrMax = 'X' then max(value)
                                                else min(value) end
                  into :MinMaxValueX
                    from entnumb
                      where entityid = :OwnerIDx
                        and property = :PropertyX
                        and changetime between :FromMomentX and :ToMomentX;  // min/max change value

             if MinOrMax  = 'X' and MinMaxValueX > InitValueX
             or MinOrMax <> 'X' and MinMaxValueX < InitValueX;               // if min/max in change
               return MinMaxValueX;                                          // return min/max value
             else;                                                           // min/max in init valu
               return InitValueX;                                            // return init value
             endif;                                                          // if min/max in change

           endif;                                                            // if NUMB property
         endif;                                                              // if valid owner

       on-error *all;                                                        // on any error

         return 0;                                                           // zero default

       endmon;                                                               // catch all errors

       end-proc;                                                             // min/max during intvl

      **********************************************************************************************

       dcl-proc PropertySumCountDuring;                                      // sum/cnt during intvl

       dcl-pi PropertySumCountDuring like(EntNumbP.Value);                   // sum/cnt during intvl
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         SumOrCount like(EntFlagP.Value)      const;                         // sum (S) or count (C)
         FromMoment like(EntNumbP.ChangeTime) const;                         // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime) const;                         // to effective moment
       end-pi;                                                               // sum/cnt during intvl

       dcl-s SumCountValueX like(EntNumbP.Value);                            // sum/count of values
       dcl-s FirstMomentX   like(EntNumbP.ChangeTime);                       // 1st moment in range
       dcl-s FromMomentX    like(EntNumbP.ChangeTime);                       // from moment work
       dcl-s ToMomentX      like(EntNumbP.ChangeTime);                       // to moment work
       dcl-s OwnerIDx       like(EntDateP.EntityID);                         // owner entity ID
       dcl-s PropertyX      like(EntNumbP.Property);                         // property nickname

       monitor;                                                              // catch all errors

         OwnerIDx = PropertyOwner(EntityID:Property);                        // owner entity ID

         if OwnerIDx > 0;                                                    // if valid owner

           PropertyX = FinalSegment(Property);                               // isolate last segment

           if ValidProperty(OwnerIDx : PropertyX : 'NUMB');                  // if NUMB property

             FromMomentX = FromMoment;                                       // from moment passed
             ToMomentX   = ToMoment;                                         // to moment passed

             SetAggrRange(OwnerIDx:PropertyX:FromMomentX:ToMomentX);         // set agr moment range

             exec sql
               select case when :SumOrCount = 'X'
                             then sum(value)
                             else count(*) end,
                 min(changetime)
                   into :SumCountValueX, :FirstMomentX
                     from entnumb
                       where entityid = :OwnerIDx
                         and property = :PropertyX
                         and changetime between :FromMomentX and :ToMomentX; // sum/count of values

             if FirstMomentX = FromMomentX;                                  // if no prev value
               return SumCountValueX;                                        // return sum/count val
             elseif SumOrCount = 'S';                                        // or sum request
               return
                 SumCountValueX + getNumb(OwnerIDx:PropertyX:FromMomentX);   // include prev value
             else;
               return
                 SumCountValueX + 1;                                         // include prev value
             endif;                                                          // if no prev value

           endif;                                                            // if NUMB property
         endif;                                                              // if valid owner

       on-error *all;                                                        // on any error

         return 0;                                                           // default value

       endmon;                                                               // catch all errors

       end-proc;                                                             // sum/cnt during intvl

      **********************************************************************************************

       dcl-proc SetAggrRange;                                                // set agr moment range

       dcl-pi SetAggrRange;                                                  // set agr moment range
         EntityID   like(EntNumbP.EntityID)   const;                         // entity ID
         Property   like(EntHeadP.Descriptor) const;                         // property nickname
         FromMoment like(EntNumbP.ChangeTime);                               // frm effective moment
         ToMoment   like(EntNumbP.ChangeTime);                               // to effective moment
       end-pi;                                                               // set agr moment range

       dcl-s HoldMomentX like(EntNumbP.ChangeTime);                          // hold moment field
       dcl-s InitMomentX like(EntNumbP.ChangeTime);                          // initial prop moment

       if ToMoment = *loval;                                                 // if to value null
         ToMoment = *hival;                                                  // replace with hival
       endif;                                                                // if to value null

       if FromMoment > ToMoment;                                             // if moments backwards
         HoldMomentX = FromMoment;                                           // flip moments around
         FromMoment = ToMoment;                                              // flip moments around
         ToMoment   = HoldMomentX;                                           // flip moments around
       endif;                                                                // if moments backwards

       exec sql
         select min(changetime) into :InitMomentX from EntNumb
           where entityID = :EntityID and property = :Property;              // initial value moment

       if InitMomentX = *loval;                                              // if value never set
         exec sql
           select createtime into :InitMomentX from EntHead
             where entityID = :EntityID;                                     // use creation moment
       endif;                                                                // if value never set

       if FromMoment < InitMomentX;                                          // if moment too early
         FromMoment = InitMomentX;                                           // use initial moment
       endif;                                                                // if moment too early

       if ToMoment > %timestamp();                                           // if moment too late
         ToMoment  = %timestamp();                                           // use current moment
       endif;                                                                // if moment too early

       end-proc;                                                             // set agr moment range

      **********************************************************************************************
