view: hits_social_base {
    extension: required   ## THESE FIELDS WILL ONLY BE AVAILABLE IF VIEW "hits_social" IN GA CUSTOMIZE HAS THE "extends" parameter declared

    dimension: socialInteractionNetwork {
      view_label: "Marketing Attribution"
      label: "Social Interaction Network"
    }

    dimension: socialInteractionAction {
      view_label: "Marketing Attribution"
      label: "Social Interaction Action"
    }

    dimension: socialInteractions {
      view_label: "Marketing Attribution"
      label: "Social Interactions"
    }

    dimension: socialInteractionTarget {
      view_label: "Marketing Attribution"
      label: "Social Interaction Target"
    }

    dimension: socialNetwork {
      view_label: "Marketing Attribution"
      label: "Social Network"
    }

    dimension: uniqueSocialInteractions {
      view_label: "Marketing Attribution"
      label: "Unique Social Interactions"
      type: number
    }

    dimension: hasSocialSourceReferral {
      view_label: "Marketing Attribution"
      label: "Has Social Source Referral"
    }

    dimension: socialInteractionNetworkAction {
      view_label: "Marketing Attribution"
      label: "Social Interaction Network Action"
    }
}
