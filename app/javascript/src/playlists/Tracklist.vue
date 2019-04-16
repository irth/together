<template>
  <div class="text-center w-full">
    <div class="w-128 max-w-full text-center inline-block">
      <ul class="text-left">
        <li v-for="track in currentPage" v-bind:key="track.id" class="pb-2">
          <p class="text-sm text-grey">{{ track.artists.join(", ") }}</p>
          <p class="text-xl"><a v-bind:href="track.url" class="no-underline text-white" target="_blank" rel="noopener noreferrer">{{ track.title }}</a></p>
        </li>
      </ul>
      <div class="pt-4">
        <a v-if="page > 1" v-on:click="prevPage" href="#">prev</a>
        <a v-else class="text-grey-darkest no-underline">prev</a>
        &middot; <span>page {{ page }} out of {{ pages }}</span> &middot;
        <a v-if="page < pages" v-on:click="nextPage" href="#">next</a>
        <a v-else class="text-grey-darkest no-underline">next</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["tracks", "tracksPerPage"],

  data() {
    return { page: 1 };
  },

  methods: {
    prevPage(e) {
      e.preventDefault();
      this.page--;
    },
    nextPage(e) {
      e.preventDefault();
      this.page++;
    }
  },

  computed: {
    pages() {
      return Math.ceil(this.tracks.length / this.tracksPerPage);
    },
    currentPage() {
      const first = (this.page - 1) * this.tracksPerPage;
      const last = first + this.tracksPerPage;
      return this.tracks.slice(first, last);
    }
  }
};
</script>