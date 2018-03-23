view: ga_sessions_base {
    extension: required
    ##
    ### Session Level Dimensions
    ##
    dimension: partition_date {
      type: date_time
      sql: TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d')))  ;;
    }

    dimension: id {
      primary_key: yes
      sql: CONCAT(CAST(${fullVisitorId} AS STRING), '|', COALESCE(CAST(${visitId} AS STRING),'')) ;;
    }
    dimension: visitorId {label: "Visitor ID"}

    dimension: visitnumber {
      label: "Visit Number"
      type: number
      description: "The session number for this user. If this is the first session, then this is set to 1."
    }

    dimension:  first_time_visitor {
      type: yesno
      sql: ${visitnumber} = 1 ;;
    }

    dimension: visitnumbertier {
      label: "Visit Number Tier"
      type: tier
      tiers: [1,2,5,10,15,20,50,100]
      style: integer
      sql: ${visitnumber} ;;
    }

    dimension: visitId {
      label: "Visit ID"
    }

    dimension: fullVisitorId {
      label: "Full Visitor ID"
    }

    dimension: visitStartSeconds {
      label: "Visit Start Seconds"
      type: date
      sql: TIMESTAMP_SECONDS(${TABLE}.visitStarttime) ;;
      hidden: yes
    }

    ## referencing partition_date for demo purposes only. Switch this dimension to reference visistStartSeconds
    dimension_group: visitStart {
      timeframes: [date,day_of_week,fiscal_quarter,week,month,year,month_name,month_num,week_of_year]
      label: "Visit Start"
      type: time
      sql: (TIMESTAMP(${partition_date})) ;;
    }

    ## use visit or hit start time instead
    dimension: date {
      hidden: yes
    }

    dimension: socialEngagementType {
      label: "Social Engagement Type"
    }

    dimension: userid {
      label: "User ID"
    }

    dimension: channelGrouping {
      label: "Channel Grouping"
    }

    # subrecords
    dimension: geoNetwork {
      hidden: yes
    }

    dimension: totals {
      hidden:yes
    }

    dimension: trafficSource {
      hidden:yes
    }

    dimension: device {
      hidden:yes
    }

    dimension: customDimensions {
      hidden:yes
    }

    dimension: hits {
      hidden:yes
    }

    dimension: hits_eventInfo {
      hidden:yes
    }

##
### Session Level Measures
##

    measure: distinct_sessions {
      type: count_distinct
      sql: ${id} ;;
    }

    measure: session_count {
      type: count
      drill_fields: [fullVisitorId, visitnumber, session_count, totals.transactions_count, totals.transactionRevenue_total]
    }
    measure: unique_visitors {
      type: count_distinct
      sql: ${fullVisitorId} ;;
      drill_fields: [fullVisitorId, visitnumber, session_count, totals.hits, totals.page_views, totals.timeonsite]
    }

    measure: average_sessions_ver_visitor {
      type: number
      sql: 1.0 * (${session_count}/NULLIF(${unique_visitors},0))  ;;
      value_format_name: decimal_2
      drill_fields: [fullVisitorId, visitnumber, session_count, totals.hits, totals.page_views, totals.timeonsite]
    }

    measure: total_visitors {
      type: count
      drill_fields: [fullVisitorId, visitnumber, session_count, totals.hits, totals.page_views, totals.timeonsite]
    }

    measure: first_time_visitors {
      label: "First Time Visitors"
      type: count
      filters: {
        field: visitnumber
        value: "1"
      }
    }

    measure: returning_visitors {
      label: "Returning Visitors"
      type: count
      filters: {
        field: visitnumber
        value: "<> 1"
      }
  }
}
