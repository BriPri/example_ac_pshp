%dw 1.0
%output application/json
---
{
  NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
  RuleInfo: {
    (LengthOfStayRules: {
      MinimumStay: {
        MinStay: flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].time as :number,
		MinStayDate: flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"}
	  },
	  StayRestrictionsInd: false when payload.mnrCatInfo.processIndicator == 'ASS' otherwise true
		}) when payload.mnrCatInfo.processIndicator == 'ASS' 
  },
  City:
    flatten (payload.mnrFCInfoGrp map (
      $.locationInfo map {
        LocationCode: $.locationDescription.code
      }
    )),
  AC_SegmentRefNumbers:
    flatten (flowVars.currentMnrByPricingRecordJson.fareComponentInfo map ( 
      $.segmentRefernce map {
        RPH: $.reference.value 
      }
    )),  
  AC_TravelerRefNumbers:
    flowVars.currentMnrByPricingRecordJson.paxRef.passengerReference map {
      RPH: $.value
    }
}