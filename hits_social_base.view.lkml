view: hits_social_base {
    extension: required   ## THESE FIELDS WILL ONLY BE AVAILABLE IF VIEW "hits_social" IN GA CUSTOMIZE HAS THE "extends" parameter declared

    dimension: socialInteractionNetwork {
      label: "Social Interaction Network"
    }

    dimension: socialInteractionAction {
      label: "Social Interaction Action"
    }

    dimension: socialInteractions {
      label: "Social Interactions"
    }

    dimension: socialInteractionTarget {
      label: "Social Interaction Target"
    }

    dimension: socialNetwork {
      label: "Social Network"
    }

    dimension: uniqueSocialInteractions {
      label: "Unique Social Interactions"
      type: number
    }

    dimension: hasSocialSourceReferral {
      label: "Has Social Source Referral"
    }

    dimension: socialInteractionNetworkAction {
      label: "Social Interaction Network Action"
    }
}
