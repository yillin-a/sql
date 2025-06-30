<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程成绩详情</title>
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
        .course-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #dee2e6;
        }
        .course-info h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.5em;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .info-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: 600;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .stat-card h4 {
            margin: 0 0 10px 0;
            font-size: 1.1em;
            opacity: 0.9;
        }
        .stat-card .value {
            font-size: 2em;
            font-weight: bold;
            margin: 0;
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
        .gpa-excellent {
            color: #28a745;
            font-weight: bold;
        }
        .gpa-good {
            color: #007bff;
            font-weight: bold;
        }
        .gpa-average {
            color: #ffc107;
            font-weight: bold;
        }
        .gpa-poor {
            color: #dc3545;
            font-weight: bold;
        }
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 5px 0; text-align: center; }
            .info-grid, .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📚 课程成绩详情</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-primary">📚 选课记录</a>
            <a href="${pageContext.request.contextPath}/enrollment/course-average" class="btn btn-info">📊 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-warning">🏠 返回首页</a>
        </div>

        <c:choose>
            <c:when test="${empty enrollments}">
                <div class="no-data">
                    <h3>📭 暂无成绩记录</h3>
                    <p>该课程目前没有任何选课记录或成绩信息。</p>
                    <a href="${pageContext.request.contextPath}/enrollment/add" class="btn btn-primary">➕ 添加选课</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 课程基本信息 -->
                <div class="course-info">
                    <h3>📖 课程基本信息</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">课程名称</div>
                            <div class="info-value">${courseName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">选课人数</div>
                            <div class="info-value">${enrollments.size()} 人</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">教学班编号</div>
                            <div class="info-value">
                                <c:out value="${enrollments[0].hylTcno10}" default="未知"/>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">授课教师</div>
                            <div class="info-value">
                                <c:out value="${enrollments[0].teacherName}" default="未分配"/>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 成绩统计 -->
                <div class="stats-grid">
                    <c:set var="excellentCount" value="0"/>
                    <c:set var="goodCount" value="0"/>
                    <c:set var="averageCount" value="0"/>
                    <c:set var="poorCount" value="0"/>
                    <c:set var="totalScore" value="0"/>
                    <c:set var="scoreCount" value="0"/>
                    
                    <c:forEach var="enrollment" items="${enrollments}">
                        <c:if test="${not empty enrollment.hylEscore10}">
                            <c:set var="totalScore" value="${totalScore + enrollment.hylEscore10}"/>
                            <c:set var="scoreCount" value="${scoreCount + 1}"/>
                            
                            <c:choose>
                                <c:when test="${enrollment.hylEscore10 >= 90}">
                                    <c:set var="excellentCount" value="${excellentCount + 1}"/>
                                </c:when>
                                <c:when test="${enrollment.hylEscore10 >= 80}">
                                    <c:set var="goodCount" value="${goodCount + 1}"/>
                                </c:when>
                                <c:when test="${enrollment.hylEscore10 >= 70}">
                                    <c:set var="averageCount" value="${averageCount + 1}"/>
                                </c:when>
                                <c:when test="${enrollment.hylEscore10 >= 60}">
                                    <c:set var="averageCount" value="${averageCount + 1}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="poorCount" value="${poorCount + 1}"/>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                    
                    <c:set var="averageScore" value="${scoreCount > 0 ? totalScore / scoreCount : 0}"/>
                    
                    <div class="stat-card">
                        <h4>平均分</h4>
                        <p class="value">
                            <fmt:formatNumber value="${averageScore}" pattern="#.#"/>
                        </p>
                    </div>
                    <div class="stat-card excellent">
                        <h4>优秀 (90+)</h4>
                        <p class="value">${excellentCount}</p>
                    </div>
                    <div class="stat-card good">
                        <h4>良好 (80-89)</h4>
                        <p class="value">${goodCount}</p>
                    </div>
                    <div class="stat-card average">
                        <h4>中等 (60-79)</h4>
                        <p class="value">${averageCount}</p>
                    </div>
                    <div class="stat-card poor">
                        <h4>不及格 (<60)</h4>
                        <p class="value">${poorCount}</p>
                    </div>
                </div>

                <!-- 成绩详情表格 -->
                <table>
                    <thead>
                        <tr>
                            <th>排名</th>
                            <th>学号</th>
                            <th>学生姓名</th>
                            <th>成绩</th>
                            <th>GPA</th>
                            <th>选课时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="enrollment" items="${enrollments}" varStatus="status">
                            <c:choose>
                                <c:when test="${status.index == 0}">
                                    <c:set var="rowClass" value="rank-1"/>
                                </c:when>
                                <c:when test="${status.index == 1}">
                                    <c:set var="rowClass" value="rank-2"/>
                                </c:when>
                                <c:when test="${status.index == 2}">
                                    <c:set var="rowClass" value="rank-3"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="rowClass" value=""/>
                                </c:otherwise>
                            </c:choose>
                            <tr class="${rowClass}">
                                <td>
                                    <c:choose>
                                        <c:when test="${status.index == 0}">🥇</c:when>
                                        <c:when test="${status.index == 1}">🥈</c:when>
                                        <c:when test="${status.index == 2}">🥉</c:when>
                                        <c:otherwise>${status.index + 1}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong>${enrollment.hylSno10}</strong></td>
                                <td>
                                    <span style="font-weight: 600; color: #333;">
                                        <c:out value="${enrollment.studentName}" default="未知"/>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.hylEscore10}">
                                            <c:choose>
                                                <c:when test="${enrollment.hylEscore10 >= 90}">
                                                    <span class="score-excellent">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 80}">
                                                    <span class="score-good">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 70}">
                                                    <span class="score-average">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 60}">
                                                    <span class="score-average">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="score-poor">${enrollment.hylEscore10}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未录入</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.hylEgpa10}">
                                            <c:choose>
                                                <c:when test="${enrollment.hylEgpa10 >= 4.0}">
                                                    <span class="gpa-excellent">
                                                        <fmt:formatNumber value="${enrollment.hylEgpa10}" pattern="#.###"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEgpa10 >= 3.0}">
                                                    <span class="gpa-good">
                                                        <fmt:formatNumber value="${enrollment.hylEgpa10}" pattern="#.###"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEgpa10 >= 2.0}">
                                                    <span class="gpa-average">
                                                        <fmt:formatNumber value="${enrollment.hylEgpa10}" pattern="#.###"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="gpa-poor">
                                                        <fmt:formatNumber value="${enrollment.hylEgpa10}" pattern="#.###"/>
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
                                    <c:choose>
                                        <c:when test="${not empty enrollment.hylEnrolldate10}">
                                            <fmt:formatDate value="${enrollment.hylEnrolldate10}" pattern="yyyy-MM-dd"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${enrollment.hylStatus10 == '正常'}">
                                            <span class="status-badge status-active">
                                                <c:out value="${enrollment.hylStatus10}" default="未知"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <c:out value="${enrollment.hylStatus10}" default="未知"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/enrollment/student?studentId=${enrollment.hylSno10}" 
                                           class="btn btn-info">👁️ 查看</a>
                                        <a href="${pageContext.request.contextPath}/enrollment/edit?studentId=${enrollment.hylSno10}&teachingClassId=${enrollment.hylTcno10}" 
                                           class="btn btn-warning">✏️ 编辑</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-primary">📚 返回选课记录</a>
            <a href="${pageContext.request.contextPath}/enrollment/course-average" class="btn btn-info">📊 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-warning">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 