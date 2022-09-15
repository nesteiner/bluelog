<template>
  <div class="edit-post">
    <div>
      标题
      <input type="text" v-model="post.title">

      <select v-model="post.category.name">
        <template v-for="(_category, index) in categories" :key="index">
          <option :value="_category.name">{{_category.name}}</option>
        </template>
      </select>
    </div>

    <p>正文</p>
    <textarea v-model="post.body" rows="8"/>

    <div class="operate">
      <button @click="handleCancel">cancel</button>
      <button @click="handleSubmit">submit</button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import {useRoute, useRouter} from "vue-router";
import {onMounted, reactive, ref} from "vue";
import {findCategories, findPost, updatePost} from "@/api";

const route = useRoute();
const router = useRouter();
const postid = route.params["id"];
const post = reactive( {
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
const categories = ref<Category[]>([])

async function handleSubmit() {
  try {
    let newpost = await updatePost(post);
    router.replace({name: "home"})
  } catch (error: any) {
    alert(error.data["message"]);
    if(error.status == 401) {
      router.replace({name: "login"});
    }
  }
}

function handleCancel() {
  router.replace({name: "home"});
}

onMounted(async () => {
  try {
    let _post = await findPost(parseInt(postid as string));
    post.id = _post.id;
    post.title = _post.title;
    post.body = _post.body;
    post.author = _post.author;
    post.category = _post.category;
    post.comments = _post.comments;
    post.timestamp = _post.timestamp;

    categories.value = await findCategories();
  } catch (error: any) {
    alert(error.data["message"]);
    if(error.status == 401) {
      router.replace({name: "login"})
    }
  }

})

</script>

<style scoped>

</style>