<template>
  <nav>
    <div>
      <router-link to="/home">Home</router-link>
    </div>

    <button @click="handleLogout">Logout</button>
  </nav>
</template>

<script lang="ts" setup>
import {logout} from "@/api";
import {useRouter} from "vue-router";

const router = useRouter();
function handleLogout() {
  logout();
  router.replace({name: "login"})
}
</script>
<style lang="scss" scoped>
nav {
  display: flex;
  justify-content: space-between;

}
</style>