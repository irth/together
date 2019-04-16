<template>
  <div class="py-8">
    <p class="text-xl">
      <template v-if="own">
        Syncing your music library...
      </template>
      <template v-else>
        Syncing your friend's music library...
      </template>
    </p>
    <p class="text-3xl pt-2"><span class="font-semibold">{{ songs }}</span> songs found.</p>
  </div>
</template>

<script>
export default {
  props: {
    own: { type: Boolean, default: false },
    songs: { type: Number, default: 0 }
  }
};
</script>
