-- ============================================
-- 插入示例数据
-- ============================================
-- 注意：执行此脚本前，请先执行 01-create-tables.sql
-- 如果已经有数据，可以先清空表（可选）

-- ============================================
-- 清空现有数据（可选，谨慎使用）
-- ============================================
-- TRUNCATE TABLE comments CASCADE;
-- TRUNCATE TABLE posts CASCADE;
-- TRUNCATE TABLE categories CASCADE;

-- ============================================
-- 1. 插入分类数据
-- ============================================
INSERT INTO categories (id, name, slug, description, color, created_at, updated_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', '技术分享', 'tech', '技术相关的文章', '#3B82F6', '2024-01-15T10:00:00Z', '2024-01-15T10:00:00Z'),
('550e8400-e29b-41d4-a716-446655440002', '生活随笔', 'life', '生活感悟和随笔', '#10B981', '2024-01-15T10:00:00Z', '2024-01-15T10:00:00Z'),
('550e8400-e29b-41d4-a716-446655440003', '学习笔记', 'study', '学习过程中的笔记', '#F59E0B', '2024-01-15T10:00:00Z', '2024-01-15T10:00:00Z')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 2. 插入文章数据
-- ============================================
-- 注意：author_id 需要替换为实际的用户 ID
-- 可以先查询：SELECT id FROM auth.users LIMIT 1;

-- 获取第一个用户 ID（如果存在）
DO $$
DECLARE
    first_user_id UUID;
BEGIN
    SELECT id INTO first_user_id FROM auth.users LIMIT 1;
    
    -- 如果没有用户，使用 NULL（author_id 字段允许 NULL）
    -- 注意：如果 author_id 为 NULL，文章仍然可以创建，但不会关联到任何用户
    
    INSERT INTO posts (id, title, slug, content, excerpt, cover_image, category_id, author_id, published, views_count, created_at, updated_at) VALUES
    (
        '660e8400-e29b-41d4-a716-446655440001',
        '欢迎来到我的博客',
        'welcome',
        '# 欢迎来到我的博客

这是我的第一篇博客文章。在这里，我会分享我的技术学习心得、生活感悟以及各种有趣的内容。

## 关于我

我是一名软件工程师，热爱编程和技术分享。

## 博客内容

这个博客将包含以下内容：

- 技术分享
- 生活随笔
- 学习笔记

感谢你的关注！',
        '欢迎来到我的个人博客',
        'https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=800',
        '550e8400-e29b-41d4-a716-446655440002',
        first_user_id,
        true,
        0,
        '2024-01-16T10:00:00Z',
        '2024-01-16T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440002',
        'Vue 3 开发实践',
        'vue3-practice',
        '# Vue 3 开发实践

Vue 3 带来了许多新特性和改进，让我们来看看一些最佳实践。

## Composition API

Composition API 提供了更好的代码组织和复用性。

```javascript
import { ref, computed } from ''vue''

export default {
  setup() {
    const count = ref(0)
    const doubleCount = computed(() => count.value * 2)
    return { count, doubleCount }
  }
}
```

## 响应式系统

Vue 3 的响应式系统基于 Proxy，性能更优。',
        '分享 Vue 3 开发中的一些实践经验和技巧',
        'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-17T10:00:00Z',
        '2024-01-17T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440003',
        'Supabase 入门指南',
        'supabase-guide',
        '# Supabase 入门指南

Supabase 是一个开源的 Firebase 替代品，提供了数据库、认证、存储等功能。

## 主要特性

- PostgreSQL 数据库
- 实时订阅
- 身份认证
- 文件存储
- Edge Functions

## 快速开始

1. 创建项目
2. 配置数据库
3. 设置认证
4. 开始开发

希望这个指南对你有帮助！',
        '介绍 Supabase 的基本使用方法和核心功能',
        'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-18T10:00:00Z',
        '2024-01-18T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440004',
        '我的学习之旅',
        'learning-journey',
        '# 我的学习之旅

学习是一个持续的过程，今天想分享一下我的学习心得。

## 学习方法

- 理论与实践结合
- 持续练习
- 记录笔记
- 分享交流

## 学习资源

推荐一些优质的学习资源：

1. 官方文档
2. 在线课程
3. 技术社区
4. 开源项目

让我们一起成长！',
        '记录学习过程中的心得体会和资源分享',
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800',
        '550e8400-e29b-41d4-a716-446655440003',
        first_user_id,
        true,
        0,
        '2024-01-19T10:00:00Z',
        '2024-01-19T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440005',
        'JavaScript 异步编程详解',
        'javascript-async',
        '# JavaScript 异步编程详解

JavaScript 的异步编程是前端开发的核心技能之一。今天我们来深入探讨一下。

## Promise 基础

Promise 是处理异步操作的标准方式：

```javascript
const fetchData = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve("数据获取成功");
    }, 1000);
  });
};

fetchData().then(data => {
  console.log(data);
});
```

## async/await

async/await 让异步代码看起来像同步代码：

```javascript
async function getData() {
  try {
    const data = await fetchData();
    console.log(data);
  } catch (error) {
    console.error("错误:", error);
  }
}
```

## 最佳实践

1. 总是使用 try/catch 处理错误
2. 避免回调地狱
3. 合理使用 Promise.all() 并行处理

掌握异步编程，让你的代码更加优雅！',
        '深入理解 JavaScript 异步编程：Promise、async/await 和最佳实践',
        'https://images.unsplash.com/photo-1579468118864-1b9ea3c0db4a?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-20T10:00:00Z',
        '2024-01-20T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440006',
        'CSS Grid 布局实战',
        'css-grid-layout',
        '# CSS Grid 布局实战

CSS Grid 是现代网页布局的强大工具，让我们来看看如何在实际项目中使用它。

## Grid 基础

Grid 布局的核心概念：

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 20px;
}
```

## 响应式布局

使用 Grid 创建响应式布局非常简单：

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
}
```

## 实际应用

Grid 非常适合用于：
- 卡片布局
- 仪表板
- 图片画廊
- 复杂表单布局

掌握 Grid，让你的布局更加灵活！',
        '学习如何使用 CSS Grid 创建现代化、响应式的网页布局',
        'https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-21T10:00:00Z',
        '2024-01-21T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440007',
        'TypeScript 类型系统入门',
        'typescript-types',
        '# TypeScript 类型系统入门

TypeScript 为 JavaScript 添加了静态类型系统，让代码更加健壮。

## 基础类型

```typescript
let name: string = "张三";
let age: number = 25;
let isActive: boolean = true;
```

## 接口和类型

定义对象结构：

```typescript
interface User {
  name: string;
  age: number;
  email?: string; // 可选属性
}

const user: User = {
  name: "张三",
  age: 25
};
```

## 泛型

使用泛型提高代码复用性：

```typescript
function identity<T>(arg: T): T {
  return arg;
}
```

TypeScript 让大型项目更加可维护！',
        'TypeScript 类型系统的基础知识和实用技巧',
        'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-22T10:00:00Z',
        '2024-01-22T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440008',
        '周末的咖啡时光',
        'weekend-coffee',
        '# 周末的咖啡时光

周末的早晨，一杯热咖啡，一本好书，这就是我理想中的生活。

## 咖啡的选择

我偏爱手冲咖啡，喜欢那种慢慢滴落的过程，仿佛时间都慢了下来。

## 阅读的乐趣

最近在读《深入理解计算机系统》，虽然有些难懂，但每次理解一个新的概念，都让我感到兴奋。

## 思考与反思

周末是反思一周工作的好时机。回顾这周做了什么，学到了什么，还有什么需要改进的。

慢下来，享受生活，也是一种智慧。',
        '分享周末的慢生活：咖啡、阅读和思考',
        'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=800',
        '550e8400-e29b-41d4-a716-446655440002',
        first_user_id,
        true,
        0,
        '2024-01-23T10:00:00Z',
        '2024-01-23T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440009',
        '编程中的那些"啊哈"时刻',
        'programming-aha-moments',
        '# 编程中的那些"啊哈"时刻

编程路上，总有一些瞬间让你恍然大悟，今天想分享几个让我印象深刻的时刻。

## 理解闭包

第一次真正理解闭包的时候，那种感觉就像打开了新世界的大门。

```javascript
function createCounter() {
  let count = 0;
  return function() {
    return ++count;
  };
}
```

## 理解异步

从回调到 Promise，再到 async/await，每一步都是新的认知。

## 理解设计模式

当理解了设计模式背后的思想，代码设计能力有了质的飞跃。

这些"啊哈"时刻，是编程路上最珍贵的收获。',
        '分享编程学习中的那些恍然大悟的瞬间',
        'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800',
        '550e8400-e29b-41d4-a716-446655440002',
        first_user_id,
        true,
        0,
        '2024-01-24T10:00:00Z',
        '2024-01-24T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440010',
        'React Hooks 学习笔记',
        'react-hooks-notes',
        '# React Hooks 学习笔记

React Hooks 是 React 16.8 引入的新特性，让函数组件也能使用状态和生命周期。

## useState

管理组件状态：

```javascript
import { useState } from ''react'';

function Counter() {
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <p>计数: {count}</p>
      <button onClick={() => setCount(count + 1)}>
        增加
      </button>
    </div>
  );
}
```

## useEffect

处理副作用：

```javascript
useEffect(() => {
  // 组件挂载或更新时执行
  document.title = `计数: ${count}`;
}, [count]); // 依赖数组
```

## 自定义 Hooks

封装可复用的逻辑：

```javascript
function useCounter(initialValue) {
  const [count, setCount] = useState(initialValue);
  const increment = () => setCount(count + 1);
  return [count, increment];
}
```

Hooks 让 React 开发更加简洁！',
        'React Hooks 的基础用法和最佳实践学习笔记',
        'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-25T10:00:00Z',
        '2024-01-25T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440011',
        '算法学习：二分查找',
        'binary-search-algorithm',
        '# 算法学习：二分查找

二分查找是一种高效的搜索算法，时间复杂度为 O(log n)。

## 算法原理

二分查找的前提是数组必须是有序的。算法通过不断缩小搜索范围来找到目标值。

## 实现代码

```javascript
function binarySearch(arr, target) {
  let left = 0;
  let right = arr.length - 1;
  
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    
    if (arr[mid] === target) {
      return mid;
    } else if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  
  return -1; // 未找到
}
```

## 应用场景

- 有序数组查找
- 查找边界值
- 优化搜索问题

掌握基础算法，提升编程能力！',
        '学习二分查找算法的原理、实现和应用场景',
        'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
        '550e8400-e29b-41d4-a716-446655440003',
        first_user_id,
        true,
        0,
        '2024-01-26T10:00:00Z',
        '2024-01-26T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440012',
        'Git 工作流最佳实践',
        'git-workflow',
        '# Git 工作流最佳实践

Git 是版本控制的核心工具，掌握好的工作流能让团队协作更加高效。

## 分支策略

### 主分支
- `main` 或 `master`：生产环境代码
- `develop`：开发环境代码

### 功能分支
```bash
git checkout -b feature/new-feature
# 开发完成后
git checkout develop
git merge feature/new-feature
```

## 提交规范

使用清晰的提交信息：

```
feat: 添加新功能
fix: 修复 bug
docs: 更新文档
style: 代码格式调整
refactor: 代码重构
```

## 常用命令

```bash
git status          # 查看状态
git add .           # 暂存更改
git commit -m "msg" # 提交
git push            # 推送
```

好的 Git 习惯，让协作更顺畅！',
        '分享 Git 版本控制的工作流和最佳实践',
        'https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-27T10:00:00Z',
        '2024-01-27T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440013',
        '前端性能优化技巧',
        'frontend-performance',
        '# 前端性能优化技巧

性能优化是前端开发的重要课题，今天分享一些实用的优化技巧。

## 图片优化

1. **使用现代格式**
   - WebP、AVIF 格式体积更小
   - 使用 `<picture>` 标签提供多种格式

2. **懒加载**
   ```html
   <img src="image.jpg" loading="lazy" alt="...">
   ```

## 代码优化

1. **代码分割**
   - 使用动态 import
   - 路由级别的代码分割

2. **Tree Shaking**
   - 只导入需要的模块
   - 使用 ES6 模块语法

## 网络优化

1. **CDN 加速**
2. **HTTP/2 多路复用**
3. **资源压缩（Gzip/Brotli）**

性能优化是一个持续的过程！',
        '前端性能优化的实用技巧和最佳实践',
        'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-28T10:00:00Z',
        '2024-01-28T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440014',
        '读书笔记：《代码整洁之道》',
        'clean-code-notes',
        '# 读书笔记：《代码整洁之道》

最近重读了《代码整洁之道》，又有新的感悟，记录一下。

## 命名的重要性

好的命名是自解释的代码：

```javascript
// 不好的命名
const d = new Date();
const arr = [];

// 好的命名
const currentDate = new Date();
const userList = [];
```

## 函数设计

- 函数应该只做一件事
- 函数应该短小
- 参数应该尽可能少

## 注释的艺术

好的代码应该自解释，注释应该解释"为什么"而不是"是什么"。

## 错误处理

不要忽略错误，要优雅地处理它们。

整洁的代码，让维护更轻松！',
        '《代码整洁之道》的读书笔记和心得体会',
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800',
        '550e8400-e29b-41d4-a716-446655440003',
        first_user_id,
        true,
        0,
        '2024-01-29T10:00:00Z',
        '2024-01-29T10:00:00Z'
    ),
    (
        '660e8400-e29b-41d4-a716-446655440015',
        'Netlify 部署指南',
        'netlify-deployment',
        '# Netlify 部署指南

Netlify 是一个强大的静态网站托管平台，让我们来看看如何部署 Vue 项目。

## 准备工作

1. 确保项目可以正常构建
2. 准备好构建命令和输出目录

## 部署步骤

### 方法一：通过 Git 连接

1. 将代码推送到 GitHub/GitLab
2. 在 Netlify 中连接仓库
3. 配置构建设置：
   - Build command: `npm run build`
   - Publish directory: `dist`

### 方法二：手动部署

1. 运行 `npm run build`
2. 将 `dist` 目录拖拽到 Netlify

## 环境变量

在 Netlify 设置中添加环境变量：
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 自定义域名

Netlify 支持自定义域名，只需在设置中添加即可。

部署就是这么简单！',
        '如何使用 Netlify 部署 Vue 项目到生产环境',
        'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800',
        '550e8400-e29b-41d4-a716-446655440001',
        first_user_id,
        true,
        0,
        '2024-01-30T10:00:00Z',
        '2024-01-30T10:00:00Z'
    )
    ON CONFLICT (id) DO NOTHING;
