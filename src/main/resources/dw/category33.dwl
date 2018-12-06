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
    ChargesRules: {
      VoluntaryChanges: {
        Penalty: {
          DecimalPlaces: 2,
          CurrencyCode: "<IMD Conflict - Not completed yet>",
          PenaltyType: "<IMD Conflict - Not completed yet>",
          Amount: "<IMD Conflict - Not completed yet>"
        },
        VolChangeInd: false when payload.mnrCatInfo.processIndicator == "ASS" otherwise true
      }
    }
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