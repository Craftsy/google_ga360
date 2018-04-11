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

  dimension: coupon_transaction {
    label: "Coupon (Transaction)"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 65
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

  dimension: logged_in {
    label: "Logged In"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 21
    );;
  }

  dimension: feature_gallery_sort_order {
    label: "Feature Gallery Sort Order"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 104
    );;
  }

  dimension: feature_gallery_page_number {
    label: "Feature Gallery Page Number"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 105
    );;
  }

  dimension: feature_gallery_name {
    label: "Feature Gallery Name"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 67
    );;
  }

  dimension: feature_gallery_id {
    label: "Feature Gallery ID"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 66
    );;
  }

  dimension: feature_gallery_type {
    label: "Feature Gallery Type"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 68
    );;
  }

  dimension: feature_gallery_content_type {
    label: "Feature Gallery Content Type"
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
    label: "Feature Gallery Widget Title"
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

  dimension: unlimited_active {
    label: "Unlimited Active"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 140
    );;
  }

  dimension: in_app_purchase {
    label: "In-App Purchase"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 119
    );;
  }

  dimension: project_associated_listing {
    label: "Project Associated Listing"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 97
    );;
  }

  dimension: project_associated_listing_product_line {
    label: "Project Associated Listing Product Line"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 98
    );;
  }

  dimension: project_id {
    label: "Project ID"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 99
    );;
  }

  dimension: project_name {
    label: "Project Name"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 100
    );;
  }

  dimension: project_category {
    label: "Project Cateory"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 101
    );;
  }

  dimension: cart_id {
    label: "Cart ID"
    type: string
    sql: (
        select s.value
        from ${hits.customDimensions} as s
        where s.index = 64
    );;
  }

  dimension: blog_author {
   label: "Blog Author"
   type: string
      sql: (
              select s.value
              from ${hits.customDimensions} as s
              where s.index = 75
      );;
  }

  dimension: blog_category {
     label: "Blog Category"
     type: string
        sql: (
                select s.value
                from ${hits.customDimensions} as s
                where s.index = 76
        );;
  }

  dimension: blog_post_id {
     label: "Blog Post Id"
     type: string
        sql: (
                select s.value
                from ${hits.customDimensions} as s
                where s.index = 77
        );;
  }

  dimension: blog_page_type {
     label: "Blog Page Type"
     type: string
        sql: (
                select s.value
                from ${hits.customDimensions} as s
                where s.index = 78
        );;
  }

  dimension: blog_publish_date {
     label: "Blog Publish Date"
     type: string
        sql: (
                select s.value
                from ${hits.customDimensions} as s
                where s.index = 79
        );;
  }

  dimension: blog_seo_title {
     label: "Blog SEO Title"
     type: string
        sql: (
                select s.value
                from ${hits.customDimensions} as s
                where s.index = 80
        );;
  }

dimension: video_playlist_id {
   label: "Video Playlist Id"
   type: string
      sql: (
              select s.value
              from ${hits.customDimensions} as s
              where s.index = 81
      );;
}

dimension: video_playlist_name {
   label: "Video Playlist Name"
   type: string
      sql: (
              select s.value
              from ${hits.customDimensions} as s
              where s.index = 82
      );;
}

dimension: video_episode_id {
   label: "Video Episode Id"
   type: string
      sql: (
              select s.value
              from ${hits.customDimensions} as s
              where s.index = 83
      );;
}

dimension: video_episode_name {
   label: "Video Episode Name"
   type: string
        sql: (
                select s.value
                from ${hits.customDimensions} as s
                where s.index = 84
        );;
}

dimension: video_entrance_component {
   label: "Video Entrance Component"
   type: string
      sql: (
              select s.value
              from ${hits.customDimensions} as s
              where s.index = 85
      );;
  }

}
