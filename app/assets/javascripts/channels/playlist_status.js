$(document).on("turbolinks:load", function() {
  el = $('[data-behavior="sync_status"]');
  if (el.length == 0) return;

  App.sync_status = App.cable.subscriptions.create(
    {
      channel: "PlaylistStatusChannel",
      playlist_id: parseInt(el.data("playlist-id"))
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
        if (data["type"] == "sync_status")
          $(
            '[data-behavior="sync_status"][data-user="' + data["user"] + '"]'
          ).html(data["html"]);
      }
    }
  );
});
