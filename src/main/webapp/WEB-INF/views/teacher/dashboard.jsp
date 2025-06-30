<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>教师仪表板 - 选课管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .header {
            background: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        
        .logo {
            font-size: 1.5em;
            color: #667eea;
            font-weight: bold;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .welcome {
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
        
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .card-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .stat-value {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
        
        .teacher-info {
            display: grid;
            gap: 10px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            font-weight: 600;
            color: #333;
        }
        
        .info-value {
            color: #666;
        }
        
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .action-btn {
            display: block;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .action-btn.secondary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .action-btn.warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        
        .recent-activities {
            margin-top: 20px;
        }
        
        .activity-item {
            padding: 12px;
            border-left: 3px solid #667eea;
            background: #f8f9fa;
            margin-bottom: 10px;
            border-radius: 0 8px 8px 0;
        }
        
        .activity-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .activity-desc {
            color: #666;
            font-size: 0.9em;
        }
        
        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .header-content {
                flex-direction: column;
                gap: 15px;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">🎓 选课管理系统</div>
            <div class="user-info">
                <div class="welcome">欢迎，${teacher.hylTname10} 老师！</div>
                <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn">退出登录</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="dashboard-grid">
            <!-- 教师信息卡片 -->
            <div class="card">
                <h3 class="card-title">👨‍🏫 个人信息</h3>
                <div class="teacher-info">
                    <div class="info-row">
                        <span class="info-label">工号：</span>
                        <span class="info-value">${teacher.hylTno10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">姓名：</span>
                        <span class="info-value">${teacher.hylTname10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">性别：</span>
                        <span class="info-value">${teacher.hylTsex10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">年龄：</span>
                        <span class="info-value">${teacher.hylTage10}岁</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">职称：</span>
                        <span class="info-value">${teacher.hylTtitle10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">邮箱：</span>
                        <span class="info-value">${teacher.hylTemail10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">电话：</span>
                        <span class="info-value">${teacher.hylTphone10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">办公室：</span>
                        <span class="info-value">${teacher.hylToffice10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">状态：</span>
                        <span class="info-value">${teacher.hylTstatus10}</span>
                    </div>
                </div>
                <div class="quick-actions">
                    <a href="${pageContext.request.contextPath}/teacher/my-courses" class="action-btn">📚 我的课程与成绩</a>
                    <a href="${pageContext.request.contextPath}/teacher/profile" class="action-btn secondary">✏️ 修改个人信息</a>
                </div>
            </div>
            
            <!-- 教学统计卡片 -->
            <div class="card">
                <h3 class="card-title">📊 教学统计</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value">${totalTeachingClasses}</div>
                        <div class="stat-label">教学班数量</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${totalStudents}</div>
                        <div class="stat-label">学生总数</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value"><fmt:formatNumber value="${averageScore}" pattern="#.#"/></div>
                        <div class="stat-label">平均成绩</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">95%</div>
                        <div class="stat-label">出勤率</div>
                    </div>
                </div>
                
                <div class="quick-actions">
                    <a href="${pageContext.request.contextPath}/course/list" class="action-btn">所有课程列表</a>
                    <a href="${pageContext.request.contextPath}/course/average-scores" class="action-btn secondary">课程成绩统计</a>
                    <a href="${pageContext.request.contextPath}/teacher/list" class="action-btn warning">教师通讯录</a>
                </div>
            </div>
        </div>
        
        <!-- 最近活动卡片 -->
        <div class="card">
            <h3 class="card-title">📝 最近活动</h3>
            <div class="recent-activities">
                <div class="activity-item">
                    <div class="activity-title">📚 课程安排更新</div>
                    <div class="activity-desc">高等数学A班课程时间已调整为周一上午8:00-10:00</div>
                </div>
                <div class="activity-item">
                    <div class="activity-title">📊 成绩录入完成</div>
                    <div class="activity-desc">线性代数A班期末考试成绩已全部录入系统</div>
                </div>
                <div class="activity-item">
                    <div class="activity-title">👥 学生选课确认</div>
                    <div class="activity-desc">程序设计基础A班新增15名学生选课申请</div>
                </div>
                <div class="activity-item">
                    <div class="activity-title">📅 教学会议提醒</div>
                    <div class="activity-desc">下周三下午2:00将召开本学期教学工作总结会议</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 