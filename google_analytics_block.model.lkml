connection: "bigquery_ga_sessions"

# include all the views from the bigquery_ga_sessions project
include: "*.view.lkml"

# include all the dashboards from the bigqury_ga_sessions project
include: "*.dashboard.lkml"

explore: membership {
  persist_for: "1 hour"
  from: ga_sessions

  join: totals {
    view_label: "Membership Totals"
    sql: LEFT JOIN UNNEST([${membership.totals}]) as totals ;;
    relationship: one_to_one
  }

  join: hits {
    view_label: "Membership Hits"
    sql: LEFT JOIN UNNEST(${membership.hits}) as hits ;;
    relationship: one_to_many
  }

  join: hits_eventInfo{
    view_label: "Membership Events Info"
    sql: LEFT JOIN UNNEST([${hits.eventInfo}]) as hits_eventInfo ;;
    relationship: one_to_one
  }

  join: hits_customdimensions {
    view_label: "Membership Site Activity"
    sql: LEFT JOIN UNNEST(${hits.customDimensions}) as hits_customDimensions ;;
    relationship: one_to_many
  }

  join: hits_page {
    view_label: "Membership Page"
    sql: LEFT JOIN UNNEST([${hits.page}]) as hits_page ;;
    relationship: one_to_one
  }

  join: trafficSource {
    view_label: "Membership Traffic Source"
    sql: LEFT JOIN UNNEST([${membership.trafficSource}]) as trafficSource ;;
    relationship: one_to_one
  }

}

explore: sessions {
  persist_for: "1 hour"
  from: ga_sessions
  label: "Google Analytics Sessions"

  always_filter: {
    filters: {
      field: sessions.partition_date
      value: "7 days ago for 7 days"
      ## Partition Date should always be set to a recent date to avoid runaway queries
    }
  }

  ##
  ### Joins
  ##
  join: totals {
    view_label: "Session Totals"
    sql: LEFT JOIN UNNEST([${sessions.totals}]) as totals ;;
    relationship: one_to_one
  }
  join: trafficSource {
    view_label: "Session: Traffic Source"
    sql: LEFT JOIN UNNEST([${sessions.trafficSource}]) as trafficSource ;;
    relationship: one_to_one
  }

  join: device {
    view_label: "Device"
    sql: LEFT JOIN UNNEST([${sessions.device}]) as device ;;
    relationship: one_to_one
  }
  join: geoNetwork {
    view_label: "Session: Geo Network"
    sql: LEFT JOIN UNNEST([${sessions.geoNetwork}]) as geoNetwork ;;
    relationship: one_to_one
  }
  join: hits {
    view_label: "Session: Hits"
    sql: LEFT JOIN UNNEST(${sessions.hits}) as hits ;;
    relationship: one_to_many
  }
  join: hits_page {
    view_label: "Session: Hits: Page"
    sql: LEFT JOIN UNNEST([${hits.page}]) as hits_page ;;
    relationship: one_to_one
  }
  join: hits_transaction {
    view_label: "Session: Hits: Transaction"
    sql: LEFT JOIN UNNEST([${hits.transaction}]) as hits_transaction ;;
    relationship: one_to_one
  }
  join: hits_item {
    view_label: "Session: Hits: Item"
    sql: LEFT JOIN UNNEST([${hits.item}]) as hits_item ;;
    relationship: one_to_one
  }
  join: hits_social {
    view_label: "Session: Hits: Social"
    sql: LEFT JOIN UNNEST([${hits.social}]) as hits_social ;;
    relationship: one_to_one
  }
  join: hits_publisher {
    view_label: "Session: Hits: Publisher"
    sql: LEFT JOIN UNNEST([${hits.publisher}]) as hits_publisher ;;
    relationship: one_to_one
  }
  join: hits_appInfo {
    view_label: "App Info"
    sql: LEFT JOIN UNNEST([${hits.appInfo}]) as hits_appInfo ;;
    relationship: one_to_one
  }

  join: hits_eventInfo{
    view_label: "Session: Hits: Events Info"
    sql: LEFT JOIN UNNEST([${hits.eventInfo}]) as hits_eventInfo ;;
    relationship: one_to_one
  }

  join: sourcePropertyInfo {
    view_label: "Source Property Info"
    sql: LEFT JOIN UNNEST([${hits.sourcePropertyInfo}]) as sourceProperty ;;
    relationship: one_to_one
  }

  join: hits_customdimensions {
    view_label: "Site Activity"
    sql: LEFT JOIN UNNEST(${hits.customDimensions}) as hits_customDimensions ;;
    relationship: one_to_many
  }
  join: hits_customVariables{
    view_label: "Session: Hits: Custom Variables"
    sql: LEFT JOIN UNNEST(${hits.customVariables}) as hits_customVariables ;;
    relationship: one_to_many
  }
  join: first_hit {
    from: hits
    sql: LEFT JOIN UNNEST(${sessions.hits}) as first_hit ;;
    relationship: one_to_one
    sql_where: ${first_hit.hitNumber} = 1 ;;
    fields: [first_hit.page]
  }
  join: first_page {
    view_label: "Session: First Page Visited"
    from: hits_page
    sql: LEFT JOIN UNNEST([${first_hit.page}]) as first_page ;;
    relationship: one_to_one
  }
}
