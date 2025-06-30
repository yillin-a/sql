<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>成绩分析统计</title>
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
        .summary-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .summary-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .summary-item h4 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 1.1em;
        }
        .summary-item .number {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }
        .summary-item .label {
            color: #666;
            font-size: 0.9em;
            margin-top: 5px;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 10px 0; text-align: center; }
            .stats-grid { grid-template-columns: 1fr; }
            .summary-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 成绩分析统计</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/enrollment/course-average" class="btn btn-primary">📈 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-success">📚 选课记录</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-warning">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>

        <c:if test="${empty overallStats}">
            <div style="text-align: center; padding: 40px; color: #6c757d;">
                <h3>📭 暂无成绩数据</h3>
                <p>当前没有找到任何成绩数据，请先添加选课记录并录入成绩。</p>
                <a href="${pageContext.request.contextPath}/enrollment/add" class="btn btn-primary">➕ 添加选课</a>
            </div>
        </c:if>

        <c:if test="${not empty overallStats}">
            <!-- 总体统计 -->
            <div class="summary-section">
                <h3 style="margin-top: 0; color: #333; text-align: center;">📋 总体统计</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <h4>👥 参与学生</h4>
                        <div class="number">${overallStats.studentCount}</div>
                        <div class="label">人</div>
                    </div>
                    <div class="summary-item">
                        <h4>📚 开设课程</h4>
                        <div class="number">${overallStats.year}</div>
                        <div class="label">门</div>
                    </div>
                    <div class="summary-item">
                        <h4>📝 选课记录</h4>
                        <div class="number">${overallStats.term}</div>
                        <div class="label">条</div>
                    </div>
                    <div class="summary-item">
                        <h4>📊 有成绩记录</h4>
                        <div class="number">${overallStats.hylEscore10}</div>
                        <div class="label">条</div>
                    </div>
                </div>
            </div>

            <!-- 成绩统计卡片 -->
            <div class="stats-grid">
                <div class="stat-card excellent">
                    <h3>🥇 优秀 (90-100分)</h3>
                    <p class="value">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '优秀'}">${dist.studentCount}</c:if>
                        </c:forEach>
                    </p>
                    <p class="subtitle">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '优秀'}">
                                <fmt:formatNumber value="${dist.averageScore}" pattern="#.#"/>%
                            </c:if>
                        </c:forEach>
                    </p>
                </div>
                <div class="stat-card good">
                    <h3>🥈 良好 (80-89分)</h3>
                    <p class="value">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '良好'}">${dist.studentCount}</c:if>
                        </c:forEach>
                    </p>
                    <p class="subtitle">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '良好'}">
                                <fmt:formatNumber value="${dist.averageScore}" pattern="#.#"/>%
                            </c:if>
                        </c:forEach>
                    </p>
                </div>
                <div class="stat-card average">
                    <h3>🥉 中等 (70-79分)</h3>
                    <p class="value">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '中等'}">${dist.studentCount}</c:if>
                        </c:forEach>
                    </p>
                    <p class="subtitle">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '中等'}">
                                <fmt:formatNumber value="${dist.averageScore}" pattern="#.#"/>%
                            </c:if>
                        </c:forEach>
                    </p>
                </div>
                <div class="stat-card pass">
                    <h3>✅ 及格 (60-69分)</h3>
                    <p class="value">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '及格'}">${dist.studentCount}</c:if>
                        </c:forEach>
                    </p>
                    <p class="subtitle">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '及格'}">
                                <fmt:formatNumber value="${dist.averageScore}" pattern="#.#"/>%
                            </c:if>
                        </c:forEach>
                    </p>
                </div>
                <div class="stat-card fail">
                    <h3>❌ 不及格 (<60分)</h3>
                    <p class="value">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '不及格'}">${dist.studentCount}</c:if>
                        </c:forEach>
                    </p>
                    <p class="subtitle">
                        <c:forEach var="dist" items="${scoreDistribution}">
                            <c:if test="${dist.courseName == '不及格'}">
                                <fmt:formatNumber value="${dist.averageScore}" pattern="#.#"/>%
                            </c:if>
                        </c:forEach>
                    </p>
                </div>
            </div>

            <!-- 成绩分布图表 -->
            <div class="chart-container">
                <div class="chart-title">📊 成绩分布比例</div>
                <c:forEach var="dist" items="${scoreDistribution}">
                    <div style="margin-bottom: 10px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                            <span style="font-weight: 600; color: #333;">${dist.courseName}</span>
                            <span style="color: #666;">
                                ${dist.studentCount} 人 (<fmt:formatNumber value="${dist.averageScore}" pattern="#.#"/>%)
                            </span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill progress-${dist.courseName == '优秀' ? 'excellent' : dist.courseName == '良好' ? 'good' : dist.courseName == '中等' ? 'average' : dist.courseName == '及格' ? 'pass' : 'fail'}" 
                                 style="width: ${dist.averageScore}%;">
                                <fmt:formatNumber value="${dist.averageScore}" pattern="#.#"/>%
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 成绩范围统计 -->
            <div class="summary-section">
                <h3 style="margin-top: 0; color: #333; text-align: center;">📈 成绩范围统计</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <h4>🏆 最高分</h4>
                        <div class="number">${overallStats.maxScore}</div>
                        <div class="label">分</div>
                    </div>
                    <div class="summary-item">
                        <h4>📊 平均分</h4>
                        <div class="number">
                            <fmt:formatNumber value="${overallStats.averageScore}" pattern="#.#"/>
                        </div>
                        <div class="label">分</div>
                    </div>
                    <div class="summary-item">
                        <h4>📉 最低分</h4>
                        <div class="number">${overallStats.minScore}</div>
                        <div class="label">分</div>
                    </div>
                    <div class="summary-item">
                        <h4>📋 成绩录入率</h4>
                        <div class="number">
                            <fmt:formatNumber value="${overallStats.term > 0 ? (overallStats.hylEscore10 * 100.0 / overallStats.term) : 0}" pattern="#.#"/>
                        </div>
                        <div class="label">%</div>
                    </div>
                </div>
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