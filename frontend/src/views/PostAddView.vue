<template>
  <div class="add-post">
    <Navigation/>
    <div>
      标题
      <input type="text" v-model="title">

      <select v-model="category">
        <template v-for="(_category, index) in categories" :key="index">
          <option :value="_category.name">{{_category.name}}</option>
        </template>
      </select>
    </div>

    <p>正文</p>
    <textarea v-model="body" rows="8"/>

    <div class="operate">
      <button @click="handleCancel">cancel</button>
      <button @click="handleSubmit">submit</button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import {inject, onMounted, Ref, ref} from "vue";
import {findCategories, insertPost} from "@/api";
import {useRouter} from "vue-router";
import Navigation from "@/components/Navigation.vue";

const router = useRouter();
const title = ref("")
const body = ref("")
const category = ref("default")
const categories = ref<Category[]>([])

function handleCancel() {
  router.replace({name: "home"})
}

async function handleSubmit() {
  let request: PostRequest = {
    title: title.value,
    body: body.value,
    category: category.value
  }

  try {
    await insertPost(request);
    router.replace({name: "home"})
  } catch (error: any) {
    alert(error);
    if(error.status == 401) {
      router.replace({name: "home"});
    }
  }

}

onMounted(async () => {
  try {
    categories.value = await findCategories();
  } catch (error: any) {
    alert(error.data["message"]);
    if(error.status == 401) {
      router.replace({name: "login"});
    }
  }
})
</script>

<style lang="scss" scoped>
div.add-post {
  display: flex;
  flex-direction: column;
}
</style>