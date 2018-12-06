%dw 1.0
%output application/json

%function fareComponentRefContainsReferenceDetail(fareComponentRef, type, value) (
  not (fareComponentRef.referenceDetails filter $.type == type and $.value == value) is :empty
)

%function filterFareComponentInfo(fareComponentInfo, fcType, fcValue) (
  fareComponentInfo filter fareComponentRefContainsReferenceDetail($.fareComponentRef, fcType, fcValue)
)
---
{
  NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
  RuleInfo: {
    ResTicketingRules: {
    	  AdvResTicketing: {
    	    AdvResInd: 
    	       true when (payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ERD' or
    	       payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LRD'
    	       ) 
           otherwise false,
    	    AdvTicketingInd:
    	      true when (payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ETD' or
            payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTD' or
            payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTR')
            otherwise false,
    	    FirstTicketDate: 
    	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"} when
    	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ETD'
    	      otherwise "",
    	    LastTicketDate:
    	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"} when
    	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTD'
    	      otherwise "",
    	    RequestedTicketingDate: 
    	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"} when
    	      payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LTR'
    	      otherwise "",
    	    AdvReservation: {
    	      LatetPeriod:
    	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"} when
    	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'LRD'
    	        otherwise "",
    	      EarliestPeriods:
    	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"} when
    	        payload.mnrDateInfoGrp.dateInfo.dateAndTimeDetails.qualifier == 'ERD'
    	        otherwise ""
    	    }
    	  }
    }
  },
  
  AC_SegmentRefNumbers: (flatten (payload.mnrFCInfoGrp[0].refInfo.referenceDetails map (refDetail) -> (
      flatten (filterFareComponentInfo(flowVars.currentMnrByPricingRecordJson.fareComponentInfo, refDetail.type, refDetail.value) map (
        $.segmentRefernce.reference.value
      ))
        ))) map {
          RPH: $
        },
  
  AC_TravelerRefNumbers: flowVars.currentMnrByPricingRecordJson.paxRef.passengerReference map {
    RPH: $.value as :string
  }
}