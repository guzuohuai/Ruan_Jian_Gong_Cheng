<template>
  <div class="home-view">
    <div class="hero-section">
      <h1>欢迎来到我的博客</h1>
      <p>分享技术、生活与学习心得</p>
    </div>

    <!-- 分类导航 -->
    <div class="categories-section" v-if="categories.length > 0">
      <h2>文章分类</h2>
      <div class="categories-grid">
        <router-link
          v-for="category in categories"
          :key="category.id"
          :to="`/category/${category.slug}`"
          class="category-card"
          :style="{ borderLeftColor: category.color || '#667eea' }"
        >
          <h3>{{ category.name }}</h3>
          <p v-if="category.description">{{ category.description }}</p>
        </router-link>
      </div>
    </div>

    <!-- 搜索栏 -->
    <div class="search-section">
      <SearchBar v-model="searchQuery" :loading="loading" @search="handleSearch" />
    </div>

    <!-- 文章列表 -->
    <div class="posts-section">
      <h2>
        <span v-if="searchQuery">搜索结果</span>
        <span v-else>最新文章</span>
        <span v-if="totalCount > 0" class="count-badge">({{ totalCount }})</span>
      </h2>
      <div v-if="loading" class="loading">加载中...</div>
      <div v-else-if="error" class="error">{{ error }}</div>
      <div v-else-if="posts.length === 0" class="empty">
        <span v-if="searchQuery">没有找到相关文章</span>
        <span v-else>暂无文章</span>
      </div>
      <div v-else class="posts-grid">
        <article
          v-for="post in posts"
          :key="post.id"
          class="post-card"
          @click="goToPost(post.slug)"
        >
          <div v-if="post.cover_image" class="post-cover">
            <img :src="post.cover_image" :alt="post.title" />
          </div>
          <div class="post-content">
            <div class="post-meta">
              <span
                v-if="post.category"
                class="category-badge"
                :style="{ backgroundColor: post.category.color || '#667eea' }"
              >
                {{ post.category.name }}
              </span>
              <span class="post-date">
                {{ formatDate(post.created_at) }}
              </span>
            </div>
            <h3 class="post-title">{{ post.title }}</h3>
            <p v-if="post.excerpt" class="post-excerpt">{{ post.excerpt }}</p>
            <div class="post-footer">
              <span class="views-count">👁 {{ post.views_count || 0 }} 次浏览</span>
            </div>
          </div>
        </article>
      </div>

      <!-- 分页 -->
      <Pagination
        v-if="totalPages > 1"
        :current-page="currentPage"
        :total-pages="totalPages"
        @page-change="handlePageChange"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { categoryApi, postApi } from '@/services/api'
import SearchBar from '@/components/SearchBar.vue'
import Pagination from '@/components/Pagination.vue'

const router = useRouter()
const loading = ref(false)
const error = ref(null)
const categories = ref([])
const posts = ref([])
const searchQuery = ref('')
const currentPage = ref(1)
const totalCount = ref(0)
const pageSize = ref(6) // 每页显示6篇文章

const totalPages = computed(() => {
  return Math.ceil(totalCount.value / pageSize.value)
})

async function loadData() {
  loading.value = true
  error.value = null

  try {
    // 并行加载分类、文章和总数
    const [categoriesData, postsData, count] = await Promise.all([
      categoryApi.getAll(),
      postApi.getAll(true, {
        search: searchQuery.value,
        page: currentPage.value,
        pageSize: pageSize.value,
      }),
      postApi.getCount(true, searchQuery.value),
    ])

    categories.value = categoriesData
    posts.value = postsData
    totalCount.value = count
  } catch (err) {
    error.value = err.message || '加载数据失败'
    console.error('加载数据失败:', err)
  } finally {
    loading.value = false
  }
}

function handleSearch(query) {
  searchQuery.value = query
  currentPage.value = 1 // 搜索时重置到第一页
  loadData()
}

function handlePageChange(page) {
  currentPage.value = page
  // 滚动到顶部
  window.scrollTo({ top: 0, behavior: 'smooth' })
  loadData()
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

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.home-view {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.hero-section {
  text-align: center;
  padding: 3rem 0;
  margin-bottom: 3rem;
}

.hero-section h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-section p {
  font-size: 1.2rem;
  color: #666;
}

.categories-section,
.posts-section {
  margin-bottom: 3rem;
}

.categories-section h2,
.posts-section h2 {
  font-size: 1.8rem;
  margin-bottom: 1.5rem;
  color: #333;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 3rem;
}

.category-card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  border-left: 4px solid;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  text-decoration: none;
  color: inherit;
  transition: transform 0.2s, box-shadow 0.2s;
}

.category-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.category-card h3 {
  margin: 0 0 0.5rem 0;
  color: #333;
}

.category-card p {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
}

.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 2rem;
}

.post-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.post-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.post-cover {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f0f0f0;
}

.post-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.post-content {
  padding: 1.5rem;
}

.post-meta {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
  flex-wrap: wrap;
}

.category-badge {
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  color: white;
  font-size: 0.85rem;
  font-weight: 500;
}

.post-date {
  color: #999;
  font-size: 0.9rem;
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
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.post-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 1rem;
  border-top: 1px solid #eee;
}

.views-count {
  color: #999;
  font-size: 0.9rem;
}

.loading,
.error,
.empty {
  text-align: center;
  padding: 3rem;
  color: #666;
}

.error {
  color: #d32f2f;
}
</style>

