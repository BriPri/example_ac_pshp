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
  RuleInfo: {
    (LengthOfStayRules: {
      MinimumStay: {
        MaxStay: payload.mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].dateAndTimeDetails[0].time as :number,
        MaxStayDate: payload.mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"},
        ReturnType: 'C' when payloads.mnrDateInfoGrp[0].dateInfo.dateAndTimeDetails[0].qualifier == "MSP" otherwise 'S'
      },
      StayRestrictionsInd: false when payload.mnrCatInfo.processIndicator == 'ASS' otherwise true
    }) when payload.mnrCatInfo.processIndicator == 'ASS'
  },
  
  (City: flatten (payload.mnrFCInfoGrp map (
    $.locationInfo map {
    LocationCode: $.locationDescription.code
  }
  ))) when payload.mnrCatInfo.processIndicator == 'ASS',
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