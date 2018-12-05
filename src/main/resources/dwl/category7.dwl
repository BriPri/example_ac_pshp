%dw 1.0
%output application/json
---
{
  RuleInfo: {
    (LengthOfStayRules: {
      MinimumStay: {
        MxnStay: flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].time as :number,
        MxnStayDate: flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp[0].mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"}
      },
      StayRestrictionsInd: false when payload.mnrCatInfo.processIndicator == 'ASS' otherwise true
    }) when payload.mnrCatInfo.processIndicator == 'ASS'
  },
  
  City: flatten (payload.mnrFCInfoGrp map (
    $.locationInfo map {
      LocationCode: $.locationDescription.code
    }
  )),
    
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