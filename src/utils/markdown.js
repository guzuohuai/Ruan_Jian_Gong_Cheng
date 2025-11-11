import { marked } from 'marked'

// 配置 marked（marked 17.0.0 使用新的配置方式）
const markedOptions = {
  breaks: true, // 支持 GitHub 风格的换行
  gfm: true, // 启用 GitHub 风格的 Markdown
  headerIds: true, // 为标题添加 ID
  mangle: false, // 不混淆邮箱地址
}

// 使用 marked.use() 配置（marked 4.0+）
marked.use(markedOptions)

// 同时使用 setOptions 确保兼容性（marked 3.x）
if (typeof marked.setOptions === 'function') {
  marked.setOptions(markedOptions)
}

// 检查 marked 是否正确导入（仅在开发环境）
if (import.meta.env.DEV) {
  if (typeof marked === 'undefined' || typeof marked.parse !== 'function') {
    console.error('marked 库未正确导入！')
  }
}

/**
 * 将 Markdown 文本转换为 HTML
 * @param {string} markdown - Markdown 文本
 * @returns {string} HTML 字符串
 */
export function markdownToHtml(markdown) {
  if (!markdown) return ''
  
  try {
    // 检查 marked 是否可用
    if (typeof marked === 'undefined' || typeof marked.parse !== 'function') {
      console.error('marked.parse 不可用，使用回退方案')
      return fallbackMarkdownToHtml(markdown)
    }
    
    // marked.parse() 在 marked 17.0.0 中是同步的
    let html = marked.parse(markdown)
    
    // 检查返回值
    if (typeof html !== 'string') {
      console.error('marked.parse() 返回的不是字符串:', typeof html)
      return fallbackMarkdownToHtml(markdown)
    }
    
    // 检查是否成功转换（如果还包含 ## 这样的 Markdown 语法，说明没有完全转换）
    if (html.includes('##') || html.includes('###') || (html === markdown && markdown.includes('#'))) {
      // marked.parse() 未完全工作，使用回退方案
      return fallbackMarkdownToHtml(markdown)
    }
    
    // 处理换行符：marked 可能没有完全处理所有换行
    // 先移除标签之间的换行和空白（这些是格式化用的，不影响显示）
    html = html.replace(/>\s*\n\s*</g, '><')
    
    // 将文本内容中的换行符转换为 <br>
    // 匹配：不在 HTML 标签内的换行符（前后不是 > 和 <）
    html = html.replace(/([^>])\n([^<])/g, '$1<br>$2')
    
    // 处理剩余的换行（在行首或行尾的）
    html = html.replace(/^\n/g, '')
    html = html.replace(/\n$/g, '')
    html = html.replace(/\n/g, ' ')
    
    return html
  } catch (error) {
    console.error('Markdown 解析错误:', error)
    // 解析失败时使用回退方案
    return fallbackMarkdownToHtml(markdown)
  }
}

/**
 * 回退方案：使用正则表达式进行基本的 Markdown 转换
 */
function fallbackMarkdownToHtml(markdown) {
  if (!markdown) return ''
  
  // 先处理转义的换行符（如果内容是字符串形式的 \n）
  // 将字符串 "\n" 转换为真正的换行符
  let processedMarkdown = markdown
    .replace(/\\n/g, '\n')  // 处理转义的换行符
    .replace(/\\r\\n/g, '\n')  // 处理 Windows 换行符
    .replace(/\\r/g, '\n')  // 处理 Mac 换行符
  
  // 按行处理，逐行转换
  const lines = processedMarkdown.split('\n')
  const result = []
  let inList = false
  let listItems = []
  
  for (let i = 0; i < lines.length; i++) {
    let line = lines[i]
    const trimmed = line.trim()
    
    // 空行
    if (!trimmed) {
      // 如果有未完成的列表，先输出
      if (inList && listItems.length > 0) {
        result.push(`<ul>${listItems.join('')}</ul>`)
        listItems = []
        inList = false
      }
      continue
    }
    
    // 代码块（简单处理，实际应该更复杂）
    if (trimmed.startsWith('```')) {
      result.push(`<pre><code>${line.replace(/```/g, '')}</code></pre>`)
      continue
    }
    
    // 标题
    if (trimmed.startsWith('#### ')) {
      if (inList) {
        result.push(`<ul>${listItems.join('')}</ul>`)
        listItems = []
        inList = false
      }
      result.push(`<h4>${trimmed.substring(5)}</h4>`)
      continue
    }
    if (trimmed.startsWith('### ')) {
      if (inList) {
        result.push(`<ul>${listItems.join('')}</ul>`)
        listItems = []
        inList = false
      }
      result.push(`<h3>${trimmed.substring(4)}</h3>`)
      continue
    }
    if (trimmed.startsWith('## ')) {
      if (inList) {
        result.push(`<ul>${listItems.join('')}</ul>`)
        listItems = []
        inList = false
      }
      const title = trimmed.substring(3).trim()
      result.push(`<h2>${title}</h2>`)
      continue
    }
    if (trimmed.startsWith('# ')) {
      if (inList) {
        result.push(`<ul>${listItems.join('')}</ul>`)
        listItems = []
        inList = false
      }
      result.push(`<h1>${trimmed.substring(2)}</h1>`)
      continue
    }
    
    // 列表项
    const listMatch = trimmed.match(/^[-*]\s+(.+)$/)
    const orderedMatch = trimmed.match(/^\d+\.\s+(.+)$/)
    
    if (listMatch || orderedMatch) {
      const content = listMatch ? listMatch[1] : orderedMatch[1]
      // 处理粗体和斜体
      let processedContent = content
        .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
        .replace(/\*(.+?)\*/g, '<em>$1</em>')
        .replace(/`([^`]+)`/g, '<code>$1</code>')
      
      listItems.push(`<li>${processedContent}</li>`)
      inList = true
      continue
    }
    
    // 如果不是列表项，结束当前列表
    if (inList && listItems.length > 0) {
      result.push(`<ul>${listItems.join('')}</ul>`)
      listItems = []
      inList = false
    }
    
    // 普通文本段落
    let processedLine = trimmed
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.+?)\*/g, '<em>$1</em>')
      .replace(/`([^`]+)`/g, '<code>$1</code>')
    
    result.push(`<p>${processedLine}</p>`)
  }
  
  // 处理剩余的列表
  if (inList && listItems.length > 0) {
    result.push(`<ul>${listItems.join('')}</ul>`)
  }
  
  return result.join('\n')
}

/**
 * 获取 Markdown 文本的纯文本摘要（用于搜索等）
 * @param {string} markdown - Markdown 文本
 * @param {number} length - 摘要长度
 * @returns {string} 纯文本摘要
 */
export function markdownToText(markdown, length = 200) {
  if (!markdown) return ''
  
  // 移除 Markdown 语法
  let text = markdown
    .replace(/^#+\s+/gm, '') // 移除标题标记
    .replace(/\*\*(.*?)\*\*/g, '$1') // 移除粗体
    .replace(/\*(.*?)\*/g, '$1') // 移除斜体
    .replace(/`(.*?)`/g, '$1') // 移除行内代码
    .replace(/```[\s\S]*?```/g, '') // 移除代码块
    .replace(/\[([^\]]+)\]\([^\)]+\)/g, '$1') // 移除链接，保留文本
    .replace(/\n+/g, ' ') // 替换换行为空格
    .trim()
  
  // 截取指定长度
  if (text.length > length) {
    text = text.substring(0, length) + '...'
  }
  
  return text
}

