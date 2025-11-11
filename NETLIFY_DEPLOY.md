# Netlify 部署指南

本指南将帮助你将 Vue 博客项目部署到 Netlify。

## 📋 部署前准备

### 1. 确保项目可以正常构建

在本地测试构建：

```bash
npm run build
```

构建成功后，会在 `dist` 目录生成静态文件。

### 2. 准备环境变量

确保你的 `.env` 文件包含以下变量：

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

**重要**：`.env` 文件不会被部署，需要在 Netlify 中单独配置环境变量。

---

## 🚀 部署方法

### 方法一：通过 Git 连接（推荐）

这是最推荐的方法，支持自动部署和持续集成。

#### 步骤 1：推送代码到 Git 仓库

1. 确保代码已提交到 GitHub、GitLab 或 Bitbucket
2. 如果还没有，可以创建新仓库并推送：

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
```

#### 步骤 2：在 Netlify 中连接仓库

1. 登录 [Netlify](https://app.netlify.com)
2. 点击 **Add new site** → **Import an existing project**
3. 选择你的 Git 提供商（GitHub/GitLab/Bitbucket）
4. 授权 Netlify 访问你的仓库
5. 选择要部署的仓库

#### 步骤 3：配置构建设置

Netlify 会自动检测 Vue 项目，但请确认以下设置：

- **Build command**: `npm run build`
- **Publish directory**: `dist`
- **Node version**: 选择 Node.js 20 或更高版本（在 `package.json` 中已指定）

#### 步骤 4：配置环境变量

1. 在构建设置页面，点击 **Environment variables**
2. 添加以下环境变量：

```
VITE_SUPABASE_URL = https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY = your-anon-key-here
```

3. 点击 **Deploy site**

#### 步骤 5：等待部署完成

部署完成后，Netlify 会提供一个随机域名（如 `your-site-name.netlify.app`）。

---

### 方法二：手动部署（拖拽）

适合快速测试，但不支持自动更新。

#### 步骤 1：构建项目

```bash
npm run build
```

#### 步骤 2：部署到 Netlify

1. 登录 [Netlify](https://app.netlify.com)
2. 点击 **Add new site** → **Deploy manually**
3. 将 `dist` 目录拖拽到部署区域
4. 等待上传和部署完成

**注意**：手动部署无法自动配置环境变量，需要：
1. 在站点设置中添加环境变量
2. 重新部署

---

## ⚙️ 配置说明

### 1. 创建 Netlify 配置文件（可选）

项目根目录已包含 `netlify.toml` 配置文件，包含以下设置：

- 构建命令和输出目录
- Node.js 版本
- 重定向规则（用于 SPA 路由）

### 2. SPA 路由配置

Vue Router 使用 History 模式，需要配置重定向规则。项目已包含 `public/_redirects` 文件，确保所有路由都指向 `index.html`。

---

## 🔧 环境变量配置

### 在 Netlify Dashboard 中配置

1. 进入站点设置：**Site settings** → **Environment variables**
2. 点击 **Add variable**
3. 添加以下变量：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `VITE_SUPABASE_URL` | `https://xxx.supabase.co` | Supabase 项目 URL |
| `VITE_SUPABASE_ANON_KEY` | `your-anon-key` | Supabase 匿名密钥 |

### 不同环境的环境变量

可以为不同分支设置不同的环境变量：

- **Production**: 生产环境（main/master 分支）
- **Deploy previews**: 预览环境（PR/分支）
- **Branch deploys**: 分支环境

---

## 🌐 自定义域名

### 添加自定义域名

1. 进入站点设置：**Site settings** → **Domain management**
2. 点击 **Add custom domain**
3. 输入你的域名（如 `blog.example.com`）
4. 按照提示配置 DNS 记录

### DNS 配置

#### 方法一：CNAME 记录（推荐）

```
类型: CNAME
名称: blog (或 @)
值: your-site-name.netlify.app
```

#### 方法二：A 记录

```
类型: A
名称: blog (或 @)
值: 75.2.60.5 (Netlify 的 IP)
```

### SSL 证书

Netlify 会自动为所有域名提供免费的 SSL 证书（Let's Encrypt），通常几分钟内生效。

---

## 🔄 持续部署

### 自动部署

连接 Git 仓库后，Netlify 会自动：

- ✅ 监听代码推送
- ✅ 自动触发构建
- ✅ 部署新版本

### 部署预览

- **Pull Request**: 每个 PR 会自动创建预览部署
- **分支部署**: 可以配置特定分支自动部署

### 回滚部署

如果需要回滚到之前的版本：

1. 进入 **Deploys** 页面
2. 找到要回滚的部署
3. 点击 **Publish deploy**

---

## 🐛 常见问题

### 问题 1：页面刷新 404 错误

**原因**：SPA 路由需要重定向配置

**解决**：确保 `public/_redirects` 文件存在，内容为：
```
/*    /index.html   200
```

### 问题 2：环境变量不生效

**原因**：环境变量名必须以 `VITE_` 开头

**解决**：检查环境变量名是否正确，并重新部署

### 问题 3：构建失败

**可能原因**：
- Node.js 版本不匹配
- 依赖安装失败
- 构建命令错误

**解决**：
1. 检查 `package.json` 中的 `engines` 字段
2. 在 Netlify 设置中指定 Node.js 版本
3. 查看构建日志定位具体错误

### 问题 4：Supabase 连接失败

**原因**：环境变量未正确配置

**解决**：
1. 检查 Netlify 中的环境变量
2. 确保变量名和值都正确
3. 重新部署

### 问题 5：CORS 错误

**原因**：Supabase 未配置允许的域名

**解决**：
1. 登录 Supabase Dashboard
2. 进入 **Settings** → **API**
3. 在 **Additional allowed origins** 中添加你的 Netlify 域名

---

## 📊 部署检查清单

部署前请确认：

- [ ] 本地构建成功（`npm run build`）
- [ ] 环境变量已准备（Supabase URL 和 Key）
- [ ] 代码已推送到 Git 仓库（如果使用 Git 部署）
- [ ] `netlify.toml` 配置文件已创建（可选）
- [ ] `public/_redirects` 文件已创建（用于 SPA 路由）
- [ ] Supabase RLS 策略已正确配置
- [ ] Supabase 允许的域名已配置

---

## 🎉 部署完成

部署成功后，你可以：

1. **访问网站**：使用 Netlify 提供的域名或自定义域名
2. **查看日志**：在 **Deploys** 页面查看构建和部署日志
3. **监控性能**：使用 Netlify Analytics 查看访问统计
4. **配置通知**：设置部署成功/失败的邮件通知

---

## 📚 相关资源

- [Netlify 文档](https://docs.netlify.com/)
- [Vite 部署指南](https://vite.dev/guide/static-deploy.html#netlify)
- [Vue Router History 模式](https://router.vuejs.org/guide/essentials/history-mode.html)

---

## 💡 提示

- 使用 Git 部署可以享受自动部署、预览部署等功能
- 定期检查构建日志，确保部署正常
- 生产环境建议使用自定义域名
- 可以配置 Netlify Forms 来收集评论（替代 Supabase）

祝你部署顺利！🚀

