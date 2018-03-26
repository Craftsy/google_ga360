include: "*.view.lkml"

view: ga_sessions {
   sql_table_name: `129435859.ga_sessions_*` ;;
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

## Conversion Rates for Goals
  measure: goal_view_paid_listing_conversion_rate {
    label: "View Paid Listing Conversion Rate"
    type: number
    value_format_name: percent_1
    sql: ${goal_view_paid_listing} / ${distinct_sessions};;
  }

## Goals
  measure: goal_paid_purchase {
    label: "Goal 1: Paid Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating' then ${id}
       end;;
  }

  measure: goal_course_purchase {
    label: "Goal 2: Course Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'(new|repeat) course') then ${id}
       end;;
  }

  measure: goal_supplies_purchase {
    label: "Goal 3: Supplies Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'(new|repeat) supply') then ${id}
       end;;
  }

  measure: goal_new_buyer {
    label: "Goal 4: New Buyer"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and ${hits.eventInfo}.eventaction = 'buyer type: new' then ${id}
       end;;
  }

  measure: goal_repeat_purchase {
    label: "Goal 5: Repeat Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and ${hits.eventInfo}.eventaction = 'buyer type: repeat' then ${id}
       end;;
  }

  measure: goal_paid_add_to_cart {
    label: "Goal 6: Paid Add-to-Cart"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'listing cart add'
       and ${hits.eventInfo}.eventlabel = 'free: yes + seller: craftsy' then ${id}
       end;;
  }

  measure: goal_course_activation {
    label: "Goal 7: Course Activation"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'.*new course.*') then ${id}
       end;;
  }

  measure: goal_course_activity {
    label: "Goal 8: Course Activity"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel,r'.*repeat course.*') then ${id}
       end;;
  }

  measure: goal_supply_activation {
    label: "Goal 9: Supply Activation"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel,r'.*new supply.*') then ${id}
       end;;
  }

  measure: goal_supply_activity {
    label: "Goal 10: Supply Activity"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'.*repeat supply.*') then ${id}
       end;;
  }

  measure: goal_view_paid_listing {
    label: "Goal 16: View Paid Listing"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'listing detail page'
        and ${hits.eventInfo}.eventlabel = 'free: no + seller: craftsy' then ${id}
        end;;
  }

  measure: goal_register {
    label: "Goal 17: Register"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'account create'
        and REGEXP_CONTAINS(${hits.eventInfo}.eventaction, r'^success.*') then ${id}
        end;;
  }

  measure: goal_blog_subscribe {
    label: "Goal 18: Blog Subscribe"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'blog subscription' then ${id}
        end;;
  }

  measure: goal_free_transaction {
    label: "Goal 19: Free Transaction"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction non-revenue generating' then ${id}
        end;;
  }

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

view: hits_appInfo {
  extends: [hits_appinfo_base]
}

view: hits_eventInfo {
  extends: [hits_eventinfo_base]
}

view: hits_customdimensions {
  extends: [hits_customdimensions_base]
}

view: hits_customVariables {
  extends: [hits_customvariables_base]
}

view: hits {
  extends: [hits_base]
}

view: hits_page {
  extends: [hits_page_base]
}

# -- Ecommerce Fields

view: hits_transaction {
  #extends: [hits_transaction_base]  # Comment out to remove fields
}

view: hits_item {
  #extends: [hits_item_base]
}

# -- Advertising Fields

view: adwordsClickInfo {
  #extends: [adwordsClickInfo_base]
}

view: hits_publisher {
  #extends: [hits_publisher_base]   # Comment out this line to remove fields
}

view: geoNetwork {
  extends: [geonetwork_base]
}

view: totals {
  extends: [session_totals_base]
}

view: trafficSource {
  extends: [trafficsource_base]
}

view: device {
  extends: [device_base]
}

#  We only want some of the interaction fields.
view: hits_social {
  extends: [hits_social_base]

  dimension: socialInteractionNetwork {hidden: yes}

  dimension: socialInteractionAction {hidden: yes}

  dimension: socialInteractions {hidden: yes}

  dimension: socialInteractionTarget {hidden: yes}

  #dimension: socialNetwork {hidden: yes}

  dimension: uniqueSocialInteractions {hidden: yes}

  #dimension: hasSocialSourceReferral {hidden: yes}

  dimension: socialInteractionNetworkAction {hidden: yes}
}
