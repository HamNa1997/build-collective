import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import SignIn from '@/views/SignIn.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn,
  },
  {
    path: '/account',
    name: 'Account',
    component: () => import('@/views/Account.vue'),
  },
  {
    path: '/createProject',
    name: 'CreateProject',
    component: () =>import('@/views/CreateProject.vue')

  },
  {
    path: '/projects',
    name: 'Projects',
    component: () =>import('@/views/Projects.vue')

  },
  {
    path: '/myprojects',
    name: 'Myprojects',
    component: () =>import('@/views/Myprojects.vue')

  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {
  if (to.name !== 'SignIn' && !store.state.account.address) {
    next({ name: 'SignIn' })
  } else {
    next()
  }
})

export default router
