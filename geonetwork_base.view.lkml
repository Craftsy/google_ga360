view: geonetwork_base {
    extension: required

    dimension: continent {
      drill_fields: [subcontinent,country,region,city,metro,approximate_networkLocation,networkLocation]
    }

    dimension: subcontinent {
      drill_fields: [country,region,city,metro,approximate_networkLocation,networkLocation]
    }

    dimension: country {
      map_layer_name: countries
      drill_fields: [region,metro,city,approximate_networkLocation,networkLocation]
    }

    dimension: region {
      drill_fields: [metro,city,approximate_networkLocation,networkLocation]
    }

    dimension: metro {
      drill_fields: [city,approximate_networkLocation,networkLocation]
    }

    dimension: city {drill_fields: [metro,approximate_networkLocation,networkLocation]}

    dimension: cityid {
      label: "City ID"
    }

    dimension: networkDomain {
      label: "Network Domain"
    }

    dimension: latitude {
      type: number
      hidden: yes
      sql: CAST(${TABLE}.latitude as FLOAT64);;
    }

    dimension: longitude {
      type: number
      hidden: yes
      sql: CAST(${TABLE}.longitude as FLOAT64);;
    }

    dimension: networkLocation {
      label: "Network Location"
    }

    dimension: location {
      type: location
      sql_latitude: ${latitude} ;;
      sql_longitude: ${longitude} ;;
    }

    dimension: approximate_networkLocation {
      label: "Approximate Network Location"
      type: location
      sql_latitude: ROUND(${latitude},1) ;;
      sql_longitude: ROUND(${longitude},1) ;;
      drill_fields: [networkLocation]
    }
}
