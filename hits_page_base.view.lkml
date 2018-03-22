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

  dimension: hostName {
    label: "Host Name"
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
