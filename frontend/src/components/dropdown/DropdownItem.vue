<template>
  <div class="dropdown-items" @click="onClick">
    <slot/>
  </div>
</template>

<script lang="ts" setup>
import {inject, Ref} from "vue";

const toggled = inject<Ref<boolean>>('toggled')!;
const emits = defineEmits(["click"])

function onClick() {
  toggled.value = false;
  emits("click")
}
</script>

<style lang="scss" scoped>
div.dropdown-items {
  cursor: pointer;
  line-height: 24px;
  min-width: 64px;
  &:hover {
    background: rgba(0, 0, 0, 0.12);
  }
}
</style>