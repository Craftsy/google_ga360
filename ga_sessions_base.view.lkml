include: "*.view.lkml"

view: ga_sessions {
   sql_table_name: `129435859.ga_sessions_*` ;;

    ##
    ### Session Level Dimensions (Default)
    ##
    dimension: partition_date {
      type: date_time
      sql: TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d')))  ;;
    }

    dimension: id {
      label: "Session ID"
      primary_key: yes
      sql: CONCAT(CAST(${fullVisitorId} AS STRING), '|', COALESCE(CAST(${visitId} AS STRING),'')) ;;
      description: "Session ID is a unique identifier that concatinates a user id by device (different from our internaly defined user id) with a unique id for each visit."
    }

    dimension: visitorId {
      label: "Visitor ID"
      hidden: yes
    }


  dimension: visitId {
    label: "Visit ID"
    hidden: yes
    description: ""
  }

  dimension: fullVisitorId {
    label: "Full Visitor ID"
    hidden: yes
  }



    dimension: visitnumber {
      label: "Session Number"
      type: number
      description: "The session number for this user. If this is the first session, then this is set to 1."
    }

    dimension: first_time_visitor {
      label: "New User"
      type: yesno
      sql: ${visitnumber} = 1 ;;
      description: "New Users are those navigating to the site for the first time on a specific device. Yes, if session number = 1. "
    }

    dimension: visitnumbertier {
      label: "Session Number Tier"
      type: tier
      tiers: [1,2,5,10,15,20,50,100]
      style: integer
      sql: ${visitnumber} ;;
      description: "Tiers are based on the number of site visits a user has had on a specific device."
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
      label: "Session Start Date"
      type: time
      sql: (TIMESTAMP(${partition_date})) ;;
      description: "Date of a user's session. Currently, based on the partition date, or the date of the daily data ingestion/arrival."
    }

    ## use visit or hit start time instead
    dimension: date {
      hidden: yes
    }

    dimension: socialEngagementType {
      label: "Social Engagement Type"
      hidden: yes
    }

    dimension: userid {
      hidden: yes ## this is not the actual user_id, it is derived from custom fields
    }

    dimension: channelGrouping {
      view_label: "Marketing Attribution"
      label: "Marketing Channel Summary"
      description: "Session and hit data summaries based on the attributed marketing channel."
    }

  dimension: traffic_source{
    view_label: "Marketing Attribution"
    label: "Traffic Source"
    type: string
    sql:  lower(concat(${trafficSource.source}, " / ", ${channelGrouping}));;
    description: "Specific origin of all referrals to our site. Possible sources include google, facebook.com, or pinterest. The source is then concatinated by the overarching marketing channel."
  }

##
### Custom Session-Level Dimensions
##

dimension: the_real_user_id {
  label: "User ID"
  type: number
  sql: (
    select
      cast(safe_cast(d.value as float64) as int64) as user_id
    from UNNEST(${TABLE}.customDimensions) as d
    where d.index = 2
      and d.value is not null
  ) ;;
  value_format: "0"
  description: "User Id as defined in the data warehouse. Imported into GA as a custom dimension."
}

  dimension: channelType {
    view_label: "Marketing Attribution"
    label: "Channel Type"
    type: string
    sql:  case
      when ${channelGrouping} IN ( 'display' , 'social performance' , 'paid search' ) then 'paid'
      when ${channelGrouping} IN ( 'affiliates' , 'big partners' , 'instructor' , 'external email' ) then 'biz dev'
        else 'unpaid'
        end ;;
    description: "Groupings of marketing channels into paid, biz dev & unpaid."
  }

  dimension: subscription_type {
    view_label: "Unlimited Subscription"
    label: "Subscription Type"
    type: string
    sql: case when ${hits_eventInfo.eventCategory} = 'membership signup step' and ${hits_eventInfo.eventAction} = 'trial started' then 'trial'
            when ${hits_eventInfo.eventCategory} = 'membership signup step' and ${hits_eventInfo.eventAction} = 'no trial activation' then 'paid sub'
         end;;
  }

  dimension: subscription_plan_type {
    view_label: "Unlimited Subscription"
    label: "Subscription Plan Type"
    type: string
    sql: case when ${hits_eventInfo.eventCategory} = 'membership signup step' and REGEXP_CONTAINS(${hits_eventInfo.eventLabel}, r'(.*)year(.*)') then 'year'
            when ${hits_eventInfo.eventCategory} = 'membership signup step' and REGEXP_CONTAINS(${hits_eventInfo.eventLabel}, r'(.*)month(.*)') then 'month'
            else 'month'
         end
    ;;
  }

dimension: live_sub_session  {
  view_label: "Unlimited Subscription"
  type: string
  sql: case when (${unlimited_active} = '1' or ${unlimited_active} = 'true')
            and ${hits_eventInfo.eventAction} != 'no trial activation'
            and ${hits_eventInfo.eventAction} != 'trial started' then 'yes'
          else 'no'
       end;;
}

  dimension: digital_segment {
    view_label: "Sessions"
    label: "Digital Segment"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 90 and s.value is not null
    );;
  }

  dimension: digital_segment_type {
    label: "Digital Segment Type"
    type: string
    sql:case when REGEXP_CONTAINS(${digital_segment}, r'.*NEVER.*') then "NEVER"
        when REGEXP_CONTAINS(${digital_segment}, r'.*LAPSED.*') then "LAPSED"
        else ${digital_segment} end;;
  }


measure: coupon_success_count {
  view_label: "Coupon"
  type: count_distinct
  sql: case when ${hits_customdimensions.coupon_failure_message} is null then ${id}
          end;;
}

measure: coupon_failure_count {
  view_label: "Coupon"
  type: count_distinct
  sql: case when ${hits_customdimensions.coupon_failure_message} is not null then ${id}
          end;;
}

measure: total_coupon_tries {
  view_label: "Coupon"
  type: number
  sql: ${coupon_failure_count} + ${coupon_success_count};;
}

measure: coupon_success_rate {
  view_label: "Coupon"
  type: number
  value_format: "0.00%"
  sql: ${coupon_success_count} / ${total_coupon_tries} ;;
}

  measure: course_LDP_view {
    view_label: "Sessions"
    label: "Course LDP View"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'listing detail page'
      and ${hits.eventInfo}.eventaction = 'course'
      and ${hits.eventInfo}.eventlabel = 'free: no + seller: craftsy' then ${id} end
       ;;
  }

##
### Custom Session-Level Measures
##

## Conversion Rates for Goals
  measure: goal_view_paid_listing_conversion_rate {
    view_label: "Goals"
    label: "Goal 16: View Paid Listing Conversion Rate"
    type: number
    value_format_name: percent_1
    sql: ${goal_view_paid_listing} / ${distinct_sessions};;
  }

  measure: goal_subscription_conversion_rate {
    label: "Goal 13: Subscription Conversion Rate"
    view_label: "Goals"
    type: number
    value_format_name: percent_1
    sql: ${goal_subscription} / ${distinct_sessions};;
  }

  measure: membership_goal_trail_start_conversion_rate {
    label: "Goal 1: Trial Start Conversion Rate"
    view_label: "Membership Acquisition Goals"
    type: number
    value_format_name: percent_1
    sql: ${membership_goal_trial_start} / ${membership_sessions};;
  }



  measure: session_trends {
    view_label: "Sessions"
    type: count_distinct
    sql: case when ${hits_page.hostName} in ('unlimited.craftsy.com', 'landing.craftsy.com') then ${id}
        end ;;
  }


## Goals
  measure: goal_paid_purchase {
    view_label: "Goals"
    label: "Goal 1: Paid Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating' then ${id}
       end;;
  }

  measure: goal_course_purchase {
    view_label: "Goals"
    label: "Goal 2: Course Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'(new|repeat) course') then ${id}
       end;;
  }

  measure: goal_supplies_purchase {
    view_label: "Goals"
    label: "Goal 3: Supplies Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'(new|repeat) supply') then ${id}
       end;;
  }

  measure: goal_new_buyer {
    view_label: "Goals"
    label: "Goal 4: New Buyer"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and ${hits.eventInfo}.eventaction = 'buyer type: new' then ${id}
       end;;
  }

  measure: goal_repeat_purchase {
    view_label: "Goals"
    label: "Goal 5: Repeat Purchase"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and ${hits.eventInfo}.eventaction = 'buyer type: repeat' then ${id}
       end;;
  }

  measure: goal_paid_add_to_cart {
    view_label: "Goals"
    label: "Goal 6: Paid Add-to-Cart"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'listing cart add'
       and ${hits.eventInfo}.eventlabel = 'free: yes + seller: craftsy' then ${id}
       end;;
  }

  measure: goal_course_activation {
    view_label: "Goals"
    label: "Goal 7: Course Activation"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'.*new course.*') then ${id}
       end;;
  }

  measure: goal_course_activity {
    view_label: "Goals"
    label: "Goal 8: Course Activity"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel,r'.*repeat course.*') then ${id}
       end;;
  }

  measure: goal_supply_activation {
    view_label: "Goals"
    label: "Goal 9: Supply Activation"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel,r'.*new supply.*') then ${id}
       end;;
  }

  measure: goal_supply_activity {
    view_label: "Goals"
    label: "Goal 10: Supply Activity"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction revenue generating'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel, r'.*repeat supply.*') then ${id}
       end;;
  }

  measure: goal_subscription {
    view_label: "Goals"
    label: "Goal 13: Subscription"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step'
        and REGEXP_CONTAINS(${hits.eventInfo}.eventaction, r'(trial started|no trial activation)') then ${id}
        end;;
  }

  measure: goal_view_paid_listing {
    view_label: "Goals"
    label: "Goal 16: View Paid Listing"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'listing detail page'
        and ${hits.eventInfo}.eventlabel = 'free: no + seller: craftsy' then ${id}
        end;;
  }

  measure: goal_register {
    view_label: "Goals"
    label: "Goal 17: Register"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'account create'
        and REGEXP_CONTAINS(${hits.eventInfo}.eventaction, r'^success.*') then ${id}
        end;;
  }

  measure: goal_blog_subscribe {
    view_label: "Goals"
    label: "Goal 18: Blog Subscribe"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'blog subscription' then ${id}
        end;;
  }

  measure: goal_free_transaction {
    view_label: "Goals"
    label: "Goal 19: Free Transaction"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'transaction non-revenue generating' then ${id}
        end;;
  }

##
### Membership Logged-In Goals
##
  measure: membership_goal_viewed_video_player {
    view_label: "Membership Logged-In Goals"
    label: "Goal 3: Viewed Video Player"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'video player content' then ${id}
       end;;
  }

  measure: membership_goal_used_site_search {
    view_label: "Membership Logged-In Goals"
    label: "Goal 5: Used Site Search"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'site search results'
      and REGEXP_CONTAINS(${hits_page.hostName}, r'.*(unlimited|landing|membership).*') then ${id}
       end;;
  }

  measure: membership_goal_material_download {
    view_label: "Membership Logged-In Goals"
    label: "Goal 6: Material Download"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'material download' then ${id}
       end;;
  }

## Membership Acquisition Goals
  measure: membership_goal_trial_start {
    view_label: "Membership Acquisition Goals"
    label: "Goal 1: Trial Start"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step'
      and ${hits.eventInfo}.eventaction = 'trial started'
      and REGEXP_CONTAINS(${hits_page.hostName}, r'.*(unlimited|landing|membership).*') then ${id}
       end;;
  }

  measure: membership_goal_register {
    view_label: "Membership Acquisition Goals"
    label: "Goal 2: Register"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'account create'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventaction, r'^success.*')
      and REGEXP_CONTAINS(${hits_page.hostName}, r'.*(unlimited|landing|membership).*') then ${id}
       end;;
  }

  measure: membership_goal_start_signup {
    view_label: "Membership Acquisition Goals"
    label: "Goal 4: Start Signup"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step' then ${id}
       end;;
  }

  measure: membership_goal_select_payment_method {
    view_label: "Membership Acquisition Goals"
    label: "Goal 7: Select Payment Method"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step'
       and ${hits.eventInfo}.eventaction = 'select payment method' then ${id}
       end;;
  }

  measure: membership_goal_selected_plan {
    view_label: "Membership Acquisition Goals"
    label: "Goal 8: Selected Plan"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel,r'(year|month)') then ${id}
       end;;
  }

  measure: membership_goal_trial_start_monthly {
    view_label: "Membership Acquisition Goals"
    label: "Goal 9: Trial Start Monthly"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step'
       and ${hits.eventInfo}.eventaction = 'trial started'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel,r'.*month.*') then ${id}
       end;;
  }

  measure: membership_goal_trial_start_annual {
    view_label: "Membership Acquisition Goals"
    label: "Goal 10: Trial Start Annual"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step'
       and ${hits.eventInfo}.eventaction = 'trial started'
       and REGEXP_CONTAINS(${hits.eventInfo}.eventlabel,r'.*year.*') then ${id}
       end;;
  }

  measure: membership_goal_no_trial_activation {
    view_label: "Membership Acquisition Goals"
    label: "Goal 11: No Trial Activation"
    type: count_distinct
    sql: case
      when ${hits.eventInfo}.eventcategory = 'membership signup step'
       and ${hits.eventInfo}.eventaction = 'no trial activation' then ${id}
       end;;
  }

## Default session level measures

    measure: distinct_sessions {
      type: count_distinct
      sql: ${id} ;;
    }

  measure: membership_sessions {
    view_label: "Membership Acquisition Goals"
    label: "Membership Sessions"
    type: count_distinct
    sql: case when REGEXP_CONTAINS(${hits_page.hostName}, r'.*(unlimited|landing|membership).*') then ${id}
        end;;
  }

  dimension: unlimited_active {
    view_label: "Unlimited Subscription"
    label: "Unlimited Active (Yes/ No)"
    type: string
    sql: (
        select
          case when s.value = '1' or s.value = 'true' then 'Yes'
             else 'No'
          end
        from ${hits.customDimensions} as s
        where s.index = 140
    );;
  }

 dimension: unlimited_active_first_hit {
  view_label: "Unlimited Subscription"
  label: "Unlimited Active First Hit (Yes/ No)"
  type: string
  sql: (
        select
          case when s.value = '1' or s.value = 'true' then 'Yes'
              else 'No'
          end
        from ${hits.customDimensions} as s
        where s.index = 140 and ${hits.hitNumber} = 1
    );;
}

  dimension: is_first_hit {
    type: string
    sql: case when ${hits.hitNumber} = 1 then 'Yes' else 'No' end;;
  }

    measure: session_count {
      type: count
      drill_fields: [fullVisitorId, visitnumber, session_count, totals.transactions_count, totals.transactionRevenue_total]
    }

    measure: unique_visitors {
      label: "Unique Users"
      type: count_distinct
      sql: ${the_real_user_id} ;;
      drill_fields: [fullVisitorId, visitnumber, session_count, totals.hits, totals.page_views, totals.timeonsite]
    }

    measure: average_sessions_per_visitor {
      label: "Average Sessions Per User"
      type: number
      sql: 1.0 * (${session_count}/NULLIF(${unique_visitors},0))  ;;
      value_format_name: decimal_2
      drill_fields: [fullVisitorId, visitnumber, session_count, totals.hits, totals.page_views, totals.timeonsite]
    }

    measure: total_visitors {
      label: "Total Users"
      type: count_distinct
      sql: ${visitId} ;;
      #drill_fields: [fullVisitorId, visitnumber, session_count, totals.hits, totals.page_views, totals.timeonsite]
    }

    measure: first_time_visitors {
      label: "New Visitors"
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

  # subrecords
  # ignore these they are the fields that we unnest into their own views
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

  dimension: hits {
    hidden:yes
  }

  dimension: hits_eventInfo {
    hidden:yes
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

view: adwordsClickInfo {
  #extends: [adwordsClickInfo_base]
}

view: sourcePropertyInfo {
  extends: [hits_sourcePropertyInfo_base]
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

  dimension: uniqueSocialInteractions {hidden: yes}

  dimension: socialInteractionNetworkAction {hidden: yes}
}
