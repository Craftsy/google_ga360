include: "ga_block.view.lkml"

explore: ga_sessions_block {
  extends: [ga_sessions_base]
  extension: required

  always_filter: {
    filters: {
      field: ga_sessions.partition_date
      value: "7 days ago for 7 days"
      ## Partition Date should always be set to a recent date to avoid runaway queries
   }
  }
}

view: ga_sessions {
  extends: [ga_sessions_base]
  # The SQL_TABLE_NAME must be replaced here for date partitioned queries to work properly. There are several
  # variations of sql_table_name patterns depending on the number of Properties (i.e. websites) being used.

  # SCENARIO 1: Only one property
  sql_table_name: `129435859.ga_sessions_*` ;;

  # SCENARIO 2: Multiple properties. The property will dynamically look at the selected dataset using a filter.
  # sql_table_name: {% assign prop = ga_sessions.website_selector._sql %}
  #                 {% if prop contains 'Website1' %} `project.dataset.ga_sessions_*`
  #                 {% elsif prop contains 'Website2' %} `project.dataset.ga_sessions_*`
  #                 {% elsif prop contains 'Website3' %} `project.dataset.ga_sessions_*`
  #                 {% endif %}
  #                 ;;
  #   filter: website_picker {
  #     suggestions: ["Website1","Website2", "Website3"]
  #   }
  #   dimension: website_selector {
  #     type: string
  #     hidden: no
  #     sql: {% parameter website_picker %} ;;
  #   }

  # SCENARIO 3: Multiple properties. The property will dynamically look at the selected dataset. If using this pattern, change the partition_date definition in the ga_block file  to type: date_time (no sql clause)
  # sql_table_name: (SELECT *,'Property1' AS Property FROM `dataset_number.ga_sessions_*` WHERE {% condition partition_date %} TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d'))) {% endcondition %}
  #  UNION ALL SELECT *,'Property2' AS Property FROM `dataset_number2.ga_sessions_*` WHERE {% condition partition_date %} TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d'))) {% endcondition %});;

  #   dimension: property {
  #     sql: CASE WHEN ${TABLE}.property = 'Property1' THEN 'Name'
  #         WHEN ${TABLE}.property = 'Property2' THEN 'Name2'
  #         ELSE NULL END
  #       ;;
  #  }

#### Custom dimensions on sessions ####

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
}

view: geoNetwork {
  extends: [geoNetwork_base]
}

view: totals {
  extends: [totals_base]
}

view: trafficSource {
  extends: [trafficSource_base]
}

view: device {
  extends: [device_base]
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


view: hits_appInfo {
  extends: [hits_appInfo_base]
}

view: hits_eventInfo {
  extends: [hits_eventInfo_base]
  dimension: play {
    sql: ${eventAction} = "play" ;;
    type: yesno
  }
}


view: hits_customDimensions {
  extends: [hits_customDimensions_base]
}

view: hits_customVariables {
  extends: [hits_customVariables_base]
}
