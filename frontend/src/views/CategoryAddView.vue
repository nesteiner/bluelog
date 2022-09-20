<template>
  <div class="add-category">
    <div class="form">
      <input type="text" v-model="text"/>

      <div class="operate">
        <button @click="handleCancel">cancel</button>
        <button @click="handleSubmit">submit</button>
      </div>

    </div>
  </div>
</template>

<script lang="ts" setup>
import {ref} from "vue";
import {useRouter} from "vue-router";
import {insertCategory} from "@/api";
const text = ref("")

const router = useRouter();

function handleCancel() {
  router.replace({name: "home"});
}

async function handleSubmit() {
  try {
    await insertCategory({
      name: text.value
    })
  } catch (error: any) {
    alert(error.data["message"])
    if(error.status == 401) {
      router.replace({name: "login"});
    }
  } finally {
    router.replace({name: "home"})
  }
}
</script>

<style scoped>

</style>