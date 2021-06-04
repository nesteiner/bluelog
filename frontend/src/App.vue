<template>
  <navi :username="username" />
  <router-view @login="login" @logout="logout" />
</template>

<script lang="ts">
 import Navi from '@/views/Navi.vue'
 import {Vue, Options} from 'vue-property-decorator'

 @Options({
     components: {
       'navi': Navi
     }
   }
)
 export default class App extends Vue {
   username = 'no login user'
   public login(event: any) {
     this.username = event
   }

   public logout(event ?: any) {
     this.username = 'no login user'
   }
 }
</script>
<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
</style>
