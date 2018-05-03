connection: "bigquery_ga_sessions"

# include all the views from the bigquery_ga_sessions project
include: "*.view.lkml"

# include all the dashboards from the bigqury_ga_sessions project
include: "*.dashboard.lkml"
persist_for: "24 hours"



explore: ga_sessions {
  # persist_for: "1 hour"
  from: ga_sessions
  label: "Google Analytics Sessions"
  view_label: "Sessions"

  always_filter: {
    filters: {
      field: ga_sessions.partition_date
      value: "7 days ago for 7 days"
      ## Partition Date should always be set to a recent date to avoid runaway queries
    }
  }

  ##
  ### Joins
  ##
  join: totals {
    view_label: "Behavior Metrics"
    sql: LEFT JOIN UNNEST([${ga_sessions.totals}]) as totals ;;
    relationship: one_to_one
  }
  join: trafficSource {
    view_label: "Marketing Attribution"
    sql: LEFT JOIN UNNEST([${ga_sessions.trafficSource}]) as trafficSource ;;
    relationship: one_to_one
  }

  join: device {
    view_label: "Device"
    sql: LEFT JOIN UNNEST([${ga_sessions.device}]) as device ;;
    relationship: one_to_one
  }
  join: geoNetwork {
    view_label: "Geo-Network"
    sql: LEFT JOIN UNNEST([${ga_sessions.geoNetwork}]) as geoNetwork ;;
    relationship: one_to_one
  }
  join: hits {
    view_label: "Hits"
    sql: LEFT JOIN UNNEST(${ga_sessions.hits}) as hits ;;
    relationship: one_to_many
  }
  join: hits_page {
    view_label: "Page"
    sql: LEFT JOIN UNNEST([${hits.page}]) as hits_page ;;
    relationship: one_to_one
  }
  join: hits_transaction {
    view_label: "Transaction"
    sql: LEFT JOIN UNNEST([${hits.transaction}]) as hits_transaction ;;
    relationship: one_to_one
  }
  join: hits_item {
    view_label: "Item"
    sql: LEFT JOIN UNNEST([${hits.item}]) as hits_item ;;
    relationship: one_to_one
  }
  join: hits_social {
    view_label: "Social"
    sql: LEFT JOIN UNNEST([${hits.social}]) as hits_social ;;
    relationship: one_to_one
  }
  join: hits_publisher {
    view_label: "Publisher"
    sql: LEFT JOIN UNNEST([${hits.publisher}]) as hits_publisher ;;
    relationship: one_to_one
  }
  join: hits_appInfo {
    view_label: "App Info"
    sql: LEFT JOIN UNNEST([${hits.appInfo}]) as hits_appInfo ;;
    relationship: one_to_one
  }

  join: hits_eventInfo{
    view_label: "Events Info"
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
    sql: LEFT JOIN UNNEST(${ga_sessions.hits}) as first_hit ;;
    relationship: one_to_one
    sql_where: ${first_hit.hitNumber} = 1 ;;
    fields: [first_hit.page]
  }
  join: first_page {
    view_label: "Landing Page"
    from: hits_page
    sql: LEFT JOIN UNNEST([${first_hit.page}]) as first_page ;;
    relationship: one_to_one
  }
}
