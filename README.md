# 学生管理系统

基于Servlet MVC架构的JavaWeb学生管理系统，支持学生、教师、课程、选课、用户等管理功能，具备自动账户创建和权限分级。

## 功能特性

### 学生管理
- 学生信息的增删改查
- 学生成绩查询和排名
- 学生状态管理（在读、休学、退学、毕业）
- 学生选课以及课表查询

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

### 用户管理与自动账户
- 用户信息管理（管理员、学生、教师）
- 支持用户登录、密码修改、权限分级
- 新增学生/教师时自动创建用户账户（用户名=学号/工号，初始密码可自定义）
- 支持账户状态管理（正常、禁用、在读、在职、休学、退学、离职、退休）
- 支持用户类型统计与查询

## 技术栈

- **后端**: Java Servlet + JSP
- **数据库**: openGaussSQL（兼容PostgreSQL）
- **前端**: HTML + CSS + JavaScript
- **架构**: MVC模式

## 数据库设计

系统包含以下主要数据表：
- `huyl_user10` - 用户表（支持管理员、学生、教师，自动生成账户）
- `huyl_student10` - 学生表
- `huyl_teacher10` - 教师表
- `huyl_course10` - 课程表
- `huyl_enroll10` - 选课表
- `huyl_faculty10` - 学院表
- `huyl_major10` - 专业表
- `huyl_tclass10` - 教学班表
- `huyl_venue10` - 上课时间地点表

### 用户表 huyl_user10 结构（部分字段）：
- user_id INT 主键
- username VARCHAR 用户名（学号/工号/管理员编号）
- password VARCHAR 密码（初始为学号/工号/编号，可登录后修改）
- user_type VARCHAR 用户类型（admin/student/teacher）
- real_name VARCHAR 真实姓名
- email VARCHAR 邮箱
- phone VARCHAR 电话
- status VARCHAR 状态（正常、禁用、在读、在职等）
- created_at/updated_at TIMESTAMP

### 自动账户与触发器说明
- 新增学生/教师时，数据库触发器会自动在`huyl_user10`表中创建对应账户，用户名为学号/工号，初始密码可自定义（如Student@123/Teacher@123）。
- 可通过`user_init.sql`脚本批量初始化用户表。

## 安装和运行

### 环境要求
- JDK 17+
- Maven 3.6+
- openGaussSQL 5.0+（或兼容PostgreSQL）
- Tomcat 10+

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd demo111
```

2. 配置数据库
- 创建openGaussSQL数据库
- 执行 `init.sql` 创建表结构并插入测试数据
- 执行 `user_init.sql` 初始化用户表（如需批量生成用户账户）

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
打开浏览器访问：`http://localhost:8081/demo111`

## 使用说明

### 用户登录与账户管理
- 管理员、学生、教师均可通过用户名（编号/学号/工号）和密码登录
- 新增学生/教师后，系统自动创建账户，初始密码可在页面或数据库脚本中设置
- 用户首次登录后请及时修改密码
- 管理员可在"用户管理"页面重置任意用户密码

### 教师管理功能
1. **查看教师列表**
   - 访问：`/teacher/list`
   - 功能：显示所有教师信息，支持搜索和筛选
2. **添加教师**
   - 访问：`/teacher/add.jsp`
   - 功能：添加新教师信息，自动生成账户
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
│   │   ├── AClassController.java
│   │   ├── AdminCourseScoreController.java
│   │   ├── CourseController.java
│   │   ├── DatabaseTestController.java
│   │   ├── EnrollmentController.java
│   │   ├── GPAController.java
│   │   ├── LoginController.java
│   │   ├── ScoreController.java
│   │   ├── ScoreEntryController.java
│   │   ├── StudentController.java
│   │   ├── TeacherController.java
│   │   ├── UserManagementController.java
│   │   └── ... 其他控制器
│   ├── dao/                # 数据访问层
│   │   ├── AClassDAO.java
│   │   ├── CourseDAO.java
│   │   ├── EnrollmentDAO.java
│   │   ├── FacultyDAO.java
│   │   ├── MajorDAO.java
│   │   ├── StudentDAO.java
│   │   ├── TeacherDAO.java
│   │   ├── TeachingClassDAO.java
│   │   └── UserDAO.java
│   ├── service/            # 业务逻辑层
│   │   ├── AClassService.java
│   │   ├── CourseScoreStatisticsService.java
│   │   ├── CourseService.java
│   │   ├── EnrollmentService.java
│   │   ├── MajorService.java
│   │   ├── StudentService.java
│   │   ├── TeacherService.java
│   │   ├── TeachingClassService.java
│   │   └── UserService.java
│   ├── model/              # 实体类
│   │   ├── AClass.java
│   │   ├── Course.java
│   │   ├── Enrollment.java
│   │   ├── Major.java
│   │   ├── Student.java
│   │   ├── Teacher.java
│   │   ├── TeachingClass.java
│   │   └── User.java
│   ├── filter/             # 过滤器
│   ├── util/               # 工具类
│   │   ├── DatabaseUtil.java
│   │   └── GPAConverter.java
│   └── HelloServlet.java
├── resources/
│   ├── database.properties # 数据库配置
│   ├── init_database.sql   # 数据库初始化脚本
│   ├── user_init.sql      # 用户表初始化脚本
│   ├── quick_fix.sql      # 快速修复脚本
│   └── test_data.sql      # 测试数据
└── webapp/
    ├── WEB-INF/views/      # JSP页面
    │   ├── admin/          # 管理员相关页面
    │   │   ├── aclass/     # 班级管理
    │   │   ├── major/      # 专业管理
    │   │   └── teaching-class/ # 教学班管理
    │   ├── course/         # 课程管理页面
    │   ├── enrollment/     # 选课管理页面
    │   ├── origin/         # 生源地分析页面
    │   ├── score/          # 成绩管理页面
    │   ├── score-entry/    # 成绩录入页面
    │   ├── student/        # 学生管理页面
    │   ├── teacher/        # 教师管理页面
    │   ├── error.jsp       # 错误页面
    │   ├── login.jsp       # 登录页面
    │   ├── test.jsp        # 测试页面
    │   └── sql-result.jsp  # SQL执行结果页面
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
5. 教师/学生状态变更会影响相关教学班和账户状态
6. 新增用户请及时修改初始密码，管理员可重置密码
7. 触发器功能确保用户账户的自动创建，如遇问题请检查数据库触发器配置

## 许可证

本项目仅供学习和演示使用。 