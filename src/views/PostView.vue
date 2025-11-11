<template>
  <div class="post-view">
    <div v-if="loading" class="loading">加载中...</div>
    <div v-else-if="error" class="error">
      <p>{{ error }}</p>
      <router-link to="/" class="back-link">返回首页</router-link>
    </div>
    <article v-else-if="post" class="post-article">
      <!-- 返回按钮 -->
      <router-link to="/" class="back-button">← 返回首页</router-link>

      <!-- 文章头部 -->
      <header class="post-header">
        <div class="post-meta">
          <span
            v-if="post.category"
            class="category-badge"
            :style="{ backgroundColor: post.category.color || '#667eea' }"
          >
            {{ post.category.name }}
          </span>
          <span class="post-date">{{ formatDate(post.created_at) }}</span>
        </div>
        <h1 class="post-title">{{ post.title }}</h1>
        <p v-if="post.excerpt" class="post-excerpt">{{ post.excerpt }}</p>
      </header>

      <!-- 封面图片 -->
      <div v-if="post.cover_image" class="post-cover">
        <img :src="post.cover_image" :alt="post.title" />
      </div>

      <!-- 文章内容 -->
      <div class="post-content" v-html="renderedContent"></div>

      <!-- 文章底部信息 -->
      <footer class="post-footer">
        <div class="post-stats">
          <span class="views-count">👁 {{ post.views_count || 0 }} 次浏览</span>
          <span class="updated-date">更新于 {{ formatDate(post.updated_at) }}</span>
        </div>
      </footer>

      <!-- 评论区域 -->
      <div class="comments-section">
        <h2>评论 ({{ comments.length }})</h2>
        
        <!-- 评论表单 -->
        <div class="comment-form">
          <h3>发表评论</h3>
          <form @submit.prevent="submitComment">
            <div class="form-group">
              <input
                v-model="commentForm.author_name"
                type="text"
                placeholder="您的姓名 *"
                required
              />
            </div>
            <div class="form-group">
              <input
                v-model="commentForm.author_email"
                type="email"
                placeholder="您的邮箱（可选）"
              />
            </div>
            <div class="form-group">
              <textarea
                v-model="commentForm.content"
                placeholder="写下您的评论... *"
                rows="4"
                required
              ></textarea>
            </div>
            <button type="submit" :disabled="submitting" class="submit-btn">
              {{ submitting ? '提交中...' : '发表评论' }}
            </button>
          </form>
        </div>

        <!-- 评论列表 -->
        <div v-if="comments.length === 0" class="no-comments">
          暂无评论，快来发表第一条评论吧！
        </div>
        <div v-else class="comments-list">
          <CommentItem
            v-for="comment in topLevelComments"
            :key="comment.id"
            :comment="comment"
            :post-id="post.id"
            :all-comments="comments"
            @reply-submitted="loadComments"
          />
        </div>
      </div>
    </article>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { postApi, commentApi } from '@/services/api'
import { markdownToHtml } from '@/utils/markdown'
import CommentItem from '@/components/CommentItem.vue'
import '@/styles/markdown.css'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref(null)
const post = ref(null)
const comments = ref([])
const submitting = ref(false)

// 只显示顶级评论（没有 parent_id 的评论）
const topLevelComments = computed(() => {
  return comments.value.filter(comment => !comment.parent_id)
})

// 渲染 Markdown 内容
const renderedContent = computed(() => {
  if (!post.value || !post.value.content) return ''
  return markdownToHtml(post.value.content)
})

const commentForm = ref({
  author_name: '',
  author_email: '',
  content: '',
})

async function loadPost() {
  loading.value = true
  error.value = null

  try {
    const slug = route.params.slug
    const postData = await postApi.getBySlug(slug)
    post.value = postData

    // 增加浏览次数
    try {
      const updatedViews = await postApi.incrementViews(postData.id)
      if (updatedViews && updatedViews.views_count !== undefined) {
        post.value.views_count = updatedViews.views_count
      }
    } catch (viewError) {
      // 浏览次数更新失败不影响文章显示
      console.warn('更新浏览次数失败:', viewError)
    }

    // 加载评论
    await loadComments()
  } catch (err) {
    error.value = err.message || '文章不存在'
    console.error('加载文章失败:', err)
  } finally {
    loading.value = false
  }
}

async function loadComments() {
  if (!post.value) return

  try {
    const commentsData = await commentApi.getByPost(post.value.id)
    comments.value = commentsData
  } catch (err) {
    console.error('加载评论失败:', err)
  }
}

async function submitComment() {
  if (!post.value) return

  submitting.value = true

  try {
    await commentApi.create({
      post_id: post.value.id,
      author_name: commentForm.value.author_name,
      author_email: commentForm.value.author_email || null,
      content: commentForm.value.content,
    })

    // 清空表单
    commentForm.value = {
      author_name: '',
      author_email: '',
      content: '',
    }

    // 重新加载评论
    await loadComments()

    alert('评论提交成功！等待审核后显示。')
  } catch (err) {
    alert('评论提交失败: ' + (err.message || '未知错误'))
    console.error('提交评论失败:', err)
  } finally {
    submitting.value = false
  }
}

function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

// formatContent 函数已移除，改用 computed 属性 renderedContent

// 监听路由变化
watch(() => route.params.slug, () => {
  loadPost()
})

onMounted(() => {
  loadPost()
})
</script>

<style scoped>
.post-view {
  max-width: 900px;
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

.post-article {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.post-header {
  margin-bottom: 2rem;
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
  font-size: 2.5rem;
  margin: 0 0 1rem 0;
  color: #333;
  line-height: 1.2;
}

.post-excerpt {
  font-size: 1.1rem;
  color: #666;
  line-height: 1.6;
}

.post-cover {
  width: 100%;
  max-height: 400px;
  overflow: hidden;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.post-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.post-content {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #333;
  margin-bottom: 2rem;
}

.post-content :deep(h1),
.post-content :deep(h2),
.post-content :deep(h3) {
  margin-top: 2rem;
  margin-bottom: 1rem;
  color: #333;
}

.post-content :deep(h1) {
  font-size: 2rem;
}

.post-content :deep(h2) {
  font-size: 1.5rem;
}

.post-content :deep(h3) {
  font-size: 1.25rem;
}

.post-content :deep(code) {
  background: #f5f5f5;
  padding: 0.2rem 0.4rem;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  font-size: 0.9em;
}

.post-content :deep(strong) {
  font-weight: 600;
}

.post-content :deep(em) {
  font-style: italic;
}

.post-footer {
  padding-top: 2rem;
  border-top: 1px solid #eee;
  margin-top: 2rem;
}

.post-stats {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #999;
  font-size: 0.9rem;
}

.comments-section {
  margin-top: 3rem;
  padding-top: 3rem;
  border-top: 2px solid #eee;
}

.comments-section h2 {
  font-size: 1.5rem;
  margin-bottom: 2rem;
  color: #333;
}

.comment-form {
  background: #f9f9f9;
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.comment-form h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  font-size: 1.2rem;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
  font-family: inherit;
}

.form-group textarea {
  resize: vertical;
}

.submit-btn {
  background: #667eea;
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}

.submit-btn:hover:not(:disabled) {
  background: #5568d3;
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.comments-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.comment-item {
  background: #f9f9f9;
  padding: 1.5rem;
  border-radius: 8px;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.comment-header strong {
  color: #333;
}

.comment-date {
  color: #999;
  font-size: 0.9rem;
}

.comment-content {
  color: #666;
  line-height: 1.6;
  white-space: pre-wrap;
}

.no-comments {
  text-align: center;
  padding: 2rem;
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
</style>

