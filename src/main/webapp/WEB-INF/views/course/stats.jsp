<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程统计</title>
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border: 1px solid #dee2e6;
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-value {
            font-size: 3em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }
        .stat-label {
            color: #495057;
            font-size: 16px;
            font-weight: 600;
        }
        .stat-desc {
            color: #6c757d;
            font-size: 14px;
            margin-top: 8px;
        }
        .chart-section {
            margin-top: 40px;
        }
        .chart-container {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .chart-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        .chart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        .chart-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .chart-item h4 {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 18px;
        }
        .chart-bar {
            background: #e9ecef;
            height: 25px;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 8px;
        }
        .chart-fill {
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            transition: width 0.3s ease;
        }
        .chart-label {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #495057;
        }
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
        .btn-info {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .stats-grid { grid-template-columns: 1fr; }
            .chart-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 课程统计</h2>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${stats.totalCourses}</div>
                <div class="stat-label">总课程数</div>
                <div class="stat-desc">当前系统中的所有课程</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-value">
                    <fmt:formatNumber value="${stats.avgCredit}" pattern="#.#"/>
                </div>
                <div class="stat-label">平均学分</div>
                <div class="stat-desc">所有课程的平均学分</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-value">
                    <fmt:formatNumber value="${stats.avgHour}" pattern="#.#"/>
                </div>
                <div class="stat-label">平均学时</div>
                <div class="stat-desc">所有课程的平均学时</div>
            </div>
        </div>

        <div class="chart-section">
            <div class="chart-container">
                <div class="chart-title">📈 课程类型分布</div>
                <div class="chart-grid">
                    <c:forEach var="entry" items="${stats.typeStats}">
                        <div class="chart-item">
                            <h4>${entry.key}</h4>
                            <div class="chart-bar">
                                <div class="chart-fill" style="width: ${entry.value * 100 / stats.totalCourses}%"></div>
                            </div>
                            <div class="chart-label">
                                <span>${entry.value} 门课程</span>
                                <span><fmt:formatNumber value="${entry.value * 100 / stats.totalCourses}" pattern="#.#"/>%</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="chart-container">
                <div class="chart-title">📋 考核方式分布</div>
                <div class="chart-grid">
                    <c:forEach var="entry" items="${stats.testStats}">
                        <div class="chart-item">
                            <h4>${entry.key}</h4>
                            <div class="chart-bar">
                                <div class="chart-fill" style="width: ${entry.value * 100 / stats.totalCourses}%"></div>
                            </div>
                            <div class="chart-label">
                                <span>${entry.value} 门课程</span>
                                <span><fmt:formatNumber value="${entry.value * 100 / stats.totalCourses}" pattern="#.#"/>%</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">📋 课程列表</a>
            <a href="${pageContext.request.contextPath}/course/score-stats" class="btn btn-info">📈 成绩统计</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 