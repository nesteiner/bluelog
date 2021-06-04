import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import Home from '../views/Home.vue'
import Post from '@/views/Post.vue'
import User from '@/views/User.vue'
import Admin from '@/views/Admin.vue'
import Login from '@/views/Login.vue'
import Logout from '@/views/Logout.vue'
import Navi from '@/views/Navi.vue'

const routes: Array<RouteRecordRaw> = [
	{
		path: '/',
		name: 'Home',
		component: Home
	},

	{
		path: '/post',
		name: 'post',
		component: Post
	},

	{
		path: '/user',
		name: 'user',
		component: User,
	},

	{
		path: '/admin',
		name: 'admin',
		component: Admin,
	},

	{
		path: '/login',
		name: 'login',
		component: Login,
	},
	{
		path: '/logout',
		name: 'Logout',
		component: Logout
	},

    {
	    path: '/navi',
	    name: 'navi',
	    component: Navi
	},
	{
		path: '/about',
		name: 'About',
		// route level code-splitting
		// this generates a separate chunk (about.[hash].js) for this route
		// which is lazy-loaded when the route is visited.
		component: () => import(/* webpackChunkName: "about" */ '../views/About.vue')
	}
]

const router = createRouter({
	history: createWebHistory(process.env.BASE_URL),
	routes
})

export default router
