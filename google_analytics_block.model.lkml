connection: "bigquery_ga_sessions"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"


explore: ga_sessions {
  label: "Google Anayltics Sessions"
  extends: [ga_sessions_explore]
}
