<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>教师课程统计 - 管理员</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1400px;
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
        
        /* 统计卡片 */
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .stat-card h4 {
            margin: 0 0 10px 0;
            font-size: 16px;
            opacity: 0.9;
        }
        .stat-card .value {
            font-size: 2.2em;
            font-weight: bold;
            margin: 0;
        }
        .stat-card .subtitle {
            margin: 5px 0 0 0;
            opacity: 0.8;
            font-size: 14px;
        }
        
        /* 表格样式 */
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
            position: sticky;
            top: 0;
        }
        tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        /* 成绩样式 */
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
        
        /* 成绩分布样式 */
        .score-distribution {
            font-size: 12px;
            color: #666;
        }
        .distribution-item {
            display: inline-block;
            margin-right: 8px;
            padding: 2px 6px;
            border-radius: 4px;
            background: #f8f9fa;
        }
        
        /* 按钮样式 */
        .btn {
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin-right: 15px;
            margin-bottom: 10px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-info {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
            text-decoration: none;
        }
        
        /* 操作区域 */
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        /* 无数据样式 */
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .stats-overview { grid-template-columns: 1fr; }
            .btn { display: block; margin: 5px 0; text-align: center; }
            table { font-size: 12px; }
            th, td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>👨‍🏫 教师课程统计</h2>
        
        <c:choose>
            <c:when test="${empty teacherStats}">
                <div class="no-data">
                    <h3>📭 暂无教师数据</h3>
                    <p>当前没有找到任何教师的课程统计信息。</p>
                    <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">📚 查看课程列表</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 总体统计 -->
                <div class="stats-overview">
                    <div class="stat-card">
                        <h4>👨‍🏫 教师总数</h4>
                        <p class="value">${teacherStats.size()}</p>
                        <p class="subtitle">位教师</p>
                    </div>
                    <div class="stat-card">
                        <h4>📚 教学班总数</h4>
                        <p class="value">
                            <c:set var="totalCourses" value="0"/>
                            <c:forEach var="stat" items="${teacherStats}">
                                <c:set var="totalCourses" value="${totalCourses + stat.courseCount}"/>
                            </c:forEach>
                            ${totalCourses}
                        </p>
                        <p class="subtitle">个教学班</p>
                    </div>
                    <div class="stat-card">
                        <h4>🎓 选课总人数</h4>
                        <p class="value">
                            <c:set var="totalStudents" value="0"/>
                            <c:forEach var="stat" items="${teacherStats}">
                                <c:set var="totalStudents" value="${totalStudents + stat.totalStudents}"/>
                            </c:forEach>
                            ${totalStudents}
                        </p>
                        <p class="subtitle">人次</p>
                    </div>
                    <div class="stat-card">
                        <h4>📈 总体平均分</h4>
                        <p class="value">
                            <c:set var="totalScore" value="0"/>
                            <c:set var="scoreCount" value="0"/>
                            <c:forEach var="stat" items="${teacherStats}">
                                <c:if test="${not empty stat.avgScore}">
                                    <c:set var="totalScore" value="${totalScore + stat.avgScore}"/>
                                    <c:set var="scoreCount" value="${scoreCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            <fmt:formatNumber value="${scoreCount > 0 ? totalScore / scoreCount : 0}" pattern="#.#"/>
                        </p>
                        <p class="subtitle">分</p>
                    </div>
                </div>
                
                <!-- 教师课程统计表格 -->
                <table>
                    <thead>
                        <tr>
                            <th>教师姓名</th>
                            <th>课程数量</th>
                            <th>教学班数量</th>
                            <th>选课总人数</th>
                            <th>平均成绩</th>
                            <th>最高分</th>
                            <th>最低分</th>
                            <th>成绩分布</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="stat" items="${teacherStats}" varStatus="status">
                            <tr>
                                <td>
                                    <strong style="color: #333;">
                                        ${stat.teacherName}
                                    </strong>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #007bff;">
                                        ${stat.courseCount}
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #17a2b8;">
                                        ${stat.teachingClassCount}
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #28a745;">
                                        ${stat.totalStudents}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty stat.avgScore}">
                                            <c:choose>
                                                <c:when test="${stat.avgScore >= 90}">
                                                    <span class="score-excellent">
                                                        <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${stat.avgScore >= 80}">
                                                    <span class="score-good">
                                                        <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${stat.avgScore >= 70}">
                                                    <span class="score-average">
                                                        <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="score-poor">
                                                        <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">暂无数据</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty stat.maxScore}">
                                            <span class="score-excellent">${stat.maxScore}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty stat.minScore}">
                                            <span class="score-poor">${stat.minScore}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="score-distribution">
                                        <c:if test="${stat.excellentCount > 0}">
                                            <span class="distribution-item" style="background: #d4edda; color: #155724;">
                                                优秀:${stat.excellentCount}
                                            </span>
                                        </c:if>
                                        <c:if test="${stat.goodCount > 0}">
                                            <span class="distribution-item" style="background: #d1ecf1; color: #0c5460;">
                                                良好:${stat.goodCount}
                                            </span>
                                        </c:if>
                                        <c:if test="${stat.averageCount > 0}">
                                            <span class="distribution-item" style="background: #fff3cd; color: #856404;">
                                                中等:${stat.averageCount}
                                            </span>
                                        </c:if>
                                        <c:if test="${stat.passCount > 0}">
                                            <span class="distribution-item" style="background: #e2e3e5; color: #383d41;">
                                                及格:${stat.passCount}
                                            </span>
                                        </c:if>
                                        <c:if test="${stat.failCount > 0}">
                                            <span class="distribution-item" style="background: #f8d7da; color: #721c24;">
                                                不及格:${stat.failCount}
                                            </span>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        
        <!-- 操作按钮 -->
        <div class="actions">
            <a href="${pageContext.request.contextPath}/course/average-scores" class="btn btn-success">📊 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/course/score-stats" class="btn btn-info">📈 课程成绩统计</a>
            <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">📚 课程管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 