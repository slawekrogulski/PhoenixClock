export const hooks = {
    LocalTimeZone: {
      mounted() {
        let localTz = Intl.DateTimeFormat().resolvedOptions().timeZone
        this.pushEvent("local-timezone", {local_timezone: localTz})
      }
    }
  }
  