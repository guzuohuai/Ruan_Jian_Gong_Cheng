import { defineStore } from 'pinia'
import { authApi } from '../services/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    loading: false,
  }),

  getters: {
    isAuthenticated: (state) => !!state.user,
  },

  actions: {
    async init() {
      this.loading = true
      try {
        this.user = await authApi.getCurrentUser()
      } catch (error) {
        console.error('初始化用户失败:', error)
        this.user = null
      } finally {
        this.loading = false
      }
    },

    async signUp(email, password, userData = {}) {
      this.loading = true
      try {
        const data = await authApi.signUp(email, password, userData)
        this.user = data.user
        return data
      } catch (error) {
        throw error
      } finally {
        this.loading = false
      }
    },

    async signIn(email, password) {
      this.loading = true
      try {
        const data = await authApi.signIn(email, password)
        this.user = data.user
        return data
      } catch (error) {
        throw error
      } finally {
        this.loading = false
      }
    },

    async signOut() {
      this.loading = true
      try {
        await authApi.signOut()
        this.user = null
      } catch (error) {
        throw error
      } finally {
        this.loading = false
      }
    },

    setUser(user) {
      this.user = user
    },
  },
})

