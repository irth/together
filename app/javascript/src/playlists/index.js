import Vue from "vue";
import TurbolinksAdapter from "vue-turbolinks";

Vue.use(TurbolinksAdapter);

import Playlist from "./Playlist.vue";

function main() {
  const el = $('[data-behavior="playlist-view"]');
  if (el.length == 0) return;

  const nullableString = val => (val == "" ? null : val);
  const data = {
    currentUser: el.data("current-user").toString(),
    otherUser: el.data("other-user").toString(),
    displayNameOther: el.data("display-name-other"),
    full: el.data("full"),
    link: el.data("link"),
    playlistID: el.data("playlist-id").toString(),
    playlistSaveURL: el.data("playlist-save-url").toString(),
    lastSyncedAt: nullableString(el.data("last-synced-at").toString()),
    lastSyncedAtOther: nullableString(
      el.data("last-synced-at-other").toString()
    ),
    tracks: el.data("tracks")
  };

  const App = new Vue({
    el: el[0],
    render: h => h(Playlist, { props: { initialData: data } })
  });
}

$(document).on("turbolinks:load", main);
