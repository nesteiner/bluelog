<template>
  <div class="post-view">
    {{ postid }} <br>
    {{ title }} <br>
    {{ author }} <br>
    {{ content }} <br>
  </div>
</template>

<script lang="ts">
 import {Vue} from 'vue-property-decorator'
 
 export default class PostView extends Vue{
   postid = -1
   title = ''
   author = ''
   content = ''

   mounted(): void {
     let params = this.$route.params
     this.postid = parseInt(params.postid as string)
     this.title = params.title as string
     this.author = params.author as string
     this.content = params.content as string
   }
 }
</script>