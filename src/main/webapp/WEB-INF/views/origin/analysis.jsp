<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>生源地分析</title>
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
        .nav-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            justify-content: center;
        }
        .btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
            font-size: 14px;
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
        }
        
        .analysis-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .analysis-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 5px solid #667eea;
        }
        
        .card-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card-icon {
            font-size: 1.5em;
        }
        
        .stats-list {
            list-style: none;
            padding: 0;
        }
        
        .stats-list li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .stats-list li:last-child {
            border-bottom: none;
        }
        
        .stat-label {
            color: #666;
            font-weight: 500;
        }
        
        .stat-value {
            color: #333;
            font-weight: bold;
            font-size: 1.1em;
        }
        
        .performance-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .performance-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: center;
            font-weight: 600;
        }
        
        .performance-table td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        
        .performance-table tbody tr:hover {
            background-color: #f8f9fa;
            transition: all 0.3s ease;
        }
        
        .origin-name {
            font-weight: 600;
            color: #333;
        }
        
        .excellent-count {
            color: #28a745;
            font-weight: bold;
        }
        
        .good-count {
            color: #17a2b8;
            font-weight: bold;
        }
        
        .poor-count {
            color: #dc3545;
            font-weight: bold;
        }
        
        .avg-gpa {
            color: #667eea;
            font-weight: bold;
        }
        
        .progress-bar {
            width: 100%;
            height: 20px;
            background-color: #f0f0f0;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 5px;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            transition: width 0.3s ease;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .analysis-grid { grid-template-columns: 1fr; }
            .performance-table { font-size: 14px; }
            .performance-table th, .performance-table td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📈 生源地成绩分析</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/origin/stats" class="btn btn-success">📈 统计概览</a>
            <a href="${pageContext.request.contextPath}/origin/distribution" class="btn btn-success">📊 生源地分布</a>
            <a href="${pageContext.request.contextPath}/origin/ranking" class="btn btn-info">🏆 生源地排名</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <c:choose>
            <c:when test="${empty analysis}">
                <div class="no-data">
                    <h3>📭 暂无分析数据</h3>
                    <p>当前没有找到任何生源地分析记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 分析统计卡片 -->
                <div class="analysis-grid">
                    <div class="analysis-card">
                        <h3 class="card-title">
                            <span class="card-icon">🌍</span>
                            生源地概况
                        </h3>
                        <ul class="stats-list">
                            <li>
                                <span class="stat-label">生源地总数</span>
                                <span class="stat-value">${analysis.totalOrigins}</span>
                            </li>
                            <li>
                                <span class="stat-label">学生总数</span>
                                <span class="stat-value">${analysis.totalStudents}</span>
                            </li>
                            <li>
                                <span class="stat-label">平均每地学生数</span>
                                <span class="stat-value">
                                    <fmt:formatNumber value="${analysis.avgStudentsPerOrigin}" pattern="#.##"/>
                                </span>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="analysis-card">
                        <h3 class="card-title">
                            <span class="card-icon">📊</span>
                            分布特征
                        </h3>
                        <ul class="stats-list">
                            <li>
                                <span class="stat-label">最多学生地区人数</span>
                                <span class="stat-value">${analysis.maxStudentsPerOrigin}</span>
                            </li>
                            <li>
                                <span class="stat-label">最少学生地区人数</span>
                                <span class="stat-value">${analysis.minStudentsPerOrigin}</span>
                            </li>
                            <li>
                                <span class="stat-label">人数差距</span>
                                <span class="stat-value">${analysis.maxStudentsPerOrigin - analysis.minStudentsPerOrigin}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- 生源地表现详情 -->
        <c:if test="${not empty originPerformance}">
            <div class="analysis-card" style="margin-top: 20px;">
                <h3 class="card-title">
                    <span class="card-icon">🎯</span>
                    生源地学业表现详情
                </h3>
                
                <table class="performance-table">
                    <thead>
                        <tr>
                            <th>生源地</th>
                            <th>学生人数</th>
                            <th>平均GPA</th>
                            <th>优秀(≥4.0)</th>
                            <th>良好(3.0-4.0)</th>
                            <th>需改进(<3.0)</th>
                            <th>优秀率</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="performance" items="${originPerformance}">
                            <tr>
                                <td>
                                    <span class="origin-name">
                                        <c:out value="${performance.originName}" default="未知"/>
                                    </span>
                                </td>
                                <td>${performance.studentCount} 人</td>
                                                                 <td>
                                     <span class="avg-gpa">
                                         <fmt:formatNumber value="${performance.avgGPA}" pattern="#.##"/>
                                     </span>
                                 </td>
                                <td>
                                    <span class="excellent-count">${performance.excellentCount} 人</span>
                                </td>
                                <td>
                                    <span class="good-count">${performance.goodCount} 人</span>
                                </td>
                                <td>
                                    <span class="poor-count">${performance.poorCount} 人</span>
                                </td>
                                <td>
                                    <c:set var="excellentRate" value="${performance.studentCount > 0 ? (performance.excellentCount * 100.0 / performance.studentCount) : 0}" />
                                    <fmt:formatNumber value="${excellentRate}" pattern="#.#"/>%
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: ${excellentRate}%"></div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 