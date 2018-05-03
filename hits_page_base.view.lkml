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

  dimension: canonical_url {
    type: string
    sql: case when ${pagePath} like '%?%' then REGEXP_EXTRACT(${pagePath}, r'(.*)\?')
        else ${hostName}
        end;;

  }

  dimension: full_page_path {
    label: "Full Page Path"
    type: string
    sql: concat(${hostName}, ${pagePath}) ;;
  }


  dimension: hostName {
    label: "Hostname"
  }

  dimension: hostname_unlimited {
    label: "Hostname Unlimited (Yes/ No)"
    type: string
    sql: case when REGEXP_CONTAINS(${hostName},  r'.*(unlimited|landing|membership).*') then 'Yes'
          when ${hostName} is null then 'Yes'
          else 'No'
        end;;
  }

  dimension: page_type{
    label: "Page Type"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 32
    );;
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
