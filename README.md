# EatRightNow iOS App

一个基于SwiftUI的iOS应用，根据用户当前状态推荐最适合的食物。

## 功能特性

- **智能状态检测**: 支持6种用户状态（平静、压力、低能量、运动后、睡前准备、需要专注）
- **个性化推荐**: 基于当前状态推荐Top 3最适合的食物
- **营养信息**: 显示详细的营养成分和份量信息
- **饮食限制**: 支持素食、清真等饮食标志和过敏信息
- **设置管理**: 支持饮食偏好、过敏原和食品储藏室设置
- **智能过滤**: 根据用户设置过滤推荐食物，优先显示储藏室中的物品
- **现代UI**: 采用SwiftUI构建，支持深色模式和动态字体
- **无障碍支持**: 完整的VoiceOver和动态字体支持

## 技术架构

- **框架**: SwiftUI (iOS 17+)
- **架构模式**: MVVM
- **语言**: Swift 5.9+
- **设计系统**: 自定义组件库

## 项目结构

```
APP/
├── EatRightNowApp.swift          # 应用入口
├── DesignSystem/                 # 设计系统
│   ├── Colors.swift             # 颜色定义
│   ├── Typography.swift         # 字体样式
│   ├── ERNCard.swift            # 卡片组件
│   ├── ERNButtonStyle.swift     # 按钮样式
│   └── Icon.swift               # 图标定义
├── Models/                      # 数据模型
│   ├── UserState.swift          # 用户状态枚举
│   ├── Nutrition.swift          # 营养信息
│   ├── Food.swift               # 食物模型
│   ├── Recommendation.swift     # 推荐模型
│   ├── DietaryPreference.swift  # 饮食偏好枚举
│   ├── Allergy.swift            # 过敏原枚举
│   └── PantryItem.swift         # 储藏室物品模型
├── Services/                    # 服务层
│   ├── MockRecommendationService.swift  # 模拟推荐服务
│   └── SettingsStore.swift      # 设置存储服务
├── ViewModels/                  # 视图模型
│   ├── HomeViewModel.swift      # 主页视图模型
│   └── SettingsViewModel.swift  # 设置视图模型
└── Views/                       # 视图组件
    ├── HomeView.swift           # 主页面
    ├── SmartStateCard.swift     # 智能状态卡片
    ├── FoodTile.swift           # 食物瓦片
    ├── TopThreeSheet.swift      # Top 3食物弹窗
    ├── SettingsView.swift       # 设置页面
    └── RootView.swift           # 根视图（TabView）
```

## 核心功能

### 1. 智能状态卡片
- 显示当前用户状态（图标+标签）
- 显示状态理由（1-2行说明）
- 主要行动按钮："Show foods for now"
- 次要按钮："Why this?" 和 "Snooze"

### 2. Top 3食物推荐
- 基于当前状态推荐最适合的3种食物
- 每种食物显示：
  - 表情符号和名称
  - 推荐理由
  - 营养成分（卡路里、碳水、蛋白质、脂肪、关键微量营养素）
  - 份量信息
  - 饮食标志和过敏信息
  - "Eat this" 按钮

### 3. 设置管理
- **饮食偏好**: 多选标签（纯素、素食、清真、犹太洁食、无乳制品、无麸质、无坚果）
- **过敏原**: 多选标签（乳制品、坚果、麸质、鸡蛋、大豆、贝类）
- **储藏室**: 常见物品开关（香蕉、黑巧克力、酸奶、燕麦、苹果、希腊酸奶、鸡蛋、坚果）
- **智能过滤**: 根据设置过滤推荐，优先显示储藏室中的物品

### 4. 辅助功能
- **Why this?**: 解释推荐的科学依据
- **Snooze**: 暂停推荐（30分钟/1小时/2小时）
- **状态切换**: 测试不同状态的推荐

## 设计系统

### 颜色
- 背景色：系统背景色
- 卡片背景：次要系统背景色
- 文本：主要、次要、第三级文本色
- 强调色：蓝色
- 状态色：每种状态有独特的颜色

### 字体
- 标题：圆角字体，粗体
- 正文：系统字体，常规
- 说明：系统字体，细体

### 组件
- **ERNCard**: 圆角卡片，带阴影
- **ERNButtonStyle**: 三种按钮样式（主要、次要、第三级）
- **ERNIconView**: 统一的图标组件
- **TagChip**: 可选择的标签芯片组件

## 使用方法

1. 启动应用后，主页显示当前状态（默认为"压力"状态）
2. 点击"Show foods for now"查看推荐食物
3. 在弹窗中查看Top 3推荐食物
4. 点击"Eat this"选择食物（当前为占位功能）
5. 使用"切换状态"按钮测试不同状态的推荐
6. 在Settings标签中设置饮食偏好、过敏原和储藏室物品
7. 设置会自动过滤推荐食物，优先显示储藏室中的物品

## 未来扩展

- HealthKit集成，实时读取用户健康数据
- Apple Watch支持
- 用户偏好设置
- 食物替代选项
- 营养追踪
- 社交分享功能

## 开发环境

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## 构建和运行

1. 在Xcode中打开项目
2. 选择目标设备或模拟器
3. 按Cmd+R运行应用

## 预览

应用包含完整的SwiftUI预览，可以在Xcode中查看所有组件的预览效果。
