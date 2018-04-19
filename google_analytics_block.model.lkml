connection: "bigquery_ga_sessions"

# include all the views from the bigquery_ga_sessions project
include: "*.view.lkml"

# include all the dashboards from the bigqury_ga_sessions project
include: "*.dashboard.lkml"

explore: ga_sessions {
  label: "Google Anayltics Sessions"
  extends: [ga_sessions_explore]

}
