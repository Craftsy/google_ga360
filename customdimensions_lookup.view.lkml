view: customdimensions_lookup {
  derived_table: {
    sql:
        select 3 as index, 'Event Batch Id' as value union all
        select 14, 'Transaction Type' union all
        select 18, 'Account Form Type' union all
        select 19, 'Account Form Experience' union all
        select 20, 'Account Form Content Trigger' union all
        select 21, 'Logged In' union all
        select 26, 'Account Form Trigger' union all
        select 27, 'Full Url' union all
        select 28, 'Canonical URL' union all
        select 29, 'Site Section' union all
        select 30, 'Nav Category' union all
        select 31, 'Previous Nav Category' union all
        select 32, 'Page Type' union all
        select 33, 'Filter Set' union all
        select 34, 'Filter Name' union all
        select 35, 'Referrer' union all
        select 36, 'Account Form Message' union all
        select 37, 'Development Environment' union all
        select 38, 'Search Term' union all
        select 39, 'Sort Id' union all
        select 40, 'Sort Option' union all
        select 52, 'Payment Method' union all
        select 57, 'GTM Container Id + Version' union all
        select 58, 'Content Key' union all
        select 61, 'gift' union all
        select 64, 'Cart id' union all
        select 65, 'Coupon (Transaction)' union all
        select 66, 'Gallery Id' union all
        select 67, 'Gallery Name' union all
        select 68, 'Gallery Type' union all
        select 69, 'Product List' union all
        select 70, 'Transaction Id (Product)' union all
        select 71, 'Gallery Revision Id' union all
        select 72, 'Transaction Id (Hit)' union all
        select 74, 'GTM Event' union all
        select 75, 'Blog Author' union all
        select 76, 'Blog Category' union all
        select 77, 'Blog Post Id' union all
        select 78, 'Blog Page Type' union all
        select 79, 'Blog Publish Date' union all
        select 80, 'Blog SEO Title' union all
        select 81, 'Video Playlist Id' union all
        select 82, 'Video Playlist Name' union all
        select 83, 'Video Episode Id' union all
        select 84, 'Video Episode Name' union all
        select 85, 'Video Entrance Component' union all
        select 86, 'Material Id' union all
        select 87, 'Material Name' union all
        select 88, 'Course Video Action' union all
        select 89, 'Course Video Watch Time' union all
        select 96, 'Skill Level' union all
        select 97, 'Project Associated Listing' union all
        select 98, 'Project Associated Listing Product Line' union all
        select 99, 'Project ID' union all
        select 100, 'Project Name' union all
        select 101, 'Project Category' union all
        select 104, 'Gallery Sort Order' union all
        select 105, 'Gallery Page Number' union all
        select 106, 'Gallery Content Type' union all
        select 107, 'Engagement Action' union all
        select 108, 'Engagement Content Type' union all
        select 109, 'Engagement Content Name' union all
        select 110, 'Engagement Content Id' union all
        select 111, 'Engagement Content Category' union all
        select 112, 'Coupon Code Entered' union all
        select 113, 'Coupon Entry Method' union all
        select 114, 'Coupon Failure Message' union all
        select 115, 'Site Search Term' union all
        select 116, 'Site Search Num Results' union all
        select 117, 'Currency Conversion Rate' union all
        select 119, 'In-App Purchase' union all
        select 120, 'Social Share Service' union all
        select 122, 'Feature Gallery Widget Type' union all
        select 123, 'Feature Gallery Widget Title' union all
        select 124, 'Feature Gallery Widget Position' union all
        select 125, 'Feature Gallery Total Widgets' union all
        select 127, 'Internal Campaign (Hit)' union all
        select 128, 'Debug 1' union all
        select 129, 'Debug 2' union all
        select 130, 'Debug 3' union all
        select 134, 'Site Search Entry Method' union all
        select 137, 'Experiment Variant Reason' union all
        select 138, 'Experiment Inputs' union all
        select 140, 'Unlimited Active' union all
        select 147, 'Offer Code'
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: index {
    type: number
    sql: ${TABLE}.index ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }

}
