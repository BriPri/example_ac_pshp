%dw 1.0
%output application/json
---
{
  NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
  RuleInfo: {
    LengthOfStayRules: {
      StayRestrictionsInd: StayRestrictionsInd:
        false when payload.mnrCatInfo.processIndicator == 'ASS'
        otherwise true,
        // if the above is false, don't map this below
      MaximumStay: {
	    MaxStay:
	    	  flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].time,
		MaxStayDate:
		  flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"},
        ReturnType:
          "C" when flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].qualifier == "MSP"
          otherwise "S" when flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].qualifier == "MSC"
          otherwise ""
      }
    }  
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