view: session_totals_base {
    extension: required

    dimension: id {
      primary_key: yes
      hidden: yes
      sql: ${ga_sessions.id} ;;
    }

  dimension: timeOnScreen_total_unique{
    label: "Time On Screen Total"
    type: number
    sql: ${TABLE}.timeOnScreen ;;
  }

  dimension: timeonsite_tier {
    label: "Time On Site Tier"
    type: tier
    sql: ${TABLE}.timeonsite ;;
    tiers: [0,15,30,60,120,180,240,300,600]
    style: integer
  }

    measure: visits_total {
      type: sum
      sql: ${TABLE}.visits ;;
    }

    measure: hits_total {
      type: sum
      sql: ${TABLE}.hits ;;
      drill_fields: [hits.detail*]
    }

    measure: hits_average_per_session {
      type: number
      sql: 1.0 * ${hits_total} / NULLIF(${ga_sessions.session_count},0) ;;
      value_format_name: decimal_2
    }

    measure: pageviews_total {
      label: "Page Views"
      type: sum
      sql: ${TABLE}.pageviews ;;
    }

    measure: timeonsite_total {
      label: "Time On Site"
      type: sum
      sql: ${TABLE}.timeonsite ;;
    }

    measure: timeonsite_average_per_session {
      label: "Time On Site Average Per Session"
      type: number
      sql: 1.0 * ${timeonsite_total} / NULLIF(${ga_sessions.session_count},0) ;;
      value_format_name: decimal_2
    }

    measure: page_views_session {
      label: "PageViews Per Session"
      type: number
      sql: 1.0 * ${pageviews_total} / NULLIF(${ga_sessions.session_count},0) ;;
      value_format_name: decimal_2
    }

    measure: bounces_total {
      type: sum
      sql: ${TABLE}.bounces ;;
    }

    measure: bounce_rate {
      type:  number
      sql: 1.0 * ${bounces_total} / NULLIF(${ga_sessions.session_count},0) ;;
      value_format_name: percent_2
    }

    measure: transactions_count {
      type: sum
      sql: ${TABLE}.transactions ;;
    }

    measure: transactionRevenue_total {
      label: "Transaction Revenue Total"
      type: sum
      sql: (${TABLE}.transactionRevenue/1000000) ;;
      value_format_name: usd_0
      drill_fields: [transactions_count, transactionRevenue_total]
    }

    measure: newVisits_total {
      label: "New Visits Total"
      type: sum
      sql: ${TABLE}.newVisits ;;
    }

    measure: screenViews_total {
      label: "Screen Views Total"
      type: sum
      sql: ${TABLE}.screenViews ;;
    }

    measure: timeOnScreen_total{
      label: "Time On Screen Total"
      type: sum
      sql: ${TABLE}.timeOnScreen ;;
    }

    measure: uniqueScreenViews_total {
      label: "Unique Screen Views Total"
      type: sum
      sql: ${TABLE}.uniqueScreenViews ;;
    }
}
