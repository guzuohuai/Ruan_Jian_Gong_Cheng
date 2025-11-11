<template>
  <nav class="navbar">
    <div class="nav-container">
      <router-link to="/" class="nav-logo">
        <span class="logo-text">我的博客</span>
      </router-link>

      <ul class="nav-menu">
        <li>
          <router-link to="/" class="nav-link">首页</router-link>
        </li>
        <li>
          <router-link to="/about" class="nav-link">关于</router-link>
        </li>
      </ul>

      <div class="nav-auth" v-if="authStore.isAuthenticated">
        <span class="user-name">{{ authStore.user?.email }}</span>
        <button @click="handleSignOut" class="sign-out-btn">登出</button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

async function handleSignOut() {
  try {
    await authStore.signOut()
    router.push('/')
  } catch (error) {
    console.error('登出失败:', error)
  }
}
</script>

<style scoped>
.navbar {
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-logo {
  text-decoration: none;
  font-size: 1.5rem;
  font-weight: bold;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-menu {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  gap: 2rem;
}

.nav-link {
  text-decoration: none;
  color: #333;
  font-weight: 500;
  transition: color 0.2s;
  position: relative;
}

.nav-link:hover {
  color: #667eea;
}

.nav-link.router-link-active {
  color: #667eea;
}

.nav-link.router-link-active::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  right: 0;
  height: 2px;
  background: #667eea;
}

.nav-auth {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.user-name {
  color: #666;
  font-size: 0.9rem;
}

.sign-out-btn {
  background: #f5f5f5;
  border: 1px solid #ddd;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background 0.2s;
}

.sign-out-btn:hover {
  background: #eee;
}

@media (max-width: 768px) {
  .nav-container {
    padding: 1rem;
    flex-wrap: wrap;
  }

  .nav-menu {
    gap: 1rem;
  }

  .nav-auth {
    margin-top: 0.5rem;
    width: 100%;
    justify-content: flex-end;
  }
}
</style>

