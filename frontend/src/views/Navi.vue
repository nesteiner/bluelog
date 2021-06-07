<template>
  <div class="navi">
    <span class="navi-item">
      <router-link :to="{name: 'Home'}">Home</router-link>
      <router-link :to="{name: 'Logout'}">Logout</router-link>
    </span>

    <span class="user">
      {{ username }}
    </span>
  </div>
</template>

<script lang="ts">
 import {Vue, Prop} from 'vue-property-decorator'

 export default class Navi extends Vue {
   @Prop()
   username !: string

 }

</script>

<style scoped>
 div.navi {
   background: #2780E3;
   padding: 16px 8px;

   display: flex;
   justify-content: space-around;

   margin-bottom: 20px;
 }

 span.navi-item {
   display: flex;
   justify-content: flex-start;
 }

 span.navi-item a {
   margin: 0 4px;
   color: white;
   text-decoration: none;
 }
</style>