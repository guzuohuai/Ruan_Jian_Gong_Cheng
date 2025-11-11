# 个人博客系统

基于 Vue 3 + Supabase + Netlify 开发的个人博客网站。

## ✨ 功能特性

- 📝 **文章管理** - 支持 Markdown 格式，完整的文章展示
- 🔍 **搜索功能** - 实时搜索文章标题、内容和摘要
- 📄 **分页浏览** - 支持分页显示，每页 6 篇文章
- 💬 **评论系统** - 支持评论、回复和点赞功能
- 🏷️ **分类管理** - 文章分类展示和筛选
- 🎨 **响应式设计** - 适配各种设备屏幕

## 🚀 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 配置环境变量

在项目根目录创建 `.env` 文件：

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 3. 设置 Supabase 数据库

1. 登录 [Supabase Dashboard](https://app.supabase.com)
2. 进入 **SQL Editor**
3. 执行 `supabase-import/01-create-tables.sql` 创建表结构
4. 执行 `supabase-import/02-insert-sample-data.sql` 导入示例数据

详细说明请查看 `supabase-import/README.md`

### 4. 启动开发服务器

```bash
npm run dev
```

访问 `http://localhost:5173` 查看博客。

## 📦 技术栈

- **前端框架**: Vue 3 (Composition API)
- **构建工具**: Vite
- **路由**: Vue Router
- **状态管理**: Pinia
- **后端服务**: Supabase (PostgreSQL + Auth)
- **部署平台**: Netlify
- **Markdown 渲染**: marked

## 📁 项目结构

```
├── src/
│   ├── components/      # 组件
│   │   ├── NavBar.vue
│   │   ├── SearchBar.vue
│   │   ├── Pagination.vue
│   │   └── CommentItem.vue
│   ├── views/           # 页面视图
│   │   ├── HomeView.vue
│   │   ├── PostView.vue
│   │   ├── CategoryView.vue
│   │   └── AboutView.vue
│   ├── services/        # API 服务
│   │   └── api.js
│   ├── stores/          # 状态管理
│   │   └── auth.js
│   ├── lib/             # 工具库
│   │   └── supabase.js
│   ├── utils/           # 工具函数
│   │   └── markdown.js
│   └── styles/          # 样式文件
│       └── markdown.css
├── supabase-import/     # 数据库脚本
│   ├── 01-create-tables.sql
│   ├── 02-insert-sample-data.sql
│   ├── 03-update-author-id.sql
│   ├── 05-add-more-posts.sql
│   └── README.md
└── public/              # 静态资源
```

## 🛠️ 开发命令

```bash
# 开发模式
npm run dev

# 构建生产版本
npm run build

# 预览生产构建
npm run preview
```

## 📝 数据库结构

### 表说明

- **categories** - 文章分类表
- **posts** - 文章表
- **comments** - 评论表

详细表结构请查看 `supabase-import/01-create-tables.sql`

## 🌐 部署到 Netlify

详细的部署指南请查看 **[NETLIFY_DEPLOY.md](./NETLIFY_DEPLOY.md)**

### 快速部署步骤

1. **推送代码到 Git 仓库**（GitHub/GitLab/Bitbucket）
2. **在 Netlify 中连接仓库**
   - 登录 [Netlify](https://app.netlify.com)
   - 点击 **Add new site** → **Import an existing project**
   - 选择你的 Git 提供商并授权
3. **配置构建设置**（通常会自动检测）
   - Build command: `npm run build`
   - Publish directory: `dist`
4. **添加环境变量**
   - `VITE_SUPABASE_URL` = 你的 Supabase URL
   - `VITE_SUPABASE_ANON_KEY` = 你的 Supabase Anon Key
5. **点击 Deploy site**

### 配置文件

项目已包含以下配置文件，无需额外配置：

- `netlify.toml` - Netlify 构建配置
- `public/_redirects` - SPA 路由重定向规则

## 📚 相关文档

- [Supabase 文档](https://supabase.com/docs)
- [Vue 3 文档](https://vuejs.org/)
- [Vite 文档](https://vite.dev/)

## 📄 License

MIT
