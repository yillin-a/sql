<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程平均成绩统计</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 {
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 2.2em;
            text-align: center;
        }
        .overview-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            margin: 0 0 10px 0;
            font-size: 1.2em;
            opacity: 0.9;
        }
        .stat-card .value {
            font-size: 2.5em;
            font-weight: bold;
            margin: 0;
        }
        .stat-card .subtitle {
            font-size: 0.9em;
            opacity: 0.8;
            margin-top: 5px;
        }
        .stat-card.excellent {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .stat-card.good {
            background: linear-gradient(135deg, #007bff 0%, #6f42c1 100%);
        }
        .stat-card.average {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        .stat-card.poor {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
        }
        tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .rank-1 {
            background-color: #fff3cd !important;
            font-weight: bold;
        }
        .rank-2 {
            background-color: #f8f9fa !important;
        }
        .rank-3 {
            background-color: #fff3cd !important;
        }
        .btn {
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            margin-right: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-info {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .nav-buttons {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .nav-buttons .btn {
            margin-right: 10px;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
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
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        .search-box {
            margin-bottom: 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }
        .search-box input {
            padding: 10px;
            width: 300px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            margin-right: 10px;
        }
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .search-box button {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.2s ease;
        }
        .search-box button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 5px 0; text-align: center; }
            .overview-stats { grid-template-columns: 1fr; }
            .search-box input { width: 100%; margin-bottom: 10px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 课程平均成绩统计</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-primary">📚 选课记录</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/enrollment/add" class="btn btn-info">➕ 添加选课</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-warning">🏠 返回首页</a>
        </div>

        <c:choose>
            <c:when test="${empty enrollments}">
                <div class="no-data">
                    <h3>📭 暂无课程数据</h3>
                    <p>当前没有找到任何课程成绩数据。</p>
                    <a href="${pageContext.request.contextPath}/enrollment/add" class="btn btn-primary">➕ 添加选课</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 总体统计 -->
                <c:if test="${not empty overallStats}">
                    <div class="overview-stats">
                        <div class="stat-card excellent">
                            <h3>总课程数</h3>
                            <p class="value"><fmt:formatNumber value="${overallStats.totalCourses}"/></p>
                        </div>
                        <div class="stat-card good">
                            <h3>总选课人次</h3>
                            <p class="value"><fmt:formatNumber value="${overallStats.totalEnrollments}"/></p>
                        </div>
                        <div class="stat-card average">
                            <h3>全体平均分</h3>
                            <p class="value"><fmt:formatNumber value="${overallStats.overallAverageScore}" maxFractionDigits="2"/></p>
                        </div>
                        <div class="stat-card poor">
                            <h3>总及格率</h3>
                            <p class="value"><fmt:formatNumber value="${overallStats.overallPassRate}" type="percent" maxFractionDigits="2"/></p>
                        </div>
                    </div>
                </c:if>

                <!-- 搜索框 -->
                <div class="search-box">
                    <form action="${pageContext.request.contextPath}/enrollment/course-average" method="get">
                        <input type="text" name="courseName" placeholder="按课程名称搜索..." value="${searchCourseName}">
                        <button type="submit">🔍 搜索</button>
                    </form>
                </div>

                <!-- 课程成绩列表 -->
                <table>
                    <thead>
                        <tr>
                            <th>排名</th>
                            <th>课程名称</th>
                            <th>选课人数</th>
                            <th>平均分</th>
                            <th>最高分</th>
                            <th>最低分</th>
                            <th>及格率</th>
                            <th>成绩等级</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="enrollment" items="${enrollments}" varStatus="status">
                            <tr class="rank-${status.count}">
                                <td>${status.count}</td>
                                <td><strong>${enrollment.courseName}</strong></td>
                                <td>${enrollment.studentCount}</td>
                                <td><fmt:formatNumber value="${enrollment.averageScore}" maxFractionDigits="2"/></td>
                                <td>${enrollment.maxScore}</td>
                                <td>${enrollment.minScore}</td>
                                <td><fmt:formatNumber value="${enrollment.passRate}" type="percent" maxFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${enrollment.averageScore >= 90}">
                                            <span class="score-excellent">优秀 (≥90)</span>
                                        </c:when>
                                        <c:when test="${enrollment.averageScore >= 80}">
                                            <span class="score-good">良好 (80-89)</span>
                                        </c:when>
                                        <c:when test="${enrollment.averageScore >= 70}">
                                            <span class="score-average">中等 (70-79)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="score-poor">待提高 (<70)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-primary">📚 返回选课记录</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-warning">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 