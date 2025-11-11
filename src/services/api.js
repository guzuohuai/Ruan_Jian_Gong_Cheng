import { supabase, TABLES } from '../lib/supabase'

/**
 * 分类 API
 */
export const categoryApi = {
  // 获取所有分类
  async getAll() {
    const { data, error } = await supabase
      .from(TABLES.CATEGORIES)
      .select('*')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    return data
  },

  // 根据 slug 获取分类
  async getBySlug(slug) {
    const { data, error } = await supabase
      .from(TABLES.CATEGORIES)
      .select('*')
      .eq('slug', slug)
      .single()
    
    if (error) throw error
    return data
  },

  // 根据 ID 获取分类
  async getById(id) {
    const { data, error } = await supabase
      .from(TABLES.CATEGORIES)
      .select('*')
      .eq('id', id)
      .single()
    
    if (error) throw error
    return data
  },
}

/**
 * 文章 API
 */
export const postApi = {
  // 获取所有已发布的文章
  async getAll(published = true, options = {}) {
    let query = supabase
      .from(TABLES.POSTS)
      .select(`
        *,
        category:categories(*)
      `)
      .order('created_at', { ascending: false })
    
    if (published) {
      query = query.eq('published', true)
    }
    
    // 搜索功能
    if (options.search) {
      query = query.or(`title.ilike.%${options.search}%,content.ilike.%${options.search}%,excerpt.ilike.%${options.search}%`)
    }
    
    // 分页功能
    if (options.page && options.pageSize) {
      const from = (options.page - 1) * options.pageSize
      const to = from + options.pageSize - 1
      query = query.range(from, to)
    }
    
    const { data, error } = await query
    
    if (error) throw error
    return data
  },

  // 获取文章总数（用于分页）
  async getCount(published = true, search = '') {
    let query = supabase
      .from(TABLES.POSTS)
      .select('*', { count: 'exact', head: true })
    
    if (published) {
      query = query.eq('published', true)
    }
    
    if (search) {
      query = query.or(`title.ilike.%${search}%,content.ilike.%${search}%,excerpt.ilike.%${search}%`)
    }
    
    const { count, error } = await query
    
    if (error) throw error
    return count || 0
  },

  // 根据 slug 获取文章
  async getBySlug(slug) {
    const { data, error } = await supabase
      .from(TABLES.POSTS)
      .select(`
        *,
        category:categories(*)
      `)
      .eq('slug', slug)
      .eq('published', true)
      .single()
    
    if (error) throw error
    return data
  },

  // 根据 ID 获取文章
  async getById(id) {
    const { data, error } = await supabase
      .from(TABLES.POSTS)
      .select(`
        *,
        category:categories(*)
      `)
      .eq('id', id)
      .single()
    
    if (error) throw error
    return data
  },

  // 根据分类获取文章
  async getByCategory(categoryId, published = true) {
    let query = supabase
      .from(TABLES.POSTS)
      .select(`
        *,
        category:categories(*)
      `)
      .eq('category_id', categoryId)
      .order('created_at', { ascending: false })
    
    if (published) {
      query = query.eq('published', true)
    }
    
    const { data, error } = await query
    
    if (error) throw error
    return data
  },

  // 增加文章浏览次数
  async incrementViews(id) {
    // 先获取当前浏览次数
    const { data: posts, error: fetchError } = await supabase
      .from(TABLES.POSTS)
      .select('views_count')
      .eq('id', id)
      .limit(1)
    
    if (fetchError) throw fetchError
    if (!posts || posts.length === 0) {
      throw new Error('文章不存在')
    }
    
    // 更新浏览次数
    const currentViews = posts[0].views_count || 0
    const newViewsCount = currentViews + 1
    
    const { data, error: updateError } = await supabase
      .from(TABLES.POSTS)
      .update({ views_count: newViewsCount })
      .eq('id', id)
      .select('views_count')
    
    if (updateError) throw updateError
    if (!data || data.length === 0) {
      return { views_count: newViewsCount }
    }
    return data[0]
  },

  // 创建文章（需要认证）
  async create(postData) {
    const { data: { user } } = await supabase.auth.getUser()
    
    if (!user) {
      throw new Error('需要登录才能创建文章')
    }

    const { data, error } = await supabase
      .from(TABLES.POSTS)
      .insert({
        ...postData,
        author_id: user.id,
      })
      .select()
      .single()
    
    if (error) throw error
    return data
  },

  // 更新文章（需要认证）
  async update(id, postData) {
    const { data, error } = await supabase
      .from(TABLES.POSTS)
      .update(postData)
      .eq('id', id)
      .select()
      .single()
    
    if (error) throw error
    return data
  },

  // 删除文章（需要认证）
  async delete(id) {
    const { error } = await supabase
      .from(TABLES.POSTS)
      .delete()
      .eq('id', id)
    
    if (error) throw error
  },
}

/**
 * 评论 API
 */
export const commentApi = {
  // 获取文章的所有已审核评论
  async getByPost(postId, approved = true) {
    let query = supabase
      .from(TABLES.COMMENTS)
      .select('*')
      .eq('post_id', postId)
      .order('created_at', { ascending: true })
    
    if (approved) {
      query = query.eq('approved', true)
    }
    
    const { data, error } = await query
    
    if (error) throw error
    return data
  },

  // 创建评论
  async create(commentData) {
    const { data, error } = await supabase
      .from(TABLES.COMMENTS)
      .insert(commentData)
      .select()
      .single()
    
    if (error) throw error
    return data
  },

  // 更新评论（需要认证）
  async update(id, commentData) {
    const { data, error } = await supabase
      .from(TABLES.COMMENTS)
      .update(commentData)
      .eq('id', id)
      .select()
      .single()
    
    if (error) throw error
    return data
  },

  // 删除评论（需要认证）
  async delete(id) {
    const { error } = await supabase
      .from(TABLES.COMMENTS)
      .delete()
      .eq('id', id)
    
    if (error) throw error
  },
}

/**
 * 认证 API
 */
export const authApi = {
  // 注册
  async signUp(email, password, userData = {}) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userData,
      },
    })
    
    if (error) throw error
    return data
  },

  // 登录
  async signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })
    
    if (error) throw error
    return data
  },

  // 登出
  async signOut() {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
  },

  // 获取当前用户
  async getCurrentUser() {
    const { data: { user } } = await supabase.auth.getUser()
    return user
  },

  // 监听认证状态变化
  onAuthStateChange(callback) {
    return supabase.auth.onAuthStateChange(callback)
  },
}

