<template>
  <div class="post">
    <Navigation/>
    <div class="header">
      <h1>{{post.title}}</h1>

      <p>
        <small>{{post.author.name}}</small>
        <br/>
        <small>{{post.author.email}}</small>
      </p>
    </div>

    <div class="body" v-html="post.body"/>

    <div class="comments">
      <template v-for="(comment, index) in post.comments" :key="index">
        <Comment :id="comment.id" :user="comment.user" :body="comment.body" :timestamp="comment.timestamp"/>
      </template>
    </div>
  </div>
</template>

<script lang="ts" setup>
import {useRoute, useRouter} from "vue-router";
import {onMounted, ref} from "vue";
import {findPost} from "@/api";
import Comment from "@/components/Comment.vue"
import Navigation from "@/components/Navigation.vue";
const route = useRoute();
const router = useRouter();

const postid = route.params["id"];
const post = ref<Post>({
  id: 0,
  title: "Loading",
  body: "Loading",
  timestamp: "",
  author: {
    id: 0,
    name: "",
    email: ""
  },
  category: {
    id: 0,
    name: ""
  },
  comments: []
})


onMounted(async () => {
  try {
    post.value = await findPost(parseInt(postid as string));
  } catch (error: any) {
    console.log(error)
    alert(error.data["message"]);
    if(error.status == 401) {
      router.replace({name: "login"})
    }
  }

})
</script>

<style lang="scss" scoped>
div.post {
  div.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
}
</style>