<template>
  <div class="comment">
    <h5>{{user.name}}</h5>
    <p>{{body}}</p>
    <small>{{timestamp}}</small>
  </div>
</template>

<script lang="ts" setup>
defineProps<{
  id: number,
  user: {
    id: number,
    name: string,
    email: string,
  },

  body: string,
  timestamp: string
}>()
</script>

<style lang="scss" scoped>
div.comment {
  border: 1px solid rgba(0, 0, 0, 0.12);
}
</style>