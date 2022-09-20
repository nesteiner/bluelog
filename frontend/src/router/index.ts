import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/home',
    name: 'home',
    component: HomeView
  },
  {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
  },
  {
    path: "/",
    name: "login",
    component: () => import("@/views/LoginView.vue")
  },

  {
    path: "/post/:id/",
    name: "post",
    component: () => import("@/views/PostView.vue")
  },

  {
    path: "/post-edit/:id/",
    name: "post-edit",
    component: () => import("@/views/PostEditView.vue")
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
