<template>
  <div>
    <p class="text-lg font-bold">Send this link to your friend to begin:</p>
    <div class="py-2">
      <a v-bind:href="href" class="text-white break-words">{{ href }}</a>
    </div>
    <p class="italic font-small text-grey">
      (<b>right click</b> or <b>long press</b> the link, then select
      <b>"Copy&nbsp;link&nbsp;address"</b> or similar.)
    </p>
  </div>
</template>

<script>
export default {
  props: ["href"]
};
</script>