%dw 1.0
%output application/json
---
{
	NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
	RuleInfo: {
		AC_Restriction: [{
			RestrictionType: flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp.mnrRestriAppInfoGrp.mnrRestriAppInfo.statusInformation.indicator,
			Applicable: false when flowVars.currentMnrByPricingRecordJson.mnrRulesInfoGrp.mnrRestriAppInfoGrp.mnrRestriAppInfo.statusInformation.action == 0 otherwise true as :boolean
		}],
		ChargesRules: {
			VoluntaryChanges: {
				Penalty: {
					DecimalPlaces: 2
				},
				VolChangeInd: false when payload.mnrCatInfo.processIndicator == "ASS" otherwise true
			}
		}
	}
}