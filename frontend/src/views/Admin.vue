<template>
  <div class="admin-view">
    <div class="user-list">
      <template v-for="user in users" :key="user.userid">
	<router-link :to="{name: 'user', params: {userid: user.userid, username: user.name, isadmin: user.isadmin}}">
	  <div class="wrap-user">
	    {{ user.name }}
	    {{ user.userid }}
	  </div>
	</router-link>
      </template>
    </div>
  </div>
</template>

<script lang="ts">
 import {Vue} from 'vue-property-decorator'
 import axios from 'axios'
 interface userItem {
   userid: number,
   username: string,
   isadmin: boolean,
 }

 export default class AdminView extends Vue {
   users: userItem[] = []

   created(): void {
     // TODO init the users
     // let url = 'http://localhost:5000/admin'
     let url = 'http://localhost:8080/bluelog/admin'
     axios.post(url, {
     }, {
       withCredentials: true
     }).then(response => {
       this.users = response.data.users
     }).catch(error => {
       alert(error)
     })
   }
 }
</script>