<template>
  <div class="category-manage">
    <Navigation/>

    <ul class="categories">
      <template v-for="(category, index) in categories" :key="index">
        <li>
          <div class="name">{{category.name}}</div>
          <div class="operate">
            <button @click="handleEdit(category)">Edit</button>
            <button @click="handleDelete(category.id, index)">Delete</button>
          </div>
        </li>
      </template>
    </ul>

    <Dialog v-model="showDialogEdit" :title="dialogTitle">
      <input type="text" v-model="categoryName"/>

      <template #footer>
        <button @click="handleCancel">Cancel</button>
        <button @click="handleSubmitEdit">Submit</button>
      </template>
    </Dialog>

  </div>
</template>

<script lang="ts" setup>
import Navigation from "@/components/Navigation.vue";
import {onMounted, ref} from "vue";
import {deleteCategory, findCategories, insertCategory, updateCategory} from "@/api";
import {useRouter} from "vue-router";
import Dialog from "@/components/Dialog.vue";

const router = useRouter();
const categories = ref<Category[]>();
const showDialogEdit = ref(false);
const dialogTitle = ref("");
const categoryName = ref("");
const currentCategory = ref<Category>({
  id: 0,
  name: ""
})

function handleEdit(category: Category) {
  showDialogEdit.value = true;
  dialogTitle.value = "edit category";
  currentCategory.value = category;
  categoryName.value = category.name
}

async function handleDelete(id: number, index: number) {
  try {
    await deleteCategory(id);
    categories.value?.splice(index, 1);
  } catch (error: any) {
    alert(error.data["message"]);
    if(error.status == 401) {
      router.replace({name: "login"});
    }
  }
}

function handleCancel() {
  showDialogEdit.value = false;
  categoryName.value = ""
}

async function handleSubmitEdit() {
  if(categoryName.value == "") {
    alert("category cannot be empty");
    return;
  }

  try {
    let category = await updateCategory({
      id: currentCategory.value.id,
      name: categoryName.value
    });

    let index = categories.value?.findIndex(x => x.id == category.id);
    if(index != -1) {
      categories.value![index!] = category
    }
  } catch (error: any) {
    alert(error.data["message"]);
    if(error.status == 401) {
      router.replace({name: "login"});
    }
  } finally {
    showDialogEdit.value = false;
  }
}
onMounted(async () => {
  try {
    categories.value = await findCategories();
  } catch (error: any) {
    alert(error.data["message"])
    if(error.status == 401) {
      router.replace({name: "login"})
    }
  }
})
</script>

<style lang="scss" scoped>
div.category-manage {
  ul.categories {
    list-style: none;

    li {
      display: flex;
      justify-content: space-between;
    }
  }
}
</style>