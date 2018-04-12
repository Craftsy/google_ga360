view: trafficsource_base {
    extension: required

#   dimension: adwords {}

    dimension: referralPath {
      label: "Referral Path"
    }

    dimension: campaign {}
    dimension: source {}
    dimension: medium {}
    dimension: keyword {}

    dimension: adContent {
      label: "Ad Content"
    }

    measure: source_list {
      type: list
      list_field: source
    }

    measure: source_count {
      type: count_distinct
      sql: ${source} ;;
      drill_fields: [source, totals.hits, totals.pageviews]
    }

    measure: keyword_count {
      type: count_distinct
      sql: ${keyword} ;;
      drill_fields: [keyword, totals.hits, totals.pageviews]
    }
}
