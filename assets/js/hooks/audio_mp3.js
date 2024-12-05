/*
 * AudioMp3
 *
 * Provides browser-side and server-side functions for playing an MP3 sound.
 * Intended for short sound-effect types of audio.
 */
import { Howl } from 'howler'

export const hooks = {
  // LocalTimeZone: {
  //   mounted() {
  //     let localTz = Intl.DateTimeFormat().resolvedOptions().timeZone
  //     this.pushEvent("local-timezone", {local_timezone: localTz})
  //   }
  // },
  AudioMp3: {
    sounds: {},

    mounted() {
      let localTz = Intl.DateTimeFormat().resolvedOptions().timeZone
      this.pushEvent("local-timezone", {local_timezone: localTz})

      this.sounds = this.setupSounds(JSON.parse(this.el.dataset.sounds))

      // Received instruction from the server to play a sound
      window.addEventListener("phx:play-sound", (data) => {
        const sound = this.sounds[data.detail.name]
        const playCount = data.detail.count
        let playedCount = 0
        function onEnd() {
          playedCount++;
          if (playedCount < playCount) {
            sound.play();
          } else {
            sound.off('end', onEnd);
          }
        }
        sound.on('end', onEnd)
        sound.play()
      })

      // Local request to play a sound
      window.addEventListener("js:play-sound", (data) => {
        var name = data.detail.name
        // console.log("LOCAL PLAY:", name)
        this.playSound(name)
      })

      window.addEventListener("js:stop-sound", (data) => {
        var name = data.detail.name
        // console.log("STOP SOUND:", name)
        this.stopSound(name)
      })

      // Received server instruction to stop playing a sound
      window.addEventListener("phx:stop-sound", (data) => {
        var name = data.detail.name
        // console.log("STOP SOUND:", name)
        this.stopSound(name)
      })
    },

    destroyed() {
      Object.entries(this.sounds).forEach(entry => {
        var [key, value] = entry;
        // halts playing and releases the resource
        console.log("unloading ", key)
        value.unload();
      });
    },

    // Play the named sound
    playSound(name) {
      console.log("PLAY SOUND", name)
      console.log("SOUNDS FOR NAME", this.sounds[name])
      console.log("SOUNDS", this.sounds)
      if (this.sounds[name]) {
        this.sounds[name].play()
      }
      else {
        console.warn("PLAY: No sound \"" + name + "\" found")
      }
    },

    // Stop the named sound
    stopSound(name) {
      if (this.sounds[name]) {
        this.sounds[name].stop()
      }
      else {
        console.warn("STOP: No sound \"" + name + "\" found")
      }
    },

    // Setup the sounds. Load them as Howl objects. Return setup sound object with
    // sounds ready for playing. Key is name, Value is Howl object.
    setupSounds(obj) {
      console.log("Setup sounds object")
      Object.entries(obj).forEach(entry => {
        var [key, value] = entry;
        obj[key] = new Howl({
          src: value,
          preload: true,
          onplayerror: function () {
            console.error("FAILED to play" + key)
          }
        });
      })
      return obj
    }
  }
}
