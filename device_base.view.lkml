view: device_base {
    extension: required

    dimension: browser {
    }

    dimension: browserVersion {
      label:"Browser Version"
    }

    dimension: operatingSystem {
      label: "Operating System"
    }

    dimension: operatingSystemVersion {
      label: "Operating System Version"
    }

    dimension: isMobile {
      label: "Mobile"
      type: yesno
    }

    dimension: flashVersion {
      label: "Flash Version"
    }

    dimension: javaEnabled {
      label: "Java Enabled"
      type: yesno
    }

    dimension: language {}

    dimension: screenColors {
      label: "Screen Colors"
    }

    dimension: screenResolution {
      label: "Screen Resolution"
    }

    dimension: mobileDeviceBranding {
      label: "Mobile Device Branding"
    }

    dimension: mobileDeviceInfo {
      label: "Mobile Device Info"
    }

    dimension: mobileDeviceMarketingName {
      label: "Mobile Device Marketing Name"
    }

    dimension: mobileDeviceModel {
      label: "Mobile Device Model"
    }

    dimension: mobileDeviceInputSelector {
      label: "Mobile Device Input Selector"
    }
}
