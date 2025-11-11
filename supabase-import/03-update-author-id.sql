-- ============================================
-- 更新 posts 表的 author_id
-- ============================================
-- 此脚本用于在导入 CSV 数据后，更新 author_id 字段
-- 执行时机：导入 posts.csv 后，如果有用户则执行此脚本

-- 方法 1：如果有用户，更新所有 author_id 为 NULL 的记录
-- 将 'YOUR_USER_ID' 替换为实际的用户 UUID
UPDATE posts 
SET author_id = (
    SELECT id FROM auth.users 
    ORDER BY created_at ASC 
    LIMIT 1
)
WHERE author_id IS NULL;

-- 或者手动指定用户 ID：
-- UPDATE posts 
-- SET author_id = '你的用户UUID'
-- WHERE author_id IS NULL;

-- 方法 2：如果暂时没有用户，保持 author_id 为 NULL
-- 这样不会影响数据导入，后续有用户时再更新

-- 验证更新结果
SELECT 
    id,
    title,
    author_id,
    CASE 
        WHEN author_id IS NULL THEN '未设置作者'
        ELSE '已设置作者'
    END as author_status
FROM posts;

