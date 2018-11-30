%dw 1.0
%output application/json
---
{
	NegotiatedFareCode: payload.mnrCatInfo.descriptionInfo.number as :string,
	RuleInfo: {
		LengthOfStayRules: {
			StayRestrictionsInd: false when payload.mnrCatInfo.processIndicator == 'ASS' otherwise true
		}
	},
	
	City: payload.mnrCatInfo.mnrFCInfoGrp map (
		$.locationInfo map {
			LocationCode: $.locationDescription.code
	}),
	
	AC_SegmentRefNumbers: flatten (flowVars.currentMnrByPricingRecordJson.fareComponentInfo map ( 
		$.segmentRefernce map {
		RPH: $.reference.value
	})),
	
	AC_TravelerRefNumbers: flowVars.currentMnrByPricingRecordJson.paxRef.passengerReference map {
			RPH: $.value
	}
		
}