$(document).on("turbolinks:load", function() {
  el = $('[data-behavior="sync_status"][data-self]');
  if (el.length == 0) return;
  current_user = el.data("user");

  let playlist_ready = el.data("ready");
  console.log(playlist_ready);
  App.sync_status = App.cable.subscriptions.create(
    {
      channel: "PlaylistStatusChannel",
      playlist_id: el.data("playlist-id")
    },
    {
      connected: function() {
        // Called when the subscription is ready for use on the server
        console.log("connected to the PlaylistStatusChannel");
      },

      disconnected: function() {
        // Called when the subscription has been terminated by the server
      },

      received: function(data) {
        console.log("received", data);
        if (data["type"] === "sync_status") {
          $(
            '[data-behavior="sync_status"][data-user="' + data["user"] + '"]'
          ).html(data["html"]);
        } else if (
          (data["type"] === "join_event" && data["user"] != current_user) ||
          (data["type"] === "playlist_ready" && !playlist_ready)
        ) {
          Turbolinks.visit(window.location.href);
        }
      }
    }
  );
});
