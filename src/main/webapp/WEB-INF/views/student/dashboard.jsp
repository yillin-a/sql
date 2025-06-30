<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学生仪表板 - 选课管理系统</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
            margin-bottom: 20px;
        }
        
        .card-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
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
        
        .student-info {
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
        
        .enrollment-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .enrollment-table th,
        .enrollment-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .enrollment-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .enrollment-table tr:hover {
            background: #f8f9fa;
        }
        
        .score {
            font-weight: 600;
        }
        
        .score-excellent {
            color: #28a745;
        }
        
        .score-good {
            color: #17a2b8;
        }
        
        .score-average {
            color: #ffc107;
        }
        
        .score-poor {
            color: #dc3545;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8em;
            font-weight: 600;
        }
        
        .status-normal {
            background: #d4edda;
            color: #155724;
        }
        
        .status-retake {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-withdraw {
            background: #f8d7da;
            color: #721c24;
        }
        
        .no-data {
            text-align: center;
            color: #666;
            padding: 40px;
            font-style: italic;
        }
        
        .schedule-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
            margin-top: 15px;
        }
        
        .schedule-day {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 10px;
            min-height: 120px;
        }
        
        .schedule-day-title {
            font-weight: 600;
            color: #333;
            text-align: center;
            margin-bottom: 10px;
            font-size: 0.9em;
        }
        
        .schedule-course {
            background: white;
            border-radius: 6px;
            padding: 8px;
            margin-bottom: 8px;
            font-size: 0.8em;
            border-left: 3px solid #667eea;
        }
        
        .schedule-course-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }
        
        .schedule-course-info {
            color: #666;
            font-size: 0.75em;
        }
        
        .progress-bar {
            width: 100%;
            height: 20px;
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 10px;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transition: width 0.3s ease;
        }
        
        .ranking-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        
        .ranking-number {
            font-size: 3em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .ranking-text {
            font-size: 1.1em;
            margin-bottom: 5px;
        }
        
        .ranking-percentage {
            font-size: 0.9em;
            opacity: 0.9;
        }
        
        .score-distribution {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
            margin-top: 15px;
        }
        
        .distribution-item {
            text-align: center;
            padding: 15px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
        }
        
        .distribution-excellent {
            background: #28a745;
        }
        
        .distribution-good {
            background: #17a2b8;
        }
        
        .distribution-average {
            background: #ffc107;
            color: #333;
        }
        
        .distribution-pass {
            background: #fd7e14;
        }
        
        .distribution-fail {
            background: #dc3545;
        }
        
        .gpa-chart {
            margin-top: 15px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .gpa-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .gpa-item:last-child {
            border-bottom: none;
        }
        
        .gpa-term {
            font-weight: 600;
            color: #333;
        }
        
        .gpa-value {
            font-size: 1.2em;
            font-weight: bold;
            color: #667eea;
        }
        
        .nav-menu {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 10px;
            margin-top: 20px;
        }
        
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .nav-item {
            color: #666;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .nav-item:hover {
            background-color: #e9ecef;
        }
        
        .nav-item.active {
            background-color: #667eea;
            color: white;
        }
        
        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .schedule-grid {
                grid-template-columns: 1fr;
            }
            
            .score-distribution {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .header-content {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">🎓 选课管理系统</div>
            <div class="user-info">
                <div class="welcome">欢迎，${student.hylSname10} 同学！</div>
                <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn">退出登录</a>
            </div>
        </div>
        <!-- 导航菜单 -->
        <div class="nav-menu">
            <div class="nav-container">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-item active">
                    <i class="fas fa-home"></i> 首页
                </a>
                <a href="${pageContext.request.contextPath}/student/select-course" class="nav-item">
                    <i class="fas fa-plus-circle"></i> 选课
                </a>
                <a href="${pageContext.request.contextPath}/student-score-analysis/" class="nav-item">
                    <i class="fas fa-user-edit"></i> 个人信息修改
                </a>
                <a href="${pageContext.request.contextPath}/password/change" class="nav-item">
                    <i class="fas fa-key"></i> 修改密码
                </a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="dashboard-grid">
            <!-- 学生信息卡片 -->
            <div class="card">
                <h3 class="card-title">👤 个人信息</h3>
                <div class="student-info">
                    <div class="info-row">
                        <span class="info-label">学号：</span>
                        <span class="info-value">${student.hylSno10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">姓名：</span>
                        <span class="info-value">${student.hylSname10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">性别：</span>
                        <span class="info-value">${student.hylSsex10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">年龄：</span>
                        <span class="info-value">${student.hylSage10}岁</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">籍贯：</span>
                        <span class="info-value">${student.hylSplace10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">邮箱：</span>
                        <span class="info-value">${student.hylSemail10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">电话：</span>
                        <span class="info-value">${student.hylSphone10}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">状态：</span>
                        <span class="info-value">${student.hylSstatus10}</span>
                    </div>
                </div>
            </div>
            
            <!-- 统计信息卡片 -->
            <div class="card">
                <h3 class="card-title">📊 学习统计</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value">${totalCourses}</div>
                        <div class="stat-label">总选课程</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${completedCourses}</div>
                        <div class="stat-label">已完成课程</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value"><fmt:formatNumber value="${averageGPA}" pattern="#.##"/></div>
                        <div class="stat-label">平均GPA</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value"><fmt:formatNumber value="${totalCredits}" pattern="#.#"/></div>
                        <div class="stat-label">总学分</div>
                    </div>
                </div>
                
                <!-- 学习进度 -->
                <div style="margin-top: 20px;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span style="font-weight: 600; color: #333;">学习进度</span>
                        <span style="color: #666;"><fmt:formatNumber value="${progressPercentage}" pattern="#.#"/>%</span>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: ${progressPercentage}%"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 专业排名信息 -->
        <c:if test="${not empty rankingInfo}">
            <div class="card">
                <h3 class="card-title">🏆 专业排名</h3>
                <div class="ranking-info">
                    <div class="ranking-number">${rankingInfo.rank}</div>
                    <div class="ranking-text">${rankingInfo.majorName} 专业排名</div>
                    <div class="ranking-percentage">专业总人数：${rankingInfo.totalStudents}人 | 排名百分比：${rankingInfo.rankPercentage}%</div>
                </div>
            </div>
        </c:if>
        
        <!-- 成绩分布统计 -->
        <div class="card">
            <h3 class="card-title">📈 成绩分布</h3>
            <div class="score-distribution">
                <div class="distribution-item distribution-excellent">
                    <div style="font-size: 1.5em; margin-bottom: 5px;">${excellentCount}</div>
                    <div style="font-size: 0.8em;">优秀(90+)</div>
                </div>
                <div class="distribution-item distribution-good">
                    <div style="font-size: 1.5em; margin-bottom: 5px;">${goodCount}</div>
                    <div style="font-size: 0.8em;">良好(80-89)</div>
                </div>
                <div class="distribution-item distribution-average">
                    <div style="font-size: 1.5em; margin-bottom: 5px;">${averageCount}</div>
                    <div style="font-size: 0.8em;">中等(70-79)</div>
                </div>
                <div class="distribution-item distribution-pass">
                    <div style="font-size: 1.5em; margin-bottom: 5px;">${passCount}</div>
                    <div style="font-size: 0.8em;">及格(60-69)</div>
                </div>
                <div class="distribution-item distribution-fail">
                    <div style="font-size: 1.5em; margin-bottom: 5px;">${failCount}</div>
                    <div style="font-size: 0.8em;">不及格(&lt;60)</div>
                </div>
            </div>
        </div>
        
        <!-- GPA历史趋势 -->
        <c:if test="${not empty gpaHistory}">
            <div class="card">
                <h3 class="card-title">📊 GPA历史趋势</h3>
                <div class="gpa-chart">
                    <c:forEach var="term" items="${gpaHistory}">
                        <div class="gpa-item">
                            <div class="gpa-term">${term.year}年第${term.term}学期 (${term.courseCount}门课程)</div>
                            <div class="gpa-value"><fmt:formatNumber value="${term.avgGPA}" pattern="#.##"/></div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        
        <!-- 当前学期课表 -->
        <c:if test="${not empty currentSchedule}">
            <div class="card">
                <h3 class="card-title">📅 当前学期课表</h3>
                <div class="schedule-grid">
                    <div class="schedule-day">
                        <div class="schedule-day-title">周一</div>
                        <c:forEach var="course" items="${currentSchedule}">
                            <c:if test="${course.weekday == 1}">
                                <div class="schedule-course">
                                    <div class="schedule-course-name">${course.courseName}</div>
                                    <div class="schedule-course-info">${course.teacherName}</div>
                                    <div class="schedule-course-info">${course.classroom}</div>
                                    <div class="schedule-course-info">
                                        <fmt:formatDate value="${course.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${course.endTime}" pattern="HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="schedule-day">
                        <div class="schedule-day-title">周二</div>
                        <c:forEach var="course" items="${currentSchedule}">
                            <c:if test="${course.weekday == 2}">
                                <div class="schedule-course">
                                    <div class="schedule-course-name">${course.courseName}</div>
                                    <div class="schedule-course-info">${course.teacherName}</div>
                                    <div class="schedule-course-info">${course.classroom}</div>
                                    <div class="schedule-course-info">
                                        <fmt:formatDate value="${course.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${course.endTime}" pattern="HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="schedule-day">
                        <div class="schedule-day-title">周三</div>
                        <c:forEach var="course" items="${currentSchedule}">
                            <c:if test="${course.weekday == 3}">
                                <div class="schedule-course">
                                    <div class="schedule-course-name">${course.courseName}</div>
                                    <div class="schedule-course-info">${course.teacherName}</div>
                                    <div class="schedule-course-info">${course.classroom}</div>
                                    <div class="schedule-course-info">
                                        <fmt:formatDate value="${course.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${course.endTime}" pattern="HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="schedule-day">
                        <div class="schedule-day-title">周四</div>
                        <c:forEach var="course" items="${currentSchedule}">
                            <c:if test="${course.weekday == 4}">
                                <div class="schedule-course">
                                    <div class="schedule-course-name">${course.courseName}</div>
                                    <div class="schedule-course-info">${course.teacherName}</div>
                                    <div class="schedule-course-info">${course.classroom}</div>
                                    <div class="schedule-course-info">
                                        <fmt:formatDate value="${course.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${course.endTime}" pattern="HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="schedule-day">
                        <div class="schedule-day-title">周五</div>
                        <c:forEach var="course" items="${currentSchedule}">
                            <c:if test="${course.weekday == 5}">
                                <div class="schedule-course">
                                    <div class="schedule-course-name">${course.courseName}</div>
                                    <div class="schedule-course-info">${course.teacherName}</div>
                                    <div class="schedule-course-info">${course.classroom}</div>
                                    <div class="schedule-course-info">
                                        <fmt:formatDate value="${course.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${course.endTime}" pattern="HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="schedule-day">
                        <div class="schedule-day-title">周六</div>
                        <c:forEach var="course" items="${currentSchedule}">
                            <c:if test="${course.weekday == 6}">
                                <div class="schedule-course">
                                    <div class="schedule-course-name">${course.courseName}</div>
                                    <div class="schedule-course-info">${course.teacherName}</div>
                                    <div class="schedule-course-info">${course.classroom}</div>
                                    <div class="schedule-course-info">
                                        <fmt:formatDate value="${course.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${course.endTime}" pattern="HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="schedule-day">
                        <div class="schedule-day-title">周日</div>
                        <c:forEach var="course" items="${currentSchedule}">
                            <c:if test="${course.weekday == 7}">
                                <div class="schedule-course">
                                    <div class="schedule-course-name">${course.courseName}</div>
                                    <div class="schedule-course-info">${course.teacherName}</div>
                                    <div class="schedule-course-info">${course.classroom}</div>
                                    <div class="schedule-course-info">
                                        <fmt:formatDate value="${course.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${course.endTime}" pattern="HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- 选课记录卡片 -->
        <div class="card">
            <h3 class="card-title">📚 选课记录</h3>
            <c:choose>
                <c:when test="${not empty enrollments}">
                    <table class="enrollment-table">
                        <thead>
                            <tr>
                                <th>课程名称</th>
                                <th>教学班</th>
                                <th>成绩</th>
                                <th>GPA</th>
                                <th>获得学分</th>
                                <th>状态</th>
                                <th>选课时间</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enrollment" items="${enrollments}">
                                <tr>
                                    <td>${enrollment.courseName}</td>
                                    <td>教学班${enrollment.hylTcno10}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${enrollment.hylEscore10 != null}">
                                                <span class="score 
                                                    <c:choose>
                                                        <c:when test="${enrollment.hylEscore10 >= 90}">score-excellent</c:when>
                                                        <c:when test="${enrollment.hylEscore10 >= 80}">score-good</c:when>
                                                        <c:when test="${enrollment.hylEscore10 >= 70}">score-average</c:when>
                                                        <c:otherwise>score-poor</c:otherwise>
                                                    </c:choose>">
                                                    ${enrollment.hylEscore10}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999;">未录入</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${enrollment.hylEgpa10 != null}">
                                                <fmt:formatNumber value="${enrollment.hylEgpa10}" pattern="#.#"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999;">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${enrollment.courseCredit != null}">
                                                <c:choose>
                                                    <c:when test="${enrollment.hylEscore10 != null && enrollment.hylEscore10 >= 60}">
                                                        <span class="score-good">
                                                            <fmt:formatNumber value="${enrollment.courseCredit}" pattern="#.#"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #999;">
                                                            0.0 / <fmt:formatNumber value="${enrollment.courseCredit}" pattern="#.#"/>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999;">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="status-badge 
                                            <c:choose>
                                                <c:when test="${enrollment.hylStatus10 == '正常'}">status-normal</c:when>
                                                <c:when test="${enrollment.hylStatus10 == '重修'}">status-retake</c:when>
                                                <c:when test="${enrollment.hylStatus10 == '退课'}">status-withdraw</c:when>
                                                <c:otherwise>status-normal</c:otherwise>
                                            </c:choose>">
                                            ${enrollment.hylStatus10}
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${enrollment.hylEnrolldate10}" pattern="yyyy-MM-dd"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <p>暂无选课记录</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html> 