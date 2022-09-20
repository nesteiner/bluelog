<template>
  <div class="home">
    <Navigation/>

    <Tabbar active-name="post-manage">
      <TabbarItem name="post-manage">
        <PostManageView/>
      </TabbarItem>

      <TabbarItem name="post-add">
        <PostAddView/>
      </TabbarItem>

      <TabbarItem name="category-manage">
        <CategoryManageView/>
      </TabbarItem>

      <TabbarItem name="category-add">
        <CategoryAddView/>
      </TabbarItem>
    </Tabbar>
  </div>
</template>

<script lang="ts" setup>
import Navigation from "@/components/Navigation.vue";
import Tabbar from "@/components/tabbar/Tabbar.vue";
import TabbarItem from "@/components/tabbar/TabbarItem.vue";
import PostManageView from "@/views/PostManageView.vue";
import PostAddView from "@/views/PostAddView.vue";
import CategoryManageView from "@/views/CategoryManageView.vue";
import CategoryAddView from "@/views/CategoryAddView.vue";

</script>

<style lang="scss" scoped>

</style>