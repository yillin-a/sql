<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学生详细成绩 - ${student.hylSname10}</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background-color: #f5f5f5; 
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            background-color: white; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        h2 { 
            color: #333; 
            border-bottom: 2px solid #007bff; 
            padding-bottom: 10px; 
            margin-bottom: 20px;
        }
        .student-info {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .stat-card h4 {
            margin: 0 0 10px 0;
            font-size: 14px;
            opacity: 0.9;
        }
        .stat-card .number {
            font-size: 2em;
            font-weight: bold;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
        }
        th, td { 
            padding: 12px; 
            text-align: left; 
            border-bottom: 1px solid #ddd; 
        }
        th { 
            background-color: #f8f9fa; 
            font-weight: bold; 
            color: #333; 
        }
        tr:hover { 
            background-color: #f5f5f5; 
        }
        .btn { 
            padding: 8px 16px; 
            text-decoration: none; 
            border-radius: 4px; 
            font-size: 14px; 
            margin-right: 5px; 
            display: inline-block;
        }
        .btn-primary { 
            background-color: #007bff; 
            color: white; 
        }
        .btn-info { 
            background-color: #17a2b8; 
            color: white; 
        }
        .btn-success { 
            background-color: #28a745; 
            color: white; 
        }
        .score-excellent { 
            color: #28a745; 
            font-weight: bold; 
        }
        .score-good { 
            color: #007bff; 
            font-weight: bold; 
        }
        .score-average { 
            color: #ffc107; 
            font-weight: bold; 
        }
        .score-poor { 
            color: #dc3545; 
            font-weight: bold; 
        }
        .term-header {
            background-color: #e9ecef;
            font-weight: bold;
            color: #495057;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 ${student.hylSname10} 的详细成绩</h2>
        
        <!-- 学生基本信息 -->
        <div class="student-info">
            <h3>👤 学生信息</h3>
            <p><strong>学号：</strong>${student.hylSno10}</p>
            <p><strong>姓名：</strong>${student.hylSname10}</p>
            <p><strong>性别：</strong>${student.hylSsex10}</p>
            <p><strong>专业：</strong>${student.majorName}</p>
            <p><strong>班级：</strong>${student.className}</p>
            <p><strong>状态：</strong>${student.hylSstatus10}</p>
        </div>
        
        <!-- 成绩统计 -->
        <h3>📈 成绩统计</h3>
        <div class="stats-grid">
            <div class="stat-card">
                <h4>总课程数</h4>
                <div class="number">${stats.totalCourses}</div>
            </div>
            <div class="stat-card">
                <h4>通过课程</h4>
                <div class="number">${stats.passedCourses}</div>
            </div>
            <div class="stat-card">
                <h4>通过率</h4>
                <div class="number"><fmt:formatNumber value="${stats.passRate}" pattern="#.##"/>%</div>
            </div>
            <div class="stat-card">
                <h4>平均分</h4>
                <div class="number"><fmt:formatNumber value="${stats.avgScore}" pattern="#.##"/></div>
            </div>
            <div class="stat-card">
                <h4>总学分</h4>
                <div class="number">${stats.totalCredits}</div>
            </div>
            <div class="stat-card">
                <h4>已获学分</h4>
                <div class="number">${stats.earnedCredits}</div>
            </div>
        </div>
        
        <!-- 详细成绩列表 -->
        <h3>📋 课程成绩详情</h3>
        <c:choose>
            <c:when test="${empty scores}">
                <div class="no-data">
                    <p>暂无成绩记录</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>学年学期</th>
                            <th>课程名称</th>
                            <th>课程类型</th>
                            <th>学分</th>
                            <th>教学班</th>
                            <th>任课教师</th>
                            <th>成绩</th>
                            <th>GPA</th>
                            <th>状态</th>
                            <th>选课时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="score" items="${scores}">
                            <tr>
                                <td>${score.year}-${score.term}</td>
                                <td>${score.courseName}</td>
                                <td>${score.courseType}</td>
                                <td>${score.credit}</td>
                                <td>${score.className}</td>
                                <td>${score.teacherName}</td>
                                <td class="<c:choose><c:when test="${score.score >= 90}">score-excellent</c:when><c:when test="${score.score >= 80}">score-good</c:when><c:when test="${score.score >= 70}">score-average</c:when><c:when test="${score.score >= 60}">score-average</c:when><c:otherwise>score-poor</c:otherwise></c:choose>">${score.score}</td>
                                <td>${score.gpa}</td>
                                <td>${score.status}</td>
                                <td><fmt:formatDate value="${score.enrollDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        
        <!-- 操作按钮 -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/student/scores" class="btn btn-primary">返回成绩排名</a>
            <a href="${pageContext.request.contextPath}/student/view?id=${student.hylSno10}" class="btn btn-info">查看学生详情</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">返回学生列表</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">返回首页</a>
        </div>
    </div>
</body>
</html> 