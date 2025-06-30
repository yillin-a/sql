<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程成绩仪表板 - 管理员</title>
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
        
        /* 总体统计卡片 */
        .overview-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
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
        
        /* 内容网格 */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        /* 卡片样式 */
        .dashboard-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }
        .dashboard-card h3 {
            color: #333;
            margin: 0 0 20px 0;
            font-size: 1.5em;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        
        /* 表格样式 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
        }
        tr:hover {
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
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
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
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .dashboard-grid { grid-template-columns: 1fr; }
            .overview-stats { grid-template-columns: 1fr; }
            .btn { display: block; margin: 5px 0; text-align: center; }
            table { font-size: 12px; }
            th, td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 课程成绩仪表板</h2>
        
        <!-- 总体统计 -->
        <div class="overview-stats">
            <div class="stat-card">
                <h4>📚 课程总数</h4>
                <p class="value">
                    <c:choose>
                        <c:when test="${not empty overallStats}">${overallStats.totalCourses}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </p>
                <p class="subtitle">门课程</p>
            </div>
            <div class="stat-card">
                <h4>👥 教学班总数</h4>
                <p class="value">
                    <c:choose>
                        <c:when test="${not empty overallStats}">${overallStats.totalTeachingClasses}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </p>
                <p class="subtitle">个教学班</p>
            </div>
            <div class="stat-card">
                <h4>📈 总体平均分</h4>
                <p class="value">
                    <c:choose>
                        <c:when test="${not empty overallStats and not empty overallStats.overallAvgScore}">
                            <fmt:formatNumber value="${overallStats.overallAvgScore}" pattern="#.#"/>
                        </c:when>
                        <c:otherwise>0.0</c:otherwise>
                    </c:choose>
                </p>
                <p class="subtitle">分</p>
            </div>
        </div>
        
        <!-- 主要内容区域 -->
        <div class="dashboard-grid">
            <!-- 课程成绩统计 -->
            <div class="dashboard-card">
                <h3>📚 课程成绩统计</h3>
                <c:choose>
                    <c:when test="${empty topCourses}">
                        <p style="text-align: center; color: #666; font-style: italic;">暂无课程数据</p>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>课程名称</th>
                                    <th>授课教师</th>
                                    <th>选课人数</th>
                                    <th>平均成绩</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="course" items="${topCourses}" varStatus="status">
                                    <tr>
                                        <td>
                                            <strong>${course.courseName}</strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty course.teacherName}">
                                                    ${course.teacherName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #999;">未分配</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${course.studentCount}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${course.avgScore >= 90}">
                                                    <span class="score-excellent">
                                                        <fmt:formatNumber value="${course.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${course.avgScore >= 80}">
                                                    <span class="score-good">
                                                        <fmt:formatNumber value="${course.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${course.avgScore >= 70}">
                                                    <span class="score-average">
                                                        <fmt:formatNumber value="${course.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="score-poor">
                                                        <fmt:formatNumber value="${course.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- 教师统计 -->
            <div class="dashboard-card">
                <h3>👨‍🏫 教师统计</h3>
                <c:choose>
                    <c:when test="${empty topTeachers}">
                        <p style="text-align: center; color: #666; font-style: italic;">暂无教师数据</p>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>教师姓名</th>
                                    <th>平均成绩</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="teacher" items="${topTeachers}" varStatus="status">
                                    <tr>
                                        <td>
                                            <strong>${teacher.teacherName}</strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${teacher.avgScore >= 90}">
                                                    <span class="score-excellent">
                                                        <fmt:formatNumber value="${teacher.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${teacher.avgScore >= 80}">
                                                    <span class="score-good">
                                                        <fmt:formatNumber value="${teacher.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:when test="${teacher.avgScore >= 70}">
                                                    <span class="score-average">
                                                        <fmt:formatNumber value="${teacher.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="score-poor">
                                                        <fmt:formatNumber value="${teacher.avgScore}" pattern="#.#"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="actions">
            <a href="${pageContext.request.contextPath}/course/average-scores" class="btn btn-primary">📊 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/course/teacher-stats" class="btn btn-success">👨‍🏫 教师课程统计</a>
            <a href="${pageContext.request.contextPath}/course/score-stats" class="btn btn-info">📈 课程成绩统计</a>
            <a href="${pageContext.request.contextPath}/admin/course-score/export?type=course-scores" class="btn btn-warning">📥 导出课程数据</a>
            <a href="${pageContext.request.contextPath}/admin/course-score/export?type=teacher-stats" class="btn btn-warning">📥 导出教师数据</a>
            <button onclick="updateGPA()" class="btn" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">🔄 更新学生GPA</button>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <!-- JavaScript -->
        <script>
        function updateGPA() {
            if (confirm('确定要更新所有学生的GPA吗？这个操作可能需要一些时间。')) {
                // 显示加载状态
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ 更新中...';
                button.disabled = true;
                
                // 发送POST请求
                fetch('${pageContext.request.contextPath}/admin/course-score/update-gpa', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    }
                })
                .then(response => {
                    if (response.ok) {
                        // 重新加载页面以显示更新结果
                        window.location.reload();
                    } else {
                        throw new Error('更新失败');
                    }
                })
                .catch(error => {
                    alert('更新失败: ' + error.message);
                    button.innerHTML = originalText;
                    button.disabled = false;
                });
            }
        }
        
        // 显示成功或错误消息
        <c:if test="${not empty sessionScope.successMessage}">
            alert('${sessionScope.successMessage}');
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            alert('${sessionScope.errorMessage}');
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
        </script>
    </div>
</body>
</html> 