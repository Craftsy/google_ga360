view: trafficsource_base {
    extension: required

#   dimension: adwords {}

    dimension: referralPath {
      label: "Referral Path"
    }

    dimension: campaign {}
    dimension: source {
      hidden: yes
    }
    dimension: medium {}
    dimension: keyword {}

    dimension: adContent {
      label: "Ad Content"
    }

  dimension: ma_goal {
    label: "MA Goal"
    type: string
    sql: REGEXP_EXTRACT(${adContent}, '(.+)/.+/.+') ;;
  }

    measure: source_list {
      type: list
      list_field: source
      hidden: yes
    }

    measure: source_count {
      type: count_distinct
      hidden: yes
      sql: ${source} ;;
      drill_fields: [source, totals.hits, totals.pageviews]
    }

    measure: keyword_count {
      type: count_distinct
      sql: ${keyword} ;;
      drill_fields: [keyword, totals.hits, totals.pageviews]
    }
}
