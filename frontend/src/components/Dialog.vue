<template>
  <div class="overlay" v-show="modelValue">
    <div class="dialog">
      <div class="header">
        <span class="title">{{title}}</span>

        <button class="close" @click="close">
          <i class="el-icon">
            <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
              <path fill="currentColor" d="M764.288 214.592 512 466.88 259.712 214.592a31.936 31.936 0 0 0-45.12 45.12L466.752 512 214.528 764.224a31.936 31.936 0 1 0 45.12 45.184L512 557.184l252.288 252.288a31.936 31.936 0 0 0 45.12-45.12L557.12 512.064l252.288-252.352a31.936 31.936 0 1 0-45.12-45.184z"></path>
            </svg>
          </i>
        </button>

      </div>

      <div class="body">
        <slot/>
      </div>

      <div class="footer" ref="footer">
        <slot name="footer"/>
      </div>

    </div>

  </div>
</template>

<script lang="ts" setup>
 import { onMounted, ref, useSlots } from 'vue';

 const emit = defineEmits(['update:modelValue'])
 const props = defineProps({
   title: String,
   modelValue: Boolean
 })
 const slots = useSlots()
 const footer = ref<HTMLDivElement>()
 
 function close() {
   emit('update:modelValue', false)
 }

 onMounted(() => {
   if(slots['footer']) {
     footer.value!.style.padding = "20px"
     footer.value!.style.paddingTop = "10px"
   }
 })
</script>
<style lang="scss" scoped>
 div.overlay {
   position: fixed;
   top: 0;
   left: 0;
   right: 0;
   bottom: 0;
   z-index: 100;
   background: rgba(0, 0, 0, 0.5);

   div.dialog {
     border-radius: 4px;
     line-height: 22.4px;
     font-size: 16px;
     width: 360px;
     color: rgb(48, 49, 51);
     box-shadow: rgba(0, 0, 0, 0.04) 0px 12px 32px 4px, rgba(0, 0, 0, 0.08) 0px 8px 20px 0px;

     margin: 15vh auto 50px;
     background: white;

     div.header {
       padding: 20px;
       padding-bottom: 10px;
       text-align: left;
       position: relative;

       span.title {
	 line-height: 24px;
	 font-weight: 400;
	 font-size: 18px;
       }
     }

     div.body {
       padding:30px 20px ;
       font-size: 14px;
     }

     div.footer {
       /* padding: 20px;
	  padding-top: 10px;
	*/
       text-align: right;
     }

     button.close {
       position: absolute;
       top: 6px;
       right: 0;
       padding: 0;
       width: 54px;
       height: 54px;
       background: transparent;
       border: none;
       outline: none;
       cursor: pointer;
       font-size: 16px;

       i.el-icon {
	 color: inherit;
	 height: 1em;
	 width: 1em;
	 line-height: 1em;
	 display: inline-flex;
	 justify-content: center;
	 align-items: center;
	 position: relative;
	 fill: currentColor;

	 svg {
	   height: 1em;
	   width: 1em;
	 }
       }
       /* color: inherit;
	  height: 1em;
	  width: 1em;
	  line-height: 1em;
	  display: inline-flex;
	  justify-content: center;
	  align-items: center;
	  p */
     }
   }
   
 }
</style>