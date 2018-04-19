view: hits_eventinfo_base {
    extension: required

    dimension: eventCategory {
      label: "Event Category"
    }

    dimension: eventAction {
      label: "Event Action"
    }

    dimension: eventLabel {
      label: "Event Label"
    }

    dimension: eventValue {
      label: "Event Value"
    }

  dimension: play {
    sql: ${eventAction} = "play" ;;
    type: yesno
    hidden: yes
  }
}