END $$;

-- ============================================
-- 3. 插入评论数据
-- ============================================
INSERT INTO comments (id, post_id, user_id, author_name, author_email, content, parent_id, approved, created_at, updated_at) VALUES
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', NULL, '张三', 'zhangsan@example.com', '很棒的博客！期待更多内容！', NULL, true, '2024-01-20T10:00:00Z', '2024-01-20T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', NULL, '李四', 'lisi@example.com', '感谢分享，学到了很多！', NULL, true, '2024-01-20T11:00:00Z', '2024-01-20T11:00:00Z'),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', NULL, '王五', 'wangwu@example.com', '请问后续会更新什么内容？', '770e8400-e29b-41d4-a716-446655440001', true, '2024-01-20T12:00:00Z', '2024-01-20T12:00:00Z'),
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002', NULL, '赵六', 'zhaoliu@example.com', 'Vue 3 的 Composition API 确实很好用！', NULL, true, '2024-01-21T10:00:00Z', '2024-01-21T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440002', NULL, '孙七', 'sunqi@example.com', '能分享一下更多实战案例吗？', '770e8400-e29b-41d4-a716-446655440004', true, '2024-01-21T11:00:00Z', '2024-01-21T11:00:00Z'),
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440003', NULL, '周八', 'zhouba@example.com', 'Supabase 确实很方便，正在学习中！', NULL, true, '2024-01-22T10:00:00Z', '2024-01-22T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440005', NULL, '吴九', 'wujiu@example.com', '异步编程确实是前端必备技能，感谢分享！', NULL, true, '2024-01-21T14:00:00Z', '2024-01-21T14:00:00Z'),
('770e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440006', NULL, '郑十', 'zhengshi@example.com', 'Grid 布局真的很强大，解决了以前很多布局难题！', NULL, true, '2024-01-22T10:00:00Z', '2024-01-22T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440007', NULL, '钱十一', 'qianshiyi@example.com', 'TypeScript 的类型系统让代码更安全，值得学习！', NULL, true, '2024-01-23T10:00:00Z', '2024-01-23T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440010', '660e8400-e29b-41d4-a716-446655440008', NULL, '孙十二', 'sunshier@example.com', '慢生活真的很重要，工作之余也要享受生活！', NULL, true, '2024-01-24T10:00:00Z', '2024-01-24T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440011', '660e8400-e29b-41d4-a716-446655440010', NULL, '李十三', 'lishisan@example.com', 'React Hooks 让函数组件也能管理状态，太方便了！', NULL, true, '2024-01-26T10:00:00Z', '2024-01-26T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440012', '660e8400-e29b-41d4-a716-446655440011', NULL, '王十四', 'wangshisi@example.com', '二分查找算法很经典，感谢详细的讲解！', NULL, true, '2024-01-27T10:00:00Z', '2024-01-27T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440013', '660e8400-e29b-41d4-a716-446655440012', NULL, '张十五', 'zhangshiwu@example.com', 'Git 工作流确实很重要，团队协作必备！', NULL, true, '2024-01-28T10:00:00Z', '2024-01-28T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440014', '660e8400-e29b-41d4-a716-446655440013', NULL, '赵十六', 'zhaoshiliu@example.com', '性能优化是前端永恒的话题，这些技巧很实用！', NULL, true, '2024-01-29T10:00:00Z', '2024-01-29T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440015', '660e8400-e29b-41d4-a716-446655440014', NULL, '周十七', 'zhoushiqi@example.com', '《代码整洁之道》确实是经典，值得反复阅读！', NULL, true, '2024-01-30T10:00:00Z', '2024-01-30T10:00:00Z'),
('770e8400-e29b-41d4-a716-446655440016', '660e8400-e29b-41d4-a716-446655440015', NULL, '吴十八', 'wushiba@example.com', 'Netlify 部署真的很简单，感谢分享部署指南！', NULL, true, '2024-01-31T10:00:00Z', '2024-01-31T10:00:00Z')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 完成！
-- ============================================
-- 示例数据插入完成
-- 可以在 Table Editor 中查看数据
-- ============================================

