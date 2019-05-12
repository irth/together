<template>
  <div>
    <InviteLink v-bind:href="link" v-if="!full" />
    <div v-if="full">
      <SyncStatus v-if="syncing" own v-bind:songs="songs" />
      <div v-else-if="lastSyncedAt == null" class="text-xl">
        <p>You haven't synced your music library yet.</p>
        <p>
          <a v-on:click="sync" href="#" class="big-round-button">Sync now.</a>
        </p>
      </div>
      <SyncStatus v-else-if="syncingOther" v-bind:songs="songsOther" />
      <div v-else-if="lastSyncedAtOther == null" class="text-lg">
        Waiting for your friend to sync their music library.
      </div>
      <div v-else-if="this.tracks.length == 0">
        <p>Unfortunately, we couldn't find songs that you both like :(</p>
        <p>
          Try
          <a href="#" v-on:click="sync" class="text-spotify-green"
            >re-syncing your library</a
          >
          if you've added any new songs recently.
        </p>
      </div>
      <div v-else>
        <p class="text-xl">
          We have found
          <span class="text-spotify-green">{{ this.tracks.length }} songs</span>
          that both you and
          <span class="text-spotify-green">{{
            this.displayNameOther || "your friend"
          }}</span>
          like!
        </p>
        <p class="py-4">
          <a v-bind:href="playlistSaveURL" class="round-button"
            >Save to Spotify</a
          >
        </p>
        <Tracklist
          v-bind:tracks="tracks"
          v-bind:tracksPerPage="10"
          class="pt-2 pb-4"
        />
        <p>
          You can also try
          <a href="#" v-on:click="sync" class="text-spotify-green"
            >re-syncing your library</a
          >
          if you've added any new songs recently.
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axiosCSRF.js";

import InviteLink from "./InviteLink.vue";
import SyncStatus from "./SyncStatus.vue";
import Tracklist from "./Tracklist.vue";

export default {
  props: ["initialData"],
  components: { InviteLink, SyncStatus, Tracklist },

  data: function() {
    return {
      syncing: false,
      songs: 0,
      syncingOther: false,
      songsOther: 0,
      ...this.initialData
    };
  },

  methods: {
    sync(e) {
      e.preventDefault();
      axios.post(`/sync/start?playlist=${this.playlistID}`);
    },

    onJoin(e) {
      const { user, lastSyncedAt, displayName, tracks } = e;
      if (user === this.currentUser) return;
      this.otherUser = user;
      this.displayNameOther = displayName;
      this.lastSyncedAtOther = lastSyncedAt;
      this.tracks = tracks;
      this.full = true;
    },

    onSyncUpdate(e) {
      const { user, songs } = e;
      if (user === this.currentUser) {
        this.songs = songs;
        this.syncing = true;
      } else {
        this.songsOther = songs;
        this.syncingOther = true;
      }
    },

    onSyncDone(e) {
      const { user, lastSyncedAt, tracks } = e;
      if (user === this.currentUser) {
        this.syncing = false;
        this.lastSyncedAt = lastSyncedAt;
      } else {
        this.syncingOther = false;
        this.lastSyncedAtOther = lastSyncedAt;
      }
      this.tracks = tracks;
    }
  },

  mounted() {
    window.App.cable.subscriptions.create(
      {
        channel: "PlaylistStatusChannel",
        playlist_id: this.playlistID
      },
      {
        connected: function() {
          console.log("Connected to the server.");
        },

        disconnected: function() {},

        received: data => {
          console.log("received", data);
          const { event } = data;

          if (event === "join") {
            this.onJoin(data);
          } else if (event === "sync_start") {
            this.onSyncUpdate({ ...data, songs: 0 });
          } else if (event === "sync_update") {
            this.onSyncUpdate(data);
          } else if (event === "sync_done") {
            this.onSyncDone(data);
          }
        }
      }
    );
  }
};
</script>

<style>
</style>
