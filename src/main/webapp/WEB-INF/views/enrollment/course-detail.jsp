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
        .course-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }
        .course-header h3 {
            margin: 0 0 10px 0;
            font-size: 1.8em;
        }
        .course-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            border-left: 5px solid #667eea;
        }
        .info-card h4 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 1.1em;
        }
        .info-card .value {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }
        .info-card .label {
            color: #666;
            font-size: 0.9em;
            margin-top: 5px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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
        .stat-card.excellent {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .stat-card.good {
            background: linear-gradient(135deg, #007bff 0%, #6f42c1 100%);
        }
        .stat-card.average {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        .stat-card.pass {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
        }
        .stat-card.fail {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
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
        .btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            margin-right: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .nav-buttons {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .chart-container {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .chart-title {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
            font-size: 1.5em;
            font-weight: 600;
        }
        .progress-bar {
            background: #e9ecef;
            border-radius: 10px;
            height: 30px;
            margin-bottom: 15px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            transition: width 0.3s ease;
        }
        .progress-excellent { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); }
        .progress-good { background: linear-gradient(135deg, #007bff 0%, #6f42c1 100%); }
        .progress-average { background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%); }
        .progress-pass { background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%); }
        .progress-fail { background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%); }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 10px 0; text-align: center; }
            .stats-grid { grid-template-columns: 1fr; }
            .course-info { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 课程成绩详情</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/enrollment/course-average" class="btn btn-primary">📈 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-success">📚 选课记录</a>
            <a href="${pageContext.request.contextPath}/enrollment/analysis" class="btn btn-warning">📊 成绩分析</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>

        <c:if test="${empty courseStats}">
            <div style="text-align: center; padding: 40px; color: #6c757d;">
                <h3>📭 课程不存在</h3>
                <p>未找到指定的课程信息。</p>
                <a href="${pageContext.request.contextPath}/enrollment/course-average" class="btn btn-primary">📈 返回课程列表</a>
            </div>
        </c:if>

        <c:if test="${not empty courseStats}">
            <!-- 课程头部信息 -->
            <div class="course-header">
                <h3>${courseStats.courseName}</h3>
                <p>教学班编号: ${courseStats.hylTcno10} | 授课教师: ${courseStats.teacherName}</p>
            </div>

            <!-- 课程基本信息 -->
            <div class="course-info">
                <div class="info-card">
                    <h4>📊 平均成绩</h4>
                    <div class="value">
                        <c:choose>
                            <c:when test="${courseStats.averageScore >= 90}">
                                <span style="color: #28a745;">
                                    <fmt:formatNumber value="${courseStats.averageScore}" pattern="#.#"/>
                                </span>
                            </c:when>
                            <c:when test="${courseStats.averageScore >= 80}">
                                <span style="color: #007bff;">
                                    <fmt:formatNumber value="${courseStats.averageScore}" pattern="#.#"/>
                                </span>
                            </c:when>
                            <c:when test="${courseStats.averageScore >= 70}">
                                <span style="color: #ffc107;">
                                    <fmt:formatNumber value="${courseStats.averageScore}" pattern="#.#"/>
                                </span>
                            </c:when>
                            <c:when test="${courseStats.averageScore >= 60}">
                                <span style="color: #17a2b8;">
                                    <fmt:formatNumber value="${courseStats.averageScore}" pattern="#.#"/>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #dc3545;">
                                    <fmt:formatNumber value="${courseStats.averageScore}" pattern="#.#"/>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="label">分</div>
                </div>
                <div class="info-card">
                    <h4>👥 选课人数</h4>
                    <div class="value">${courseStats.studentCount}</div>
                    <div class="label">人</div>
                </div>
                <div class="info-card">
                    <h4>🏆 最高分</h4>
                    <div class="value" style="color: #28a745;">${courseStats.maxScore}</div>
                    <div class="label">分</div>
                </div>
                <div class="info-card">
                    <h4>📉 最低分</h4>
                    <div class="value" style="color: #dc3545;">${courseStats.minScore}</div>
                    <div class="label">分</div>
                </div>
            </div>

            <!-- 成绩分布统计 -->
            <div class="stats-grid">
                <c:set var="excellentCount" value="0"/>
                <c:set var="goodCount" value="0"/>
                <c:set var="averageCount" value="0"/>
                <c:set var="passCount" value="0"/>
                <c:set var="failCount" value="0"/>
                
                <c:forEach var="dist" items="${scoreDistribution}">
                    <c:if test="${dist.courseName == '优秀'}">
                        <c:set var="excellentCount" value="${dist.studentCount}"/>
                    </c:if>
                    <c:if test="${dist.courseName == '良好'}">
                        <c:set var="goodCount" value="${dist.studentCount}"/>
                    </c:if>
                    <c:if test="${dist.courseName == '中等'}">
                        <c:set var="averageCount" value="${dist.studentCount}"/>
                    </c:if>
                    <c:if test="${dist.courseName == '及格'}">
                        <c:set var="passCount" value="${dist.studentCount}"/>
                    </c:if>
                    <c:if test="${dist.courseName == '不及格'}">
                        <c:set var="failCount" value="${dist.studentCount}"/>
                    </c:if>
                </c:forEach>
                
                <div class="stat-card excellent">
                    <h3>🥇 优秀 (90-100分)</h3>
                    <p class="value">${excellentCount}</p>
                    <p class="subtitle">
                        <c:if test="${courseStats.studentCount > 0}">
                            <fmt:formatNumber value="${excellentCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                        </c:if>
                    </p>
                </div>
                <div class="stat-card good">
                    <h3>🥈 良好 (80-89分)</h3>
                    <p class="value">${goodCount}</p>
                    <p class="subtitle">
                        <c:if test="${courseStats.studentCount > 0}">
                            <fmt:formatNumber value="${goodCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                        </c:if>
                    </p>
                </div>
                <div class="stat-card average">
                    <h3>🥉 中等 (70-79分)</h3>
                    <p class="value">${averageCount}</p>
                    <p class="subtitle">
                        <c:if test="${courseStats.studentCount > 0}">
                            <fmt:formatNumber value="${averageCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                        </c:if>
                    </p>
                </div>
                <div class="stat-card pass">
                    <h3>✅ 及格 (60-69分)</h3>
                    <p class="value">${passCount}</p>
                    <p class="subtitle">
                        <c:if test="${courseStats.studentCount > 0}">
                            <fmt:formatNumber value="${passCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                        </c:if>
                    </p>
                </div>
                <div class="stat-card fail">
                    <h3>❌ 不及格 (<60分)</h3>
                    <p class="value">${failCount}</p>
                    <p class="subtitle">
                        <c:if test="${courseStats.studentCount > 0}">
                            <fmt:formatNumber value="${failCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                        </c:if>
                    </p>
                </div>
            </div>

            <!-- 成绩分布图表 -->
            <div class="chart-container">
                <div class="chart-title">📊 成绩分布比例</div>
                <c:if test="${courseStats.studentCount > 0}">
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span style="font-weight: 600; color: #333;">优秀</span>
                            <span style="color: #666;">
                                ${excellentCount} 人 (<fmt:formatNumber value="${excellentCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%)
                            </span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill progress-excellent" 
                                 style="width: ${excellentCount * 100.0 / courseStats.studentCount}%;">
                                <fmt:formatNumber value="${excellentCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                            </div>
                        </div>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span style="font-weight: 600; color: #333;">良好</span>
                            <span style="color: #666;">
                                ${goodCount} 人 (<fmt:formatNumber value="${goodCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%)
                            </span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill progress-good" 
                                 style="width: ${goodCount * 100.0 / courseStats.studentCount}%;">
                                <fmt:formatNumber value="${goodCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                            </div>
                        </div>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span style="font-weight: 600; color: #333;">中等</span>
                            <span style="color: #666;">
                                ${averageCount} 人 (<fmt:formatNumber value="${averageCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%)
                            </span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill progress-average" 
                                 style="width: ${averageCount * 100.0 / courseStats.studentCount}%;">
                                <fmt:formatNumber value="${averageCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                            </div>
                        </div>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span style="font-weight: 600; color: #333;">及格</span>
                            <span style="color: #666;">
                                ${passCount} 人 (<fmt:formatNumber value="${passCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%)
                            </span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill progress-pass" 
                                 style="width: ${passCount * 100.0 / courseStats.studentCount}%;">
                                <fmt:formatNumber value="${passCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                            </div>
                        </div>
                    </div>
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span style="font-weight: 600; color: #333;">不及格</span>
                            <span style="color: #666;">
                                ${failCount} 人 (<fmt:formatNumber value="${failCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%)
                            </span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill progress-fail" 
                                 style="width: ${failCount * 100.0 / courseStats.studentCount}%;">
                                <fmt:formatNumber value="${failCount * 100.0 / courseStats.studentCount}" pattern="#.#"/>%
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </c:if>

        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/enrollment/course-average" class="btn btn-primary">📈 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-success">📚 选课记录</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-warning">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 