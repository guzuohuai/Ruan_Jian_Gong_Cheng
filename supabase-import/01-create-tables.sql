-- ============================================
-- Supabase 博客系统表结构创建脚本
-- ============================================
-- 执行顺序：按顺序执行此脚本即可创建所有表
-- 执行位置：Supabase Dashboard → SQL Editor

-- ============================================
-- 1. 创建 categories 表（分类表）
-- ============================================
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    color TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 2. 创建 posts 表（文章表）
-- ============================================
CREATE TABLE IF NOT EXISTS posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    slug TEXT NOT NULL UNIQUE,
    cover_image TEXT,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    author_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    published BOOLEAN DEFAULT false,
    views_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 3. 创建 comments 表（评论表）
-- ============================================
CREATE TABLE IF NOT EXISTS comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    author_name TEXT NOT NULL,
    author_email TEXT,
    content TEXT NOT NULL,
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    approved BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 4. 创建索引（提高查询性能）
-- ============================================

-- categories 表索引
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);

-- posts 表索引
CREATE INDEX IF NOT EXISTS idx_posts_slug ON posts(slug);
CREATE INDEX IF NOT EXISTS idx_posts_category ON posts(category_id);
CREATE INDEX IF NOT EXISTS idx_posts_published_created ON posts(published, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_author ON posts(author_id);

-- comments 表索引
CREATE INDEX IF NOT EXISTS idx_comments_post ON comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments(parent_id);
CREATE INDEX IF NOT EXISTS idx_comments_approved ON comments(approved);
CREATE INDEX IF NOT EXISTS idx_comments_user ON comments(user_id);

-- ============================================
-- 5. 创建更新时间触发器函数
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 为每个表创建更新时间触发器
CREATE TRIGGER update_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at
    BEFORE UPDATE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 6. 启用 Row Level Security (RLS)
-- ============================================
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 7. 创建 RLS 策略
-- ============================================

-- categories 表策略
-- 所有人可以查看分类
CREATE POLICY "任何人都可以查看分类"
    ON categories FOR SELECT
    USING (true);

-- 仅认证用户可以管理分类
CREATE POLICY "仅认证用户可以插入分类"
    ON categories FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "仅认证用户可以更新分类"
    ON categories FOR UPDATE
    USING (auth.role() = 'authenticated');

CREATE POLICY "仅认证用户可以删除分类"
    ON categories FOR DELETE
    USING (auth.role() = 'authenticated');

-- posts 表策略
-- 所有人可以查看已发布的文章
CREATE POLICY "任何人都可以查看已发布的文章"
    ON posts FOR SELECT
    USING (published = true OR auth.uid() = author_id);

-- 仅认证用户可以创建文章
CREATE POLICY "仅认证用户可以创建文章"
    ON posts FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- 仅作者可以更新自己的文章
CREATE POLICY "仅作者可以更新自己的文章"
    ON posts FOR UPDATE
    USING (auth.uid() = author_id);

-- 仅作者可以删除自己的文章
CREATE POLICY "仅作者可以删除自己的文章"
    ON posts FOR DELETE
    USING (auth.uid() = author_id);

-- comments 表策略
-- 所有人可以查看已审核的评论
CREATE POLICY "任何人都可以查看已审核的评论"
    ON comments FOR SELECT
    USING (approved = true OR auth.uid() = user_id);

-- 所有人可以创建评论
CREATE POLICY "任何人都可以创建评论"
    ON comments FOR INSERT
    WITH CHECK (true);

-- 仅评论作者可以更新自己的评论
CREATE POLICY "仅评论作者可以更新自己的评论"
    ON comments FOR UPDATE
    USING (auth.uid() = user_id);

-- 仅评论作者可以删除自己的评论
CREATE POLICY "仅评论作者可以删除自己的评论"
    ON comments FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 完成！
-- ============================================
-- 表结构创建完成
-- 接下来可以：
-- 1. 导入示例数据（使用 CSV 文件）
-- 2. 在 Vue 项目中配置 Supabase 客户端
-- ============================================

