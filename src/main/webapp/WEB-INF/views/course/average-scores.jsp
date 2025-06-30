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
        
        /* 搜索区域 */
        .search-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
        }
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-input {
            flex: 1;
            min-width: 200px;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .search-input:focus {
            outline: none;
            border-color: #667eea;
        }
        .search-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: transform 0.2s ease;
        }
        .search-btn:hover {
            transform: translateY(-2px);
        }
        .clear-btn {
            background: #6c757d;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.2s ease;
        }
        .clear-btn:hover {
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
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
        
        /* 课程类型标签 */
        .course-type {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .type-required {
            background-color: #d4edda;
            color: #155724;
        }
        .type-elective {
            background-color: #fff3cd;
            color: #856404;
        }
        .type-general {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .type-practice {
            background-color: #f8d7da;
            color: #721c24;
        }
        .type-sports {
            background-color: #e2e3e5;
            color: #383d41;
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
            .search-form { flex-direction: column; align-items: stretch; }
            .search-input { min-width: auto; }
            .stats-overview { grid-template-columns: 1fr; }
            .btn { display: block; margin: 5px 0; text-align: center; }
            table { font-size: 12px; }
            th, td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 课程平均成绩统计
            <c:if test="${userType == 'teacher'}">
                <span style="font-size: 0.6em; color: #666; font-weight: normal;">（我的课程）</span>
            </c:if>
        </h2>
        
        <!-- 搜索区域 -->
        <div class="search-section">
            <form class="search-form" method="GET" action="${pageContext.request.contextPath}/course/average-scores">
                <input type="text" name="courseName" value="${searchCourseName}" 
                       placeholder="输入课程名称进行搜索..." class="search-input">
                <button type="submit" class="search-btn">🔍 搜索</button>
                <a href="${pageContext.request.contextPath}/course/average-scores" class="clear-btn">🔄 清除</a>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${empty scoreStats}">
                <div class="no-data">
                    <h3>📭 暂无课程数据</h3>
                    <p>当前没有找到任何课程成绩数据。</p>
                    <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">📚 查看课程列表</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 统计概览 -->
                <div class="stats-overview">
                    <c:choose>
                        <c:when test="${userType == 'admin' && not empty overallStats}">
                            <!-- 管理员全局统计 -->
                            <div class="stat-card">
                                <h4>📚 课程总数</h4>
                                <p class="value">${overallStats.totalCourses}</p>
                                <p class="subtitle">门课程</p>
                            </div>
                            <div class="stat-card">
                                <h4>👥 教学班总数</h4>
                                <p class="value">${overallStats.totalTeachingClasses}</p>
                                <p class="subtitle">个教学班</p>
                            </div>
                            <div class="stat-card">
                                <h4>🎓 选课总人数</h4>
                                <p class="value">${overallStats.totalStudents}</p>
                                <p class="subtitle">人次</p>
                            </div>
                            <div class="stat-card">
                                <h4>📈 总体平均分</h4>
                                <p class="value">
                                    <c:choose>
                                        <c:when test="${not empty overallStats.overallAvgScore}">
                                            <fmt:formatNumber value="${overallStats.overallAvgScore}" pattern="#.#"/>
                                        </c:when>
                                        <c:otherwise>0.0</c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="subtitle">分</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- 教师个人统计 -->
                            <div class="stat-card">
                                <h4>📚 我的课程数</h4>
                                <p class="value">${scoreStats.size()}</p>
                                <p class="subtitle">门课程</p>
                            </div>
                            <div class="stat-card">
                                <h4>👥 我的教学班</h4>
                                <p class="value">${scoreStats.size()}</p>
                                <p class="subtitle">个教学班</p>
                            </div>
                            <div class="stat-card">
                                <h4>🎓 学生总数</h4>
                                <p class="value">
                                    <c:set var="totalStudents" value="0"/>
                                    <c:forEach var="stat" items="${scoreStats}">
                                        <c:set var="totalStudents" value="${totalStudents + stat.studentCount}"/>
                                    </c:forEach>
                                    ${totalStudents}
                                </p>
                                <p class="subtitle">人次</p>
                            </div>
                            <div class="stat-card">
                                <h4>📈 平均成绩</h4>
                                <p class="value">
                                    <c:choose>
                                        <c:when test="${not empty scoreStats}">
                                            <c:set var="totalScore" value="0"/>
                                            <c:set var="validCount" value="0"/>
                                            <c:forEach var="stat" items="${scoreStats}">
                                                <c:if test="${stat.avgScore > 0}">
                                                    <c:set var="totalScore" value="${totalScore + stat.avgScore}"/>
                                                    <c:set var="validCount" value="${validCount + 1}"/>
                                                </c:if>
                                            </c:forEach>
                                            <c:choose>
                                                <c:when test="${validCount > 0}">
                                                    <fmt:formatNumber value="${totalScore / validCount}" pattern="#.#"/>
                                                </c:when>
                                                <c:otherwise>0.0</c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>0.0</c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="subtitle">分</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- 课程平均成绩表格 -->
                <table>
                    <thead>
                        <tr>
                            <th>课程名称</th>
                            <th>课程类型</th>
                            <th>教学班编号</th>
                            <th>授课教师</th>
                            <th>学年</th>
                            <th>学期</th>
                            <th>选课人数</th>
                            <th>平均成绩</th>
                            <th>最高分</th>
                            <th>最低分</th>
                            <th>成绩分布</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="stat" items="${scoreStats}" varStatus="status">
                            <tr>
                                <td>
                                    <strong style="color: #333;">
                                        ${stat.courseName}
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stat.courseType == '必修课'}">
                                            <span class="course-type type-required">必修课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '限选课'}">
                                            <span class="course-type type-elective">限选课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '通识课'}">
                                            <span class="course-type type-general">通识课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '实践课'}">
                                            <span class="course-type type-practice">实践课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '体育课'}">
                                            <span class="course-type type-sports">体育课</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">${stat.courseType}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${stat.teachingClassId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty stat.teacherName}">
                                            ${stat.teacherName}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未分配</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${stat.year}</td>
                                <td>${stat.term}</td>
                                <td>
                                    <span style="font-weight: 600; color: #007bff;">
                                        ${stat.studentCount}
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
            <c:if test="${userType == 'admin'}">
                <a href="${pageContext.request.contextPath}/course/teacher-stats" class="btn btn-info">👨‍🏫 教师课程统计</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/course/score-stats" class="btn btn-success">📈 课程成绩统计</a>
            <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">📚 课程管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 