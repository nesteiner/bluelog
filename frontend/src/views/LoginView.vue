<template>
  <div class="login-view">
    <input type="text" v-model="username" placeholder="input username"/>
    <br/>
    <input type="password" v-model="password" placeholder="input password"/>
    <br/>
    <button @click="handleLogin">Login</button>
  </div>
</template>

<script lang="ts" setup>
import {ref} from "vue";
import {login} from "@/api";
import {useRouter} from "vue-router";

const username = ref("")
const password = ref("")
const router = useRouter();

async function handleLogin() {
  try {
    await login(username.value, password.value);
    await router.replace({name: "home"});
  } catch (error) {
    alert(`fuck: ${error}`);
  } finally {
    password.value = "";
  }
}
</script>

<style lang="scss" scoped>

</style>