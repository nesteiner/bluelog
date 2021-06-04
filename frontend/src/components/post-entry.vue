<template>
  <div class="post-entry" @click="handler">
    {{ title }}
    {{ content }}
  </div>
</template>

<script lang="ts">
 import {Vue, Prop} from 'vue-property-decorator'

 export default class PostEntry extends Vue {
   @Prop()
   postid !: number

   @Prop()
   title !: string

   @Prop()
   author !: string

   @Prop()
   content !: string

   public handler(): void {
     this.$router.push({
       name: 'post',
       params: {
	 postid: this.postid,
	 title: this.title,
	 author: this.author,
	 content: this.content,
       }
     })
   }
 }
</script>

<style scoped>
 div.post-entry {
   border: 1px solid black;
   cursor: pointer;
 }
</style>