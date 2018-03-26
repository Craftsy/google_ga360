connection: "bigquery_ga_sessions"

# include all the views from the bigquery_ga_sessions project
include: "*.view.lkml"

# include all the dashboards from the bigqury_ga_sessions project
include: "*.dashboard.lkml"

#include: "/data_virtuality/*.view.lkml"

include: "/data_virtuality/dim_customer.view"

explore: ga_sessions {
  label: "Google Anayltics Sessions"
  extends: [ga_sessions_explore]

#  join: dim_customer {
#    relationship: one_to_one
#    sql_on: ${dim_customer.user_id} = ${ga_sessions.userid} ;;
#  }
}
