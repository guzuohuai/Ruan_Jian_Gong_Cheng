-- ============================================
-- 添加更多文章内容
-- ============================================
-- 此脚本包含 11 篇新文章
-- 执行时机：在 02-insert-sample-data.sql 之后执行
-- 或者单独执行此脚本添加新文章

-- 获取第一个用户 ID（如果存在）
DO $$
DECLARE
    first_user_id UUID;
BEGIN
    SELECT id INTO first_user_id FROM auth.users LIMIT 1;
    
    -- 如果没有用户，使用占位符 UUID
    IF first_user_id IS NULL THEN
        first_user_id := '00000000-0000-0000-0000-000000000000';
    END IF;
    
    INSERT INTO posts (id, title, slug, content, excerpt, cover_image, category_id, author_id, published, views_count, created_at, updated_at) VALUES
    (
        '660e8400-e29b-41d4-a716-446655440005',
        'JavaScript 异步编程详解',
        'javascript-async',
        '# JavaScript 异步编程详解\n\nJavaScript 的异步编程是前端开发的核心技能之一。今天我们来深入探讨一下。\n\n## Promise 基础\n\nPromise 是处理异步操作的标准方式：\n\n```javascript\nconst fetchData = () => {\n  return new Promise((resolve, reject) => {\n    setTimeout(() => {\n      resolve("数据获取成功");\n    }, 1000);\n  });\n};\n\nfetchData().then(data => {\n  console.log(data);\n});\n```\n\n## async/await\n\nasync/await 让异步代码看起来像同步代码：\n\n```javascript\nasync function getData() {\n  try {\n    const data = await fetchData();\n    console.log(data);\n  } catch (error) {\n    console.error("错误:", error);\n  }\n}\n```\n\n## 最佳实践\n\n1. 总是使用 try/catch 处理错误\n2. 避免回调地狱\n3. 合理使用 Promise.all() 并行处理\n\n掌握异步编程，让你的代码更加优雅！',
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
        '# CSS Grid 布局实战\n\nCSS Grid 是现代网页布局的强大工具，让我们来看看如何在实际项目中使用它。\n\n## Grid 基础\n\nGrid 布局的核心概念：\n\n```css\n.container {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n  grid-gap: 20px;\n}\n```\n\n## 响应式布局\n\n使用 Grid 创建响应式布局非常简单：\n\n```css\n.grid {\n  display: grid;\n  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));\n}\n```\n\n## 实际应用\n\nGrid 非常适合用于：\n- 卡片布局\n- 仪表板\n- 图片画廊\n- 复杂表单布局\n\n掌握 Grid，让你的布局更加灵活！',
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
        '# TypeScript 类型系统入门\n\nTypeScript 为 JavaScript 添加了静态类型系统，让代码更加健壮。\n\n## 基础类型\n\n```typescript\nlet name: string = "张三";\nlet age: number = 25;\nlet isActive: boolean = true;\n```\n\n## 接口和类型\n\n定义对象结构：\n\n```typescript\ninterface User {\n  name: string;\n  age: number;\n  email?: string; // 可选属性\n}\n\nconst user: User = {\n  name: "张三",\n  age: 25\n};\n```\n\n## 泛型\n\n使用泛型提高代码复用性：\n\n```typescript\nfunction identity<T>(arg: T): T {\n  return arg;\n}\n```\n\nTypeScript 让大型项目更加可维护！',
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
        '# 周末的咖啡时光\n\n周末的早晨，一杯热咖啡，一本好书，这就是我理想中的生活。\n\n## 咖啡的选择\n\n我偏爱手冲咖啡，喜欢那种慢慢滴落的过程，仿佛时间都慢了下来。\n\n## 阅读的乐趣\n\n最近在读《深入理解计算机系统》，虽然有些难懂，但每次理解一个新的概念，都让我感到兴奋。\n\n## 思考与反思\n\n周末是反思一周工作的好时机。回顾这周做了什么，学到了什么，还有什么需要改进的。\n\n慢下来，享受生活，也是一种智慧。',
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
        '# 编程中的那些"啊哈"时刻\n\n编程路上，总有一些瞬间让你恍然大悟，今天想分享几个让我印象深刻的时刻。\n\n## 理解闭包\n\n第一次真正理解闭包的时候，那种感觉就像打开了新世界的大门。\n\n```javascript\nfunction createCounter() {\n  let count = 0;\n  return function() {\n    return ++count;\n  };\n}\n```\n\n## 理解异步\n\n从回调到 Promise，再到 async/await，每一步都是新的认知。\n\n## 理解设计模式\n\n当理解了设计模式背后的思想，代码设计能力有了质的飞跃。\n\n这些"啊哈"时刻，是编程路上最珍贵的收获。',
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
        '# React Hooks 学习笔记\n\nReact Hooks 是 React 16.8 引入的新特性，让函数组件也能使用状态和生命周期。\n\n## useState\n\n管理组件状态：\n\n```javascript\nimport { useState } from ''react'';\n\nfunction Counter() {\n  const [count, setCount] = useState(0);\n  \n  return (\n    <div>\n      <p>计数: {count}</p>\n      <button onClick={() => setCount(count + 1)}>\n        增加\n      </button>\n    </div>\n  );\n}\n```\n\n## useEffect\n\n处理副作用：\n\n```javascript\nuseEffect(() => {\n  // 组件挂载或更新时执行\n  document.title = `计数: ${count}`;\n}, [count]); // 依赖数组\n```\n\n## 自定义 Hooks\n\n封装可复用的逻辑：\n\n```javascript\nfunction useCounter(initialValue) {\n  const [count, setCount] = useState(initialValue);\n  const increment = () => setCount(count + 1);\n  return [count, increment];\n}\n```\n\nHooks 让 React 开发更加简洁！',
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
        '# 算法学习：二分查找\n\n二分查找是一种高效的搜索算法，时间复杂度为 O(log n)。\n\n## 算法原理\n\n二分查找的前提是数组必须是有序的。算法通过不断缩小搜索范围来找到目标值。\n\n## 实现代码\n\n```javascript\nfunction binarySearch(arr, target) {\n  let left = 0;\n  let right = arr.length - 1;\n  \n  while (left <= right) {\n    const mid = Math.floor((left + right) / 2);\n    \n    if (arr[mid] === target) {\n      return mid;\n    } else if (arr[mid] < target) {\n      left = mid + 1;\n    } else {\n      right = mid - 1;\n    }\n  }\n  \n  return -1; // 未找到\n}\n```\n\n## 应用场景\n\n- 有序数组查找\n- 查找边界值\n- 优化搜索问题\n\n掌握基础算法，提升编程能力！',
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
        '# Git 工作流最佳实践\n\nGit 是版本控制的核心工具，掌握好的工作流能让团队协作更加高效。\n\n## 分支策略\n\n### 主分支\n- `main` 或 `master`：生产环境代码\n- `develop`：开发环境代码\n\n### 功能分支\n```bash\ngit checkout -b feature/new-feature\n# 开发完成后\ngit checkout develop\ngit merge feature/new-feature\n```\n\n## 提交规范\n\n使用清晰的提交信息：\n\n```\nfeat: 添加新功能\nfix: 修复 bug\ndocs: 更新文档\nstyle: 代码格式调整\nrefactor: 代码重构\n```\n\n## 常用命令\n\n```bash\ngit status          # 查看状态\ngit add .           # 暂存更改\ngit commit -m "msg" # 提交\ngit push            # 推送\n```\n\n好的 Git 习惯，让协作更顺畅！',
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
        '# 前端性能优化技巧\n\n性能优化是前端开发的重要课题，今天分享一些实用的优化技巧。\n\n## 图片优化\n\n1. **使用现代格式**\n   - WebP、AVIF 格式体积更小\n   - 使用 `<picture>` 标签提供多种格式\n\n2. **懒加载**\n   ```html\n   <img src="image.jpg" loading="lazy" alt="...">\n   ```\n\n## 代码优化\n\n1. **代码分割**\n   - 使用动态 import\n   - 路由级别的代码分割\n\n2. **Tree Shaking**\n   - 只导入需要的模块\n   - 使用 ES6 模块语法\n\n## 网络优化\n\n1. **CDN 加速**\n2. **HTTP/2 多路复用**\n3. **资源压缩（Gzip/Brotli）**\n\n性能优化是一个持续的过程！',
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
        '# 读书笔记：《代码整洁之道》\n\n最近重读了《代码整洁之道》，又有新的感悟，记录一下。\n\n## 命名的重要性\n\n好的命名是自解释的代码：\n\n```javascript\n// 不好的命名\nconst d = new Date();\nconst arr = [];\n\n// 好的命名\nconst currentDate = new Date();\nconst userList = [];\n```\n\n## 函数设计\n\n- 函数应该只做一件事\n- 函数应该短小\n- 参数应该尽可能少\n\n## 注释的艺术\n\n好的代码应该自解释，注释应该解释"为什么"而不是"是什么"。\n\n## 错误处理\n\n不要忽略错误，要优雅地处理它们。\n\n整洁的代码，让维护更轻松！',
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
        '# Netlify 部署指南\n\nNetlify 是一个强大的静态网站托管平台，让我们来看看如何部署 Vue 项目。\n\n## 准备工作\n\n1. 确保项目可以正常构建\n2. 准备好构建命令和输出目录\n\n## 部署步骤\n\n### 方法一：通过 Git 连接\n\n1. 将代码推送到 GitHub/GitLab\n2. 在 Netlify 中连接仓库\n3. 配置构建设置：\n   - Build command: `npm run build`\n   - Publish directory: `dist`\n\n### 方法二：手动部署\n\n1. 运行 `npm run build`\n2. 将 `dist` 目录拖拽到 Netlify\n\n## 环境变量\n\n在 Netlify 设置中添加环境变量：\n- `VITE_SUPABASE_URL`\n- `VITE_SUPABASE_ANON_KEY`\n\n## 自定义域名\n\nNetlify 支持自定义域名，只需在设置中添加即可。\n\n部署就是这么简单！',
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
-- 添加更多评论
-- ============================================
INSERT INTO comments (id, post_id, user_id, author_name, author_email, content, parent_id, approved, created_at, updated_at) VALUES
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
-- 已添加 11 篇新文章和 10 条新评论
-- 现在总共有 15 篇文章
-- ============================================

