%dw 1.0
%output application/json
//%function findElement (arrayToSearch, valueToFind ) { ["brian", "jen"] filter arrayToSearch.value == "brian" 
%var name1 = "brian"
%var name2 = "jen"
// fareComponentInfo -> fareComponentRef -> referenceDetails when “type” = “FC.

%var matchingTypes = flowVars.currentMnrByPricingRecordJson.*referenceDetails.type == "FC"
%var matchingTypes2 = (flowVars.currentMnrByPricingRecordJson.fareComponentInfo.fareComponentRef.referenceDetails filter $.type == "FC")."value"
---
{
	value: matchingTypes,
	value2: matchingTypes2,
	NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
	RuleInfo: {

		AC_Restriction: flatten (payload.mnrRestriAppInfoGrp map (
			$.mnrRestriAppInfo.statusInformation map {
				RestrictionType: $.indicator,
				Applicable: false when $.action == "0" otherwise true
			}
			)
		),
		
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
	
	AC_DateDetails: flatten (payload.mnrDateInfoGrp map (
		$.dateInfo.dateAndTimeDetails map {
			DateType: $.qualifier,
			Date: $.date as :date {format: "ddMMMyy"} as :string {format: "yyyy-MM-dd"}
		}
	)),
	
	AC_SegmentRefNumbers: flatten (flowVars.currentMnrByPricingRecordJson.fareComponentInfo map ( 
		$.segmentRefernce map {
		RPH: $.reference.value as :string
	})),
	
//	AC_SegmentRefNumbers: flatten (flowVars.currentMnrByPricingRecordJson.fareComponentInfo map ( 
//		$.segmentRefernce filter ($.reference.value == "1") map {
//		RPH: $.reference.value as :string
//	})),
	
	AC_TravelerRefNumbers: flowVars.currentMnrByPricingRecordJson.paxRef.passengerReference map {
		RPH: $.value as :string
	}
}