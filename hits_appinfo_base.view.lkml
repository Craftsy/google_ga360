view: hits_appinfo_base {
    extension: required

    dimension: name {
      hidden: yes # this is the same as app_name
    }

    dimension: version {
      hidden: yes # this is the same as app_version
    }

    dimension: id {
      hidden: yes # this is the same as app_id
    }

    dimension: installerId {
      label: "Installer ID"
      hidden: yes
    }

    dimension: appInstallerId {
      label: "App Installer ID"
      hidden: yes # not meaningful
    }

    dimension: appName {
      label: "App Name"
    }

    dimension: appVersion {
      label: "App Version"
    }

    dimension: appId {
      label: "App ID"
      hidden: yes # not meaningful
    }

    dimension: screenName {
      hidden: yes
    }
    dimension: landingScreenName {
      hidden: yes
    }

    dimension: exitScreenName {
      hidden: yes
    }

    dimension: screenDepth {
      hidden: yes
    }
}
