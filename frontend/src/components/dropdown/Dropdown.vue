<template>
  <div class="dropdown">
    <div class="entry" @click="toggleDropdown">
      <svg t="1662555331996" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2380"><path d="M415.930119 223.790358c0-52.980346 43.003528-95.983874 95.983874-95.983874s95.983874 43.003528 95.983874 95.983874-43.003528 95.983874-95.983874 95.983874S415.930119 276.770704 415.930119 223.790358z" p-id="2381"></path><path d="M415.930119 511.741979c0-52.980346 43.003528-95.983874 95.983874-95.983874s95.983874 43.003528 95.983874 95.983874-43.003528 95.983874-95.983874 95.983874S415.930119 564.722325 415.930119 511.741979z" p-id="2382"></path><path d="M415.930119 799.865614c0-52.980346 43.003528-95.983874 95.983874-95.983874s95.983874 43.003528 95.983874 95.983874-43.003528 95.983874-95.983874 95.983874S415.930119 852.673946 415.930119 799.865614z" p-id="2383"></path></svg>
    </div>

    <div class="items" v-if="toggled">
      <slot/>
    </div>
  </div>
</template>

<script lang="ts" setup>
import {provide, ref} from "vue";

const toggled = ref(false);
provide("toggled", toggled);

function toggleDropdown() {
  toggled.value = !toggled.value
}
</script>

<style lang="scss" scoped>
div.dropdown {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;

  svg {
    cursor: pointer;
    width: 24px;
    height: 24px;
  }

  div.items {
    z-index: 100;
    background: white;
    max-width: 160px;
    position: absolute;
    top: 30px;

    box-shadow: 0 0 12px rgba(0, 0, 0, 0.12);
  }
}
</style>