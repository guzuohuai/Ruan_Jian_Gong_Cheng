<template>
  <div class="about-view">
    <div class="about-content">
      <h1>关于我</h1>
      
      <section class="about-section">
        <h2>个人简介</h2>
        <p>
          欢迎来到我的个人博客！我是一名软件工程师，热爱编程和技术分享。
          在这里，我会分享我的技术学习心得、生活感悟以及各种有趣的内容。
        </p>
      </section>

      <section class="about-section">
        <h2>博客内容</h2>
        <ul>
          <li>📚 技术分享 - 记录学习过程中的技术要点和实践经验</li>
          <li>💭 生活随笔 - 分享生活中的思考和感悟</li>
          <li>📝 学习笔记 - 整理学习过程中的笔记和总结</li>
        </ul>
      </section>

      <section class="about-section">
        <h2>技术栈</h2>
        <div class="tech-stack">
          <span class="tech-tag">Vue.js</span>
          <span class="tech-tag">Supabase</span>
          <span class="tech-tag">Vite</span>
          <span class="tech-tag">JavaScript</span>
          <span class="tech-tag">PostgreSQL</span>
        </div>
      </section>

      <section class="about-section">
        <h2>联系方式</h2>
        <p>如果你有任何问题或建议，欢迎通过评论或邮件联系我。</p>
      </section>

      <router-link to="/" class="back-link">← 返回首页</router-link>
    </div>
  </div>
</template>

<script setup>
// 关于页面，静态内容
</script>

<style scoped>
.about-view {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.about-content {
  background: white;
  border-radius: 12px;
  padding: 3rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.about-content h1 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.about-section {
  margin-bottom: 2.5rem;
}

.about-section h2 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #333;
}

.about-section p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 1rem;
}

.about-section ul {
  list-style: none;
  padding: 0;
}

.about-section li {
  padding: 0.75rem 0;
  color: #666;
  line-height: 1.6;
  border-bottom: 1px solid #eee;
}

.about-section li:last-child {
  border-bottom: none;
}

.tech-stack {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
}

.tech-tag {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 500;
}

.back-link {
  display: inline-block;
  margin-top: 2rem;
  color: #667eea;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s;
}

.back-link:hover {
  color: #764ba2;
}
</style>

