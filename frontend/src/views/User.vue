<template>
  <div class="user-view">
    <template v-for="post in posts" :key="post.postid">
      <post-entry
	:postid="post.postid"
	:title="post.title"
	:author="post.author"
	:content="post.content"/>

    </template>
  </div>
</template>

<script lang="ts">
 import { Vue, Options } from 'vue-property-decorator'
 import axios from 'axios'
 import PostEntry from '@/components/post-entry.vue'

 interface postItem {
   postid: number,
   title: string,
   author: string,
   content: string,
 }

 @Options({
   components: {
     'post-entry': PostEntry
   }
 })
 export default class UserView extends Vue {
   posts : postItem[] = []
   
   created(): void {
     let url = 'http://localhost:5000/posts'
     // let url = 'http://localhost:8080/bluelog/posts'
     axios.post(url, {
       username: this.$route.params.username
     },	{
       withCredentials: true
     }).then(response => {
       this.posts = response.data.posts
       console.log(response.data)
     }).catch(error => {
       alert(error)
     })
   }
   
 }

</script>
