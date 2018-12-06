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