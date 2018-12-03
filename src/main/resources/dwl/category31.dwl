%dw 1.0
%output application/json
---
{
	NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
	RuleInfo: {
//		AC_Restriction: 	flatten (flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp.mnrRestriAppInfoGrp map (
//			 $.mnrRestriAppInfo mapObject ((x,y) -> {
//				RestrictionType: $.mnrRestriAppInfo.statusInformation
//			})
//		)),
//		AC_Restriction: 	flatten (flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp.mnrRestriAppInfoGrp map (
//			 $.mnrRestriAppInfo.statusInformation  map {
//			 	RestrictionType: $.indicator,
//			 	Applicable: false when $.action == "0" otherwise "1"
//			 } 
//		)),
//		AC_Restriction: 	flatten (flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp map (
//			$.mnrRestriAppInfoGrp map (
//				$.mnrRestriAppInfo.statusInformation map {
//			 		RestrictionType: $.indicator,
//			 		Applicable: false when $.action == "0" otherwise "1"
//		 		}
//		 	)
//		)),
		AC_Restriction: flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp map (
			$.mnrRestriAppInfoGrp.mnrRestriAppInfo.statusInformation.indicator
		),
		
		ChargesRules: {
			VoluntaryChanges: {
				Penalty: {
					DecimalPlaces: 2,
					CurrencyCode: "<Not complete>",
					PenaltyType: "<Not complete>",
					Amount: "<Not complete>"
				},
				VolChangeInd: false when payload.mnrCatInfo.processIndicator == "ASS" otherwise true
			}
		}
	},
	AC_SegmentRefNumbers: flatten (flowVars.currentMnrByPricingRecordJson.fareComponentInfo map ( 
		$.segmentRefernce map {
		RPH: $.reference.value as :string
	})),
	AC_TravelerRefNumbers: flowVars.currentMnrByPricingRecordJson.paxRef.passengerReference map {
		RPH: $.value as :string
	}
}