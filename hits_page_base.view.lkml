view: hits_page_base {
  extension: required

  dimension: pagePath {
    label: "Page Path"
    link: {
      label: "Link"
      url: "{{ value }}"
    }
    link: {
      label: "Page Info Dashboard"
      url: "/dashboards/101?Page%20Path={{ value | encode_uri}}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  dimension: full_page_path {
    label: "Full Page Path"
    type: string
    sql: concat(${hostName}, ${pagePath}) ;;
  }

  dimension: page_type {
    label: "Page Type"
    type: string
    sql: (
              select d.value
              from UNNEST(${TABLE}.customDimensions) as d
              where d.index = 32
                and d.value is not null
      ) ;;
  }

  dimension: hostName {
    label: "Hostname"
  }

  dimension: hostname_unlimited {
    label: "Hostname Unlimited (Yes/ No)"
    type: string
    sql: case when REGEXP_CONTAINS(${hostName},  r'unlimited.craftsy.com') then 'yes'
          when REGEXP_CONTAINS(${hostName},  r'membership.craftsy.com') then 'yes'
          when REGEXP_CONTAINS(${hostName},  r'landing.craftsy.com' ) then 'yes'
          when ${hostName} is null then 'yes'
          else 'no'
        end;;
  }

  dimension: pageTitle {
    label: "Page Title"
  }

  dimension: searchKeyword {
    label: "Search Keyword"
  }

  dimension: searchCategory{
    label: "Search Category"
  }
}
