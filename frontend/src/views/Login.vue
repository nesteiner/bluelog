<template>
  <div class="login-view">
    <label class="username"> username
      <input type="text" placeholder="input username" v-model="username">
    </label>

    <label class="password"> password
      <input type="password" v-model="password">
    </label>

    <div class="radio-group">
      <label>
	<input type="radio" value="user" v-model="usertype">
	user
      </label>

      <label>
	<input type="radio" value="admin" v-model="usertype">
	admin
      </label>
    </div>

    <button @click="submit">登录</button>
  </div>
</template>

<script lang="ts">
 import {Vue} from 'vue-property-decorator'
 import axios from 'axios'
 import {Md5} from 'ts-md5'

 export default class LoginView extends Vue {
   usertype = 'user'
   username = ''
   password = ''

   public submit(): void {
     // let url = 'http://localhost:5000/login'
     let url = 'http://localhost:8080/bluelog/login'
     axios.post(url, {
       username: this.username,
       passhash: Md5.hashStr(this.password),
       usertype: this.usertype
     }, {
       withCredentials: true
     }).then(response => {
       // STUB
       console.log('in Login.vue \n', response.data)

       this.$emit('login', this.username)
       // UserView 重定向 与 AdminView 重定向
       if(this.usertype == 'admin') {
	 this.$router.push({
	   name: 'admin'
	 })
       } else {
	 this.$router.push({
	   name: 'user',
	   params: {
	     username: this.username
	   }
	 })
       }
     }).catch(errorResponse => {
       alert(errorResponse.response.data.error)
       console.log(errorResponse.response.data)
       this.password = ''
     })
   }
 }
</script>

<style scoped>
 label.username, label.password {
   display: block;
 }
</style>