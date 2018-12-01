%dw 1.0
%output application/json
---
{
  NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
  RuleInfo: {
    ResTicketingRules: {
	  AdvResTicketing: {
	    AdvResInd: 
	    	  true when (payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ERD' or
          payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LRD') 
          otherwise false,
	    AdvTicketingInd:
	      true when (payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ETD' or
          payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTD' or
          payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTR')
          otherwise false,
	    FirstTicketDate: 
	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date when
	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ETD'
	      otherwise "",
	    LastTicketDate:
	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date when
	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTD'
	      otherwise "",
	    RequestedTicketingDate: 
	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date when
	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTR'
	      otherwise "",
	    AdvReservation: {
	      LatetPeriod:
	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date when
	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LRD'
	        otherwise "",
	      EarliestPeriods:
	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date when
	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ERD'
	        otherwise ""
	    }
	  }
    }
  },
  AC_SegmentRefNumbers: flatten (flowVars.currentMnrByPricingRecordJson.fareComponentInfo map ( 
    $.segmentRefernce map {
	  RPH: $.reference.value 
  })),	
  AC_TravelerRefNumbers: flowVars.currentMnrByPricingRecordJson.paxRef.passengerReference map {
    RPH: $.value
  }
}