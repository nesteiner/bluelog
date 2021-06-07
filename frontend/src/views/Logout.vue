<template>
  <div class="logout">
    
  </div>
</template>

<script lang="ts">
 import {Vue} from 'vue-property-decorator'
 import axios from 'axios'

 export default class LogoutView extends Vue {
   mounted(): void {
     this.$emit('logout')
     // just use axios to the url, and redirect to '/'
     // let url = 'http://localhost:5000/logout'
     let url = 'http://localhost:8080/bluelog/logout'

     axios.get(url, {
       withCredentials: true
     }).then(response => {
       this.$router.push({
	 path: '/',
       })

     }).catch(error => {
       alert(error)
     })
   }
 }
</script>