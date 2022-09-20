<template>
  <div class="post-manage">
    <div class="content">
      <div class="shortcuts">
        <template v-for="(shortcut, index) in postShortcuts" :key="index">
          <PostShortcut :postid="shortcut.postid"
                        :title="shortcut.title"
                        :shortcut="shortcut.shortcut"
                        :author="shortcut.author"
                        :category="shortcut.category"
                        @delete-post="handleDeletePost(shortcut.postid)"/>

        </template>
      </div>

      <Pagination v-model:current-page="currentPage" :total-pages="totalPage" :page-size="10"/>
    </div>

    <div class="categories">
      <div class="header">Categories</div>
      <div class="name all" @click="findData">all</div>
      <template v-for="(category, index) in categories" :key="index">
        <div class="name" @click="findDataByCategory(category.name)">{{category.name}}</div>
      </template>
    </div>


  </div>
</template>

<script lang="ts" setup>
import {onMounted, ref, watch} from "vue";
import {deletePost, findCategories, findPostShortcuts, findPostShortcutsByCategory} from "@/api";
import {useRouter} from "vue-router";
import PostShortcut from "@/components/PostShortcut.vue";
import Pagination from "@/components/Pagination.vue";

const postShortcuts = ref<PostShortcut[]>([])
const categories = ref<Category[]>([])
const currentPage = ref(1);
const totalPage = ref(0);

const router = useRouter();

async function findData(pageindex: number) {
  try {
    let pagePostShortcut: PagePostShortcut = await findPostShortcuts(pageindex);
    totalPage.value = pagePostShortcut.totalPage;
    postShortcuts.value = pagePostShortcut.shortcuts;
    categories.value = await findCategories()
  } catch (error: any) {
    alert(error.data["message"])
    if(error.status == 401) {
      router.replace({name: "login"})
    }

  }
}

async function findDataByCategory(categoryName: string) {
  try {
    currentPage.value = 1;
    let pagePostShortcut: PagePostShortcut = await findPostShortcutsByCategory(currentPage.value - 1, categoryName);
    totalPage.value = pagePostShortcut.totalPage;
    postShortcuts.value = pagePostShortcut.shortcuts;
  } catch (error: any) {
    alert(error.data["message"]);
    if(error.status == 401) {
      router.replace({name: "login"})
    }
  }
}

async function handleDeletePost(id: number) {
  try {
    await deletePost(id);
    let index = postShortcuts.value.findIndex(x => x.postid == id);
    if(index != -1) {
      postShortcuts.value.splice(index, 1);
    }
  } catch (error: any) {
    alert(error.data["message"]);

    if(error.status == 401) {
      router.replace({name: "login"})
    }
  }
}

watch(currentPage, async (newvalue, _) => {
  await findData(newvalue - 1);
})

onMounted(async () => {
  await findData(currentPage.value - 1);
})

</script>

<style lang="scss" scoped>
div.post-manage {
  display: flex;
  div.content {
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: auto;

    display: flex;
    flex-direction: column;
    div.shortcuts {
      flex-grow: 1;
      flex-shrink: 1;
      flex-basis: auto;
    }
  }

  div.categories {
    div.all {
      background: rgba(0, 0, 0, 0.2);
    }
    div.header {
      border: 1px solid rgba(0, 0, 0, 0.125);
      padding: .75rem 1.25rem;
      background: rgba(0, 0, 0, 0.3);
    }

    div.name {
      padding: 20px 12px;
      border: 1px solid rgba(0, 0, 0, 0.125);
      cursor: pointer;
    }
  }
}
</style>