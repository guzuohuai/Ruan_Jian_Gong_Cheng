<template>
  <div class="search-bar">
    <div class="search-input-wrapper">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="搜索文章..."
        class="search-input"
        @input="handleSearch"
        @keyup.enter="handleSearch"
      />
      <button @click="handleSearch" class="search-button" :disabled="loading">
        <span v-if="loading">搜索中...</span>
        <span v-else>🔍</span>
      </button>
      <button v-if="searchQuery" @click="clearSearch" class="clear-button">✕</button>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  modelValue: {
    type: String,
    default: '',
  },
  loading: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['update:modelValue', 'search'])

const searchQuery = ref(props.modelValue)

watch(() => props.modelValue, (newVal) => {
  searchQuery.value = newVal
})

function handleSearch() {
  emit('update:modelValue', searchQuery.value)
  emit('search', searchQuery.value)
}

function clearSearch() {
  searchQuery.value = ''
  handleSearch()
}
</script>

<style scoped>
.search-bar {
  margin-bottom: 2rem;
}

.search-input-wrapper {
  display: flex;
  gap: 0.5rem;
  max-width: 600px;
  margin: 0 auto;
}

.search-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.2s;
}

.search-input:focus {
  outline: none;
  border-color: #667eea;
}

.search-button,
.clear-button {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  transition: background 0.2s;
}

.search-button {
  background: #667eea;
  color: white;
}

.search-button:hover:not(:disabled) {
  background: #5568d3;
}

.search-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.clear-button {
  background: #f5f5f5;
  color: #666;
}

.clear-button:hover {
  background: #e0e0e0;
}
</style>

