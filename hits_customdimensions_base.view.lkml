view: hits_customdimensions_base {
    extension: required

  dimension: coupon_code {
    label: "Coupon Code"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 112
    );;
  }

  dimension: coupon_entry_method {
    label: "Coupon Entry Method"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 113
    );;
  }

  dimension: coupon_failure_message {
    label: "Coupon Failure Message"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 114
    );;
  }

  dimension: gallery_sort_order {
    label: "Gallery Sort Order"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 104
    );;
  }

  dimension: gallery_page_number {
    label: "Gallery Page Number"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 105
    );;
  }

  dimension: gallery_content_type {
    label: "Gallery Content Type"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 106
    );;
  }

  dimension: feature_gallery_widget_type {
    label: "Feature Gallery Widget Type"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 122
    );;
  }

  dimension: feature_gallery_widget_title {
    label: "Gallery Widget Title"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 123
    );;
  }

  dimension: feature_gallery_widget_position {
    label: "Feature Gallery Widget Position"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 124
    );;
  }

  dimension: feature_gallery_total_widgets {
    label: "Feature Gallery Total Widgets"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 125
    );;
  }

  dimension: site_search_term {
    label: "Site Search Term"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 115
    );;
  }

  dimension: site_search_term_num_results {
    label: "Site Search Term Number of Results"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 116
    );;
  }


}
