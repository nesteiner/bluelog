<template>
  <div class="post-shortcut">
    <div class="header">
      <h3 @click="toPostView">{{title}}</h3>
      <Dropdown>
        <DropdownItem @click="handleEdit">修改</DropdownItem>
        <DropdownItem @click="handleDelete">删除</DropdownItem>
      </Dropdown>
    </div>
    <div class="shortcut" v-html="shortcut"/>
    <div class="detail">
      <small>{{category.name}}</small>
      <div>
        <small>{{author.name}}</small>
        <br/>
        <small>{{author.email}}</small>
      </div>
    </div>

    <hr/>
  </div>
</template>

<script lang="ts" setup>
import {useRouter} from "vue-router";
import {Dropdown, DropdownItem} from "@/components/dropdown/";

const props = defineProps<{
  postid: number,
  title: string,
  shortcut: string,

  category: {
    id: number,
    name: string,
  },

  author: {
    id: number,
    name: string,
    email: string,
  }
}>()

const router = useRouter();
const emits = defineEmits(["delete-post"])

function toPostView() {
  router.replace({name: "post", params: {id: props.postid}})
}

function handleEdit() {
  router.replace({name: "post-edit", params: {id: props.postid}})
}

function handleDelete() {
  emits("delete-post")
}
</script>

<style lang="scss" scoped>
div.post-shortcut {
  display: flex;
  flex-direction: column;
  align-items: start;
  border: 1px solid rgba(0, 0, 0, 0.125);
  padding: 10px;

  div.header {
    display: flex;
    width: 100%;
    justify-content: space-between;
    align-items: center;
  }
  div.shortcut {
    width: 700px;
    height: 100px;
    overflow: hidden;
    border: 1px solid rgba(0, 0, 0, 0.3);
  }
}
</style>