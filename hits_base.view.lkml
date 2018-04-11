view: hits_base {
    extension: required

    dimension: id {
      primary_key: yes
      sql: CONCAT(${ga_sessions.id},'|',FORMAT('%05d',${hitNumber})) ;;
    }

    dimension: hitNumber {}

    dimension: time {}

    dimension_group: hit {
      timeframes: [date,day_of_week,fiscal_quarter,week,month,year,month_name,month_num,week_of_year]
      type: time
      sql: TIMESTAMP_MILLIS(${ga_sessions.visitStartSeconds}*1000 + ${TABLE}.time) ;;
    }

    dimension: hour {}

    dimension: minute {}

    dimension: isSecure {
      label: "Is Secure"
      type: yesno
    }

    dimension: isiInteraction {
      label: "Is Interaction"
      type: yesno
    }

    dimension: referer {
      label: "Referer"
      type: string
    }

    measure: count {
      type: count
      drill_fields: [hits.detail*]
    }

    # subrecords
    dimension: page {hidden:yes}
    dimension: transaction {hidden:yes}
    dimension: item {hidden:yes}
    dimension: contentinfo {hidden:yes}
    dimension: social {hidden: yes}
    dimension: publisher {hidden: yes}
    dimension: appInfo {hidden: yes}
    dimension: contentInfo {hidden: yes}
    dimension: customDimensions {hidden: yes}
    dimension: customMetrics {hidden: yes}
    dimension: customVariables {hidden: yes}
    dimension: ecommerceAction {hidden: yes}
    dimension: eventInfo {hidden:yes}
    dimension: exceptionInfo {hidden: yes}
    dimension: experiment {hidden: yes}

    set: detail {
      fields: [ga_sessions.id, ga_sessions.visitnumber, ga_sessions.session_count, hits_page.pagePath, hits.pageTitle]
    }
}
