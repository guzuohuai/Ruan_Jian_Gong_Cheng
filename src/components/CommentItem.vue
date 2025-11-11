<template>
  <div class="comment-item" :class="{ 'is-reply': comment.parent_id }">
    <div class="comment-header">
      <div class="comment-author">
        <strong>{{ comment.author_name }}</strong>
        <span v-if="comment.parent_id" class="reply-badge">回复</span>
      </div>
      <span class="comment-date">{{ formatDate(comment.created_at) }}</span>
    </div>
    
    <div class="comment-content">{{ comment.content }}</div>
    
    <div class="comment-actions">
      <button @click="toggleLike" class="like-btn" :class="{ liked: isLiked }">
        <span>👍</span>
        <span>{{ likeCount }}</span>
      </button>
      <button @click="toggleReply" class="reply-btn">
        {{ showReplyForm ? '取消回复' : '回复' }}
      </button>
    </div>

    <!-- 回复表单 -->
    <div v-if="showReplyForm" class="reply-form">
      <form @submit.prevent="submitReply">
        <div class="form-group">
          <input
            v-model="replyForm.author_name"
            type="text"
            placeholder="您的姓名 *"
            required
          />
        </div>
        <div class="form-group">
          <input
            v-model="replyForm.author_email"
            type="email"
            placeholder="您的邮箱（可选）"
          />
        </div>
        <div class="form-group">
          <textarea
            v-model="replyForm.content"
            placeholder="写下您的回复... *"
            rows="3"
            required
          ></textarea>
        </div>
        <div class="form-actions">
          <button type="submit" :disabled="submitting" class="submit-btn">
            {{ submitting ? '提交中...' : '发表回复' }}
          </button>
          <button type="button" @click="cancelReply" class="cancel-btn">取消</button>
        </div>
      </form>
    </div>

    <!-- 子评论（回复） -->
    <div v-if="commentReplies.length > 0" class="replies">
      <CommentItem
        v-for="reply in commentReplies"
        :key="reply.id"
        :comment="reply"
        :post-id="postId"
        :all-comments="allComments"
        @reply-submitted="handleReplySubmitted"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { commentApi } from '@/services/api'
import CommentItem from './CommentItem.vue'

const props = defineProps({
  comment: {
    type: Object,
    required: true,
  },
  postId: {
    type: String,
    required: true,
  },
  allComments: {
    type: Array,
    default: () => [],
  },
})

const emit = defineEmits(['reply-submitted'])

const showReplyForm = ref(false)
const submitting = ref(false)
const replies = ref([])
const likeCount = ref(0)
const isLiked = ref(false)

const replyForm = ref({
  author_name: '',
  author_email: '',
  content: '',
})

// 从 localStorage 加载点赞状态
onMounted(() => {
  loadLikeStatus()
})

function loadLikeStatus() {
  const likedComments = JSON.parse(localStorage.getItem('likedComments') || '[]')
  isLiked.value = likedComments.includes(props.comment.id)
  
  // 从 localStorage 加载点赞数（实际项目中应该从数据库获取）
  const likes = JSON.parse(localStorage.getItem('commentLikes') || '{}')
  likeCount.value = likes[props.comment.id] || 0
}

// 计算当前评论的回复
const commentReplies = computed(() => {
  return props.allComments.filter(
    c => c.parent_id === props.comment.id
  )
})

function toggleLike() {
  const likedComments = JSON.parse(localStorage.getItem('likedComments') || '[]')
  const likes = JSON.parse(localStorage.getItem('commentLikes') || '{}')
  
  if (isLiked.value) {
    // 取消点赞
    const index = likedComments.indexOf(props.comment.id)
    if (index > -1) {
      likedComments.splice(index, 1)
    }
    likes[props.comment.id] = Math.max(0, (likes[props.comment.id] || 0) - 1)
    likeCount.value = Math.max(0, likeCount.value - 1)
  } else {
    // 点赞
    likedComments.push(props.comment.id)
    likes[props.comment.id] = (likes[props.comment.id] || 0) + 1
    likeCount.value += 1
  }
  
  isLiked.value = !isLiked.value
  localStorage.setItem('likedComments', JSON.stringify(likedComments))
  localStorage.setItem('commentLikes', JSON.stringify(likes))
}

function toggleReply() {
  showReplyForm.value = !showReplyForm.value
  if (!showReplyForm.value) {
    cancelReply()
  }
}

function cancelReply() {
  showReplyForm.value = false
  replyForm.value = {
    author_name: '',
    author_email: '',
    content: '',
  }
}

async function submitReply() {
  submitting.value = true

  try {
    await commentApi.create({
      post_id: props.postId,
      parent_id: props.comment.id,
      author_name: replyForm.value.author_name,
      author_email: replyForm.value.author_email || null,
      content: replyForm.value.content,
    })

    cancelReply()
    emit('reply-submitted')
    alert('回复提交成功！等待审核后显示。')
  } catch (err) {
    alert('回复提交失败: ' + (err.message || '未知错误'))
    console.error('提交回复失败:', err)
  } finally {
    submitting.value = false
  }
}

function handleReplySubmitted() {
  emit('reply-submitted')
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
</script>

<style scoped>
.comment-item {
  background: #f9f9f9;
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 1rem;
}

.comment-item.is-reply {
  margin-left: 2rem;
  background: #f5f5f5;
  border-left: 3px solid #667eea;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.comment-author {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.comment-author strong {
  color: #333;
}

.reply-badge {
  background: #667eea;
  color: white;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-size: 0.75rem;
}

.comment-date {
  color: #999;
  font-size: 0.9rem;
}

.comment-content {
  color: #666;
  line-height: 1.6;
  white-space: pre-wrap;
  margin-bottom: 1rem;
}

.comment-actions {
  display: flex;
  gap: 1rem;
  padding-top: 0.75rem;
  border-top: 1px solid #eee;
}

.like-btn,
.reply-btn {
  background: none;
  border: none;
  color: #666;
  cursor: pointer;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  transition: all 0.2s;
}

.like-btn:hover,
.reply-btn:hover {
  background: #eee;
  color: #333;
}

.like-btn.liked {
  color: #667eea;
  font-weight: 500;
}

.reply-form {
  margin-top: 1rem;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
}

.form-group {
  margin-bottom: 0.75rem;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 0.9rem;
  font-family: inherit;
}

.form-group textarea {
  resize: vertical;
}

.form-actions {
  display: flex;
  gap: 0.5rem;
}

.submit-btn {
  background: #667eea;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9rem;
}

.submit-btn:hover:not(:disabled) {
  background: #5568d3;
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.cancel-btn {
  background: #f5f5f5;
  color: #666;
  border: 1px solid #ddd;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9rem;
}

.cancel-btn:hover {
  background: #eee;
}

.replies {
  margin-top: 1rem;
}
</style>

