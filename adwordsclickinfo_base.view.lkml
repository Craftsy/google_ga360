view: adwordsclickinfo_base {
    extension: required
    dimension: campaignId {label: "Campaign ID"}
    dimension: adGroupId {label: "Ad Group ID"}
    dimension: creativeId {label: "Creative ID"}
    dimension: criteriaId {label: "Criteria ID"}
    dimension: page {type: number}
    dimension: slot {}
    dimension: criteriaParameters {label: "Criteria Parameters"}
    dimension: gclId {}
    dimension: customerId {label: "Customer ID"}
    dimension: adNetworkType {label: "Ad Network Type"}
    dimension: targetingCriteria {label: "Targeting Criteria"}
    dimension: isVideoAd {
      label: "Is Video Ad"
      type: yesno
    }
}
