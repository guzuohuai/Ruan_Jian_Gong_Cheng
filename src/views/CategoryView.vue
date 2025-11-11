<template>
  <div class="category-view">
    <div v-if="loading" class="loading">加载中...</div>
    <div v-else-if="error" class="error">
      <p>{{ error }}</p>
      <router-link to="/" class="back-link">返回首页</router-link>
    </div>
    <div v-else-if="category">
      <!-- 返回按钮 -->
      <router-link to="/" class="back-button">← 返回首页</router-link>

      <!-- 分类信息 -->
      <header class="category-header">
        <div
          class="category-badge-large"
          :style="{ backgroundColor: category.color || '#667eea' }"
        >
          {{ category.name }}
        </div>
        <h1 class="category-title">{{ category.name }}</h1>
        <p v-if="category.description" class="category-description">
          {{ category.description }}
        </p>
      </header>

      <!-- 文章列表 -->
      <div class="posts-section">
        <h2>文章列表 ({{ posts.length }})</h2>
        <div v-if="posts.length === 0" class="empty">
          该分类下暂无文章
        </div>
        <div v-else class="posts-list">
          <article
            v-for="post in posts"
            :key="post.id"
            class="post-item"
            @click="goToPost(post.slug)"
          >
            <div class="post-info">
              <h3 class="post-title">{{ post.title }}</h3>
              <p v-if="post.excerpt" class="post-excerpt">{{ post.excerpt }}</p>
              <div class="post-meta">
                <span class="post-date">{{ formatDate(post.created_at) }}</span>
                <span class="views-count">👁 {{ post.views_count || 0 }} 次浏览</span>
              </div>
            </div>
            <div v-if="post.cover_image" class="post-thumbnail">
              <img :src="post.cover_image" :alt="post.title" />
            </div>
          </article>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { categoryApi, postApi } from '@/services/api'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref(null)
const category = ref(null)
const posts = ref([])

async function loadCategory() {
  loading.value = true
  error.value = null

  try {
    const slug = route.params.slug
    const categoryData = await categoryApi.getBySlug(slug)
    category.value = categoryData

    // 加载该分类下的文章
    const postsData = await postApi.getByCategory(categoryData.id, true)
    posts.value = postsData
  } catch (err) {
    error.value = err.message || '分类不存在'
    console.error('加载分类失败:', err)
  } finally {
    loading.value = false
  }
}

function goToPost(slug) {
  router.push(`/post/${slug}`)
}

function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

// 监听路由变化
watch(() => route.params.slug, () => {
  loadCategory()
})

onMounted(() => {
  loadCategory()
})
</script>

<style scoped>
.category-view {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.back-button {
  display: inline-block;
  margin-bottom: 2rem;
  color: #667eea;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s;
}

.back-button:hover {
  color: #764ba2;
}

.category-header {
  text-align: center;
  padding: 2rem 0;
  margin-bottom: 3rem;
}

.category-badge-large {
  display: inline-block;
  padding: 0.5rem 1.5rem;
  border-radius: 20px;
  color: white;
  font-size: 1rem;
  font-weight: 500;
  margin-bottom: 1rem;
}

.category-title {
  font-size: 2.5rem;
  margin: 0 0 1rem 0;
  color: #333;
}

.category-description {
  font-size: 1.1rem;
  color: #666;
  max-width: 600px;
  margin: 0 auto;
}

.posts-section h2 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: #333;
}

.posts-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.post-item {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

.post-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.post-info {
  flex: 1;
}

.post-title {
  font-size: 1.3rem;
  margin: 0 0 0.75rem 0;
  color: #333;
  line-height: 1.4;
}

.post-excerpt {
  color: #666;
  line-height: 1.6;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.post-meta {
  display: flex;
  gap: 1.5rem;
  align-items: center;
  color: #999;
  font-size: 0.9rem;
}

.post-thumbnail {
  width: 150px;
  height: 100px;
  flex-shrink: 0;
  border-radius: 8px;
  overflow: hidden;
  background: #f0f0f0;
}

.post-thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.empty {
  text-align: center;
  padding: 3rem;
  color: #999;
}

.loading,
.error {
  text-align: center;
  padding: 3rem;
}

.error {
  color: #d32f2f;
}

.back-link {
  display: inline-block;
  margin-top: 1rem;
  color: #667eea;
  text-decoration: none;
}

@media (max-width: 768px) {
  .post-item {
    flex-direction: column;
  }

  .post-thumbnail {
    width: 100%;
    height: 200px;
  }
}
</style>

