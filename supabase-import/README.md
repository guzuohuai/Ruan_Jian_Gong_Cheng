# Supabase 数据库创建和数据导入指南

本目录包含用于在 Supabase 中创建表结构和导入数据的文件。

## 文件说明

### SQL 脚本文件（推荐使用）
1. **01-create-tables.sql** - 创建所有表结构（字段、索引、触发器、RLS策略）
2. **02-insert-sample-data.sql** - 插入示例数据

### CSV 文件（可选，用于数据导入）
1. **categories.csv** - 分类表数据（3条记录）
2. **posts.csv** - 文章表数据（4条记录）
3. **comments.csv** - 评论表数据（6条记录）

---

## 🚀 快速开始（推荐方法）

### 方法一：使用 SQL 脚本（最简单）

这是**最推荐的方法**，可以一次性创建所有表结构和数据。

#### 步骤 1：创建表结构

1. 登录 [Supabase Dashboard](https://app.supabase.com)
2. 选择你的项目
3. 进入 **SQL Editor**
4. 点击 **New Query**
5. 打开并复制 `01-create-tables.sql` 文件的全部内容
6. 粘贴到 SQL Editor 中
7. 点击 **Run** 或按 `Ctrl+Enter` 执行

这将创建：
- ✅ 3 个数据表（categories, posts, comments）
- ✅ 所有字段和约束
- ✅ 外键关系
- ✅ 索引（提高查询性能）
- ✅ 自动更新时间触发器
- ✅ Row Level Security (RLS) 策略

#### 步骤 2：插入示例数据（可选）

1. 在 SQL Editor 中创建新查询
2. 打开并复制 `02-insert-sample-data.sql` 文件的全部内容
3. 粘贴并执行

这将插入：
- ✅ 3 个分类
- ✅ 4 篇文章
- ✅ 6 条评论

**完成！** 现在你可以在 Table Editor 中查看所有表和数据了。

---

## 其他导入方法

### 方法二：使用 CSV 文件导入数据

如果你已经通过 SQL 脚本创建了表结构，只想导入数据，可以使用 CSV 文件。

**重要：必须按照以下顺序导入，因为存在外键依赖关系**

1. 首先导入 `categories.csv`
2. 然后导入 `posts.csv`
3. 最后导入 `comments.csv`

#### 使用 Supabase Dashboard 导入 CSV

1. 登录 [Supabase Dashboard](https://app.supabase.com)
2. 选择你的项目
3. 进入 **Table Editor**
4. 选择对应的表（categories / posts / comments）
5. 点击表右上角的 **Insert** 或 **Import data** 按钮
6. 选择对应的 CSV 文件
7. 确认字段映射（确保列名匹配）
8. 点击导入

#### 使用 SQL Editor 导入 CSV

```sql
-- 注意：Supabase 的 COPY 命令需要文件在服务器上
-- 通常需要通过 Dashboard 的导入功能或使用其他方法
```

#### 使用 Supabase CLI 导入 CSV

```bash
# 安装 Supabase CLI（如果还没有）
npm install -g supabase

# 登录
supabase login

# 链接项目
supabase link --project-ref your-project-ref

# 导入数据（按顺序）
supabase db import categories.csv --table categories
supabase db import posts.csv --table posts
supabase db import comments.csv --table comments
```

## 注意事项

### 1. author_id 字段

**如果使用 SQL 脚本（02-insert-sample-data.sql）**：
- 脚本会自动检测第一个用户 ID
- 如果没有用户，会使用占位符 UUID
- 建议先创建用户，然后执行脚本

**如果使用 CSV 文件导入**：
- ✅ **已修复**：`posts.csv` 中的 `author_id` 字段现在为空（NULL），可以直接导入
- 导入后，如果需要设置作者，可以执行 `03-update-author-id.sql` 脚本

**更新 author_id 的方法**：

**方法 1：使用提供的 SQL 脚本（推荐）**
1. 在 SQL Editor 中打开并执行 `03-update-author-id.sql`
2. 脚本会自动使用第一个用户 ID 更新所有文章

**方法 2：手动更新**
```sql
-- 获取你的用户 ID（从 auth.users 表）
SELECT id FROM auth.users LIMIT 1;

-- 更新 posts 表的 author_id
UPDATE posts 
SET author_id = '你的用户ID'
WHERE author_id IS NULL;
```

**创建用户的方法**：
1. 在 Supabase Dashboard 中进入 **Authentication** → **Users**
2. 点击 **Add user** 创建新用户
3. 记录该用户的 UUID
4. 在 SQL Editor 中执行更新语句

**注意**：`author_id` 可以为 NULL，不影响数据导入和基本功能。后续有用户时再更新即可。

### 2. 外键关系

- `posts.category_id` 必须对应 `categories.id` 中存在的值
- `comments.post_id` 必须对应 `posts.id` 中存在的值
- `comments.parent_id` 可以对应 `comments.id` 中的值（用于回复）

### 3. 时间格式

CSV 中的时间格式为 ISO 8601：`YYYY-MM-DDTHH:MM:SSZ`

### 4. 空值处理

- `user_id` 字段可以为空（支持匿名评论）
- `parent_id` 字段可以为空（顶级评论）
- `cover_image`、`excerpt`、`description` 等可选字段可以为空

## 数据说明

### categories.csv
包含 3 个分类：
- 技术分享 (tech)
- 生活随笔 (life)
- 学习笔记 (study)

### posts.csv
包含 4 篇文章：
- 欢迎来到我的博客
- Vue 3 开发实践
- Supabase 入门指南
- 我的学习之旅

### comments.csv
包含 6 条评论：
- 3 条针对"欢迎来到我的博客"的评论（其中 1 条是回复）
- 2 条针对"Vue 3 开发实践"的评论（其中 1 条是回复）
- 1 条针对"Supabase 入门指南"的评论

## 验证创建和导入

执行完 SQL 脚本或导入 CSV 后，可以在 SQL Editor 中执行以下查询验证：

```sql
-- 检查表是否存在
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('categories', 'posts', 'comments');

-- 检查分类数量
SELECT COUNT(*) as category_count FROM categories;

-- 检查文章数量
SELECT COUNT(*) as post_count FROM posts;

-- 检查评论数量
SELECT COUNT(*) as comment_count FROM comments;

-- 检查文章和分类的关联
SELECT p.title, c.name as category, p.published
FROM posts p
JOIN categories c ON p.category_id = c.id;

-- 检查评论和文章的关联
SELECT p.title, COUNT(c.id) as comment_count
FROM posts p
LEFT JOIN comments c ON p.id = c.post_id AND c.approved = true
GROUP BY p.id, p.title;

-- 检查 RLS 是否启用
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('categories', 'posts', 'comments');
```

## 故障排除

### 问题：外键约束错误
**解决**：确保按照正确的顺序导入（categories → posts → comments）

### 问题：UUID 格式错误
**解决**：检查 CSV 文件中的 UUID 格式是否正确

### 问题：时间格式错误
**解决**：确保时间格式为 ISO 8601 格式

### 问题：author_id 不存在
**解决**：先创建用户，或更新 posts 表中的 author_id 为有效的用户 UUID

