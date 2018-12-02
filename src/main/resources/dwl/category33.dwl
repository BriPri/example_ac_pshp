%dw 1.0
%output application/json
---
{
  NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
  RuleInfo: {
    ChargeRules: {
      VoluntaryRefunds: {
        VolChangeInd: "",
        Pentalty: {
          Amount: "",
          CurrencyCode: "",
          DecimalPlaces: 2
        }
      }
    }
  },
  
  City: flatten (payload.mnrFCInfoGrp map (
    $.locationInfo map {
    LocationCode: $.locationDescription.code
  }
  )),
  AC_SegmentRefNumbers: flatten (flowVars.currentMnrByPricingRecordJson.fareComponentInfo map ( 
    $.segmentRefernce map {
    RPH: $.reference.value 
  })),  
  AC_TravelerRefNumbers: flowVars.currentMnrByPricingRecordJson.paxRef.passengerReference map {
    RPH: $.value
  }
}