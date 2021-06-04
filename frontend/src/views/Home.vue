<template>
  <div class="home">
    <div class="stub">

    </div>
  </div>
</template>

<script lang="ts">
 import { Options, Vue } from 'vue-class-component';
 import HelloWorld from '@/components/HelloWorld.vue'; // @ is an alias to /src
 import axios from 'axios'

 @Options({
   components: {
     HelloWorld,
   },
 })
 export default class Home extends Vue {
   mounted(): void {
     // let url = 'http://localhost:5000/session/curuser'
     let url = 'http://localhost:8080/bluelog/session/curuser'
     // TODO 查看后端 Session 有没有存储 User 状态
     // 如果没有，重定向到 '/Login', 访问 '/session/setuser'
     // 如果有，重定向到 '/User'
     // 考虑 isadmin 的情况
     axios.get(url, {withCredentials: true})
     .then(response => {
       // STUB Problem here data.data
       let isadmin = response.data.isadmin
       let curuser = response.data.curuser

       // STUB log curuser
       console.log('curuser: ', curuser)

       if(curuser == null) {
	 this.$router.push({
	   path: '/login'
	 })

	 return;
       } 

       if(isadmin == true) {
	 this.$router.push({
	   // STUB
	   name: 'admin'
	 })
       } else {
	 this.$router.push({
	   name: 'user',
	   params: {
	     username: curuser
	   }
	 })
       }
     })
     .catch(error => {
       alert(error)
     })
   }
 }
</script>
