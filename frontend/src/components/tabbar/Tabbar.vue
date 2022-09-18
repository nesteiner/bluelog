<template>
  <div class="tabbar">
    <div class="names row">
      <template v-for="(name, index) in names" :key="index">
        <div
          @click="clickItem(name)"
          :class="{active: activeName == name}">
          {{name}}
        </div>
      </template>
    </div>

    <div class="content">
      <slot/>
    </div>
  </div>
</template>

<script lang="ts" setup>
 import {ref, provide} from 'vue'

 const props = defineProps({
   activeName: String
 })

 const activeName = ref<string>(props.activeName!)

 const names = ref<string[]>([])

 provide('activeName', activeName)
 provide('names', names)

 function clickItem(name: string) {
   activeName.value = name
 }
</script>

<style lang="scss" scoped>
 div.tabbar {
   box-sizing: border-box;
   border: 1px solid #dcdfe6;
   border-radius: 4px;
   padding: 1.5rem;
   margin: .5px;

   div.names.row {
     display: flex;
     justify-content: flex-start;
     align-items: center;

     height: 40px;

     line-height: 40px;
     font-size: 14px;
     font-weight: 500;
     border-bottom: 1px solid #dcdfe6;

     div {
       display: block;
       width: 100px;
       cursor: pointer;
       border: 1px solid #dcdfe6;

       &.active {
         color: rgb(64, 158, 255);
         border-bottom: 1px solid white;
       }
     }

   }

   div.content {
     padding: 25px 25px 25px 10px;
   }
 }
</style>
