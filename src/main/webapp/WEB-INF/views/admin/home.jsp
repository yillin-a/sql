<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>选课管理系统 - 管理员控制台</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #9BDCFC; /* Base Blue Color */
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #9BDCFC;
        }
        .header h1 {
            color: #3a8fa8;
            margin: 0;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .welcome-text {
            color: #333;
            font-weight: 600;
        }
        .logout-btn {
            background: #dc3545;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        .logout-btn:hover {
            background: #c82333;
        }
        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .nav-card {
            background: linear-gradient(135deg, #9BDCFC 0%, #75C3D8 100%); /* Gradient Blue */
            color: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .nav-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        .nav-card h3 {
            margin: 0 0 15px 0;
            font-size: 1.5em;
        }
        .nav-card p {
            margin: 0;
            opacity: 0.9;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #007bff; /* Bright Blue for emphasis */
        }
        .stat-card h4 {
            margin: 0 0 10px 0;
            color: #333;
        }
        .stat-card .number {
            font-size: 2em;
            font-weight: bold;
            color: #007bff;
        }
        .welcome {
            text-align: center;
            margin-bottom: 30px;
            color: #666;
        }
        .admin-links {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
        .admin-links a {
            color: #007bff;
            text-decoration: none;
            margin: 0 10px;
        }
        .admin-links a:hover {
            text-decoration: underline;
        }
        .user-type-badge {
            background: #28a745;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🎓 选课管理系统</h1>
        <div class="user-info">
            <div class="welcome-text">
                欢迎，${currentUser.realName} 
                <span class="user-type-badge">管理员</span>
            </div>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn">退出登录</a>
        </div>
    </div>

    <div class="welcome">
        <p>欢迎使用选课管理系统管理员控制台，请选择您要管理的功能模块</p>
    </div>

    <div class="stats">
        <div class="stat-card">
            <h4>学生总数</h4>
            <div class="number">${studentCount}</div>
        </div>
        <div class="stat-card">
            <h4>生源地数量</h4>
            <div class="number">${originCount}</div>
        </div>
        <div class="stat-card">
            <h4>课程总数</h4>
            <div class="number">${courseCount}</div>
        </div>
        <div class="stat-card">
            <h4>选课记录</h4>
            <div class="number">${enrollmentCount}</div>
        </div>
        <div class="stat-card">
            <h4>教师总数</h4>
            <div class="number">${teacherCount}</div>
        </div>
        <div class="stat-card">
            <h4>学院总数</h4>
            <div class="number">${facultyCount}</div>
        </div>
    </div>

    <div class="nav-grid">
        <a href="${pageContext.request.contextPath}/student/list" class="nav-card">
            <h3>👥 学生管理</h3>
            <p>管理学生信息，包括添加、编辑、删除学生记录</p>
        </a>

        <a href="${pageContext.request.contextPath}/student/scores" class="nav-card">
            <h3>📊 成绩管理</h3>
            <p>查看学生成绩排名，管理选课和成绩信息</p>
        </a>

        <a href="${pageContext.request.contextPath}/origin/stats" class="nav-card">
            <h3>🌍 生源地统计</h3>
            <p>分析学生生源地分布，了解招生来源情况</p>
        </a>

        <a href="${pageContext.request.contextPath}/enrollment/list" class="nav-card">
            <h3>📚 选课管理</h3>
            <p>管理学生选课记录，查看选课统计信息</p>
        </a>

        <a href="${pageContext.request.contextPath}/score/stats" class="nav-card">
            <h3>📈 成绩统计</h3>
            <p>查看成绩统计分析，了解教学质量</p>
        </a>

        <a href="${pageContext.request.contextPath}/course/list" class="nav-card">
            <h3>📖 课程管理</h3>
            <p>管理课程信息，设置课程安排</p>
        </a>

        <a href="${pageContext.request.contextPath}/teacher/list" class="nav-card">
            <h3>👨‍🏫 教师管理</h3>
            <p>管理教师信息，查看教师任课安排</p>
        </a>
        
        <a href="${pageContext.request.contextPath}/enrollment/course-average" class="nav-card">
            <h3>📊 课程平均成绩</h3>
            <p>查看各课程平均成绩统计和分析</p>
        </a>
        
        <a href="${pageContext.request.contextPath}/course/average-scores" class="nav-card">
            <h3>📈 课程成绩统计</h3>
            <p>管理员课程平均成绩详细统计</p>
        </a>
        
        <a href="${pageContext.request.contextPath}/course/teacher-stats" class="nav-card">
            <h3>👨‍🏫 教师课程统计</h3>
            <p>按教师统计课程成绩表现</p>
        </a>
        
        <a href="${pageContext.request.contextPath}/admin/course-score/dashboard" class="nav-card">
            <h3>📊 课程成绩仪表板</h3>
            <p>课程成绩综合分析和统计</p>
        </a>
        
        <a href="${pageContext.request.contextPath}/test/course-score" class="nav-card">
            <h3>🧪 功能测试</h3>
            <p>测试课程平均成绩功能模块</p>
        </a>
    </div>

    <div class="admin-links">
        <a href="${pageContext.request.contextPath}/test/database">🔧 数据库连接测试</a>
        <a href="${pageContext.request.contextPath}/student/list">📋 学生列表</a>
        <a href="${pageContext.request.contextPath}/teacher/list">👨‍🏫 教师列表</a>
        <a href="${pageContext.request.contextPath}/course/list">📚 课程列表</a>
    </div>

    <div style="text-align: center; margin-top: 40px; color: #666;">
        <p>© 2025 选课管理系统 - 基于Servlet MVC架构开发</p>
    </div>
</div>

<script>
    // You can add JavaScript for any interactive behavior
    console.log("管理员控制台加载成功！");

    // Example: If you want to dynamically change background color on hover
    const navCards = document.querySelectorAll('.nav-card');
    navCards.forEach(card => {
        card.addEventListener('mouseover', () => {
            card.style.background = 'linear-gradient(135deg, #75C3D8 0%, #9BDCFC 100%)';
        });
        card.addEventListener('mouseout', () => {
            card.style.background = 'linear-gradient(135deg, #9BDCFC 0%, #75C3D8 100%)';
        });
    });
</script>
</body>
</html>
