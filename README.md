# 学生管理系统

基于Servlet MVC架构的JavaWeb学生管理系统，支持学生、教师、课程、选课等管理功能。

## 功能特性

### 学生管理
- 学生信息的增删改查
- 学生成绩查询和排名
- 学生状态管理（在读、休学、退学、毕业）

### 教师管理
- 教师信息的增删改查
- 教师职称管理（教授、副教授、讲师、助教）
- 教师状态管理（在职、离职、退休）
- 按姓名搜索教师
- 按职称筛选教师
- 查看在职教师

### 课程管理
- 课程信息的增删改查
- 课程类型管理（通识课、必修课、限选课等）
- 课程成绩统计

### 选课管理
- 学生选课记录管理
- 成绩录入和查询
- 选课统计信息

## 技术栈

- **后端**: Java Servlet + JSP
- **数据库**: PostgreSQL
- **前端**: HTML + CSS + JavaScript
- **架构**: MVC模式

## 数据库设计

系统包含以下主要数据表：
- `huyl_student10` - 学生表
- `huyl_teacher10` - 教师表
- `huyl_course10` - 课程表
- `huyl_enroll10` - 选课表
- `huyl_faculty10` - 学院表
- `huyl_major10` - 专业表
- `huyl_tclass10` - 教学班表
- `huyl_venue10` - 上课时间地点表

## 安装和运行

### 环境要求
- JDK 17+
- Maven 3.6+
- PostgreSQL 12+
- Tomcat 10+

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd demo111
```

2. 配置数据库
- 创建PostgreSQL数据库
- 执行 `code1.sql` 创建表结构
- 执行 `src/main/resources/test_data.sql` 插入测试数据

3. 配置数据库连接
编辑 `src/main/resources/database.properties`：
```properties
db.url=jdbc:postgresql://localhost:5432/your_database
db.username=your_username
db.password=your_password
```

4. 编译和运行
```bash
mvn clean package
mvn tomcat7:run
```

5. 访问系统
打开浏览器访问：`http://localhost:8080/demo111`

## 使用说明

### 教师管理功能

1. **查看教师列表**
   - 访问：`/teacher/list`
   - 功能：显示所有教师信息，支持搜索和筛选

2. **添加教师**
   - 访问：`/teacher/add.jsp`
   - 功能：添加新教师信息

3. **编辑教师**
   - 访问：`/teacher/edit?id=教师编号`
   - 功能：修改教师信息

4. **查看教师详情**
   - 访问：`/teacher/view?id=教师编号`
   - 功能：查看教师详细信息

5. **删除教师**
   - 在教师列表页面点击"删除"按钮
   - 功能：删除教师记录

6. **更新教师状态**
   - 在教师详情页面选择状态并提交
   - 支持：在职、离职、退休

### 搜索和筛选功能

- **按姓名搜索**：在搜索框输入教师姓名
- **按职称筛选**：选择职称下拉菜单
- **查看在职教师**：点击"在职教师"按钮

## 项目结构

```
src/main/
├── java/org/example/demo111/
│   ├── controller/          # 控制器层
│   │   ├── StudentController.java
│   │   ├── TeacherController.java
│   │   └── EnrollmentController.java
│   ├── dao/                # 数据访问层
│   │   ├── StudentDAO.java
│   │   ├── TeacherDAO.java
│   │   └── EnrollmentDAO.java
│   ├── service/            # 业务逻辑层
│   │   ├── StudentService.java
│   │   ├── TeacherService.java
│   │   └── EnrollmentService.java
│   ├── model/              # 实体类
│   │   ├── Student.java
│   │   ├── Teacher.java
│   │   └── Course.java
│   └── util/               # 工具类
│       └── DatabaseUtil.java
├── resources/
│   ├── database.properties # 数据库配置
│   └── test_data.sql       # 测试数据
└── webapp/
    ├── WEB-INF/views/      # JSP页面
    │   ├── student/         # 学生管理页面
    │   ├── teacher/         # 教师管理页面
    │   └── error.jsp        # 错误页面
    ├── index.jsp           # 首页
    └── web.xml             # Web配置
```

## 开发说明

### 添加新功能

1. 创建实体类（Model）
2. 创建DAO类（数据访问）
3. 创建Service类（业务逻辑）
4. 创建Controller类（控制器）
5. 创建JSP页面（视图）

### 数据库操作

使用 `DatabaseUtil` 类获取数据库连接：
```java
Connection conn = DatabaseUtil.getConnection();
```

### 页面开发

- 使用JSTL标签库进行页面逻辑处理
- 使用CSS进行样式设计
- 使用JavaScript进行客户端验证

## 注意事项

1. 确保数据库连接配置正确
2. 教师年龄必须在22-70岁之间
3. 邮箱格式需要包含@符号
4. 删除操作不可恢复，请谨慎操作
5. 教师状态变更会影响相关教学班

## 许可证

本项目仅供学习和演示使用。 