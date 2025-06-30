<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>生源地统计</title>
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
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }
        .stat-label {
            color: #666;
            font-size: 1.1em;
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
        .top-origins {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .top-origins h3 {
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        .origin-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .origin-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #667eea;
        }
        .origin-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        .origin-count {
            color: #667eea;
            font-size: 1.2em;
            font-weight: bold;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .stats-grid { grid-template-columns: 1fr; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .origin-list { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🌍 生源地统计概览</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/origin/distribution" class="btn btn-success">📊 生源地分布</a>
            <a href="${pageContext.request.contextPath}/origin/ranking" class="btn btn-info">🏆 生源地排名</a>
            <a href="${pageContext.request.contextPath}/origin/analysis" class="btn btn-primary">📈 生源地分析</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <c:choose>
            <c:when test="${empty overallStats}">
                <div style="text-align: center; padding: 40px; color: #666;">
                    <h3>📭 暂无生源地数据</h3>
                    <p>当前没有找到任何生源地记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 总体统计卡片 -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">${overallStats.totalStudents != null ? overallStats.totalStudents : 0}</div>
                        <div class="stat-label">总学生数</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${overallStats.totalOrigins != null ? overallStats.totalOrigins : 0}</div>
                        <div class="stat-label">生源地数量</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <fmt:formatNumber value="${overallStats.avgStudentsPerOrigin != null ? overallStats.avgStudentsPerOrigin : 0}" pattern="#.##"/>
                        </div>
                        <div class="stat-label">平均每地学生数</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${overallStats.mostPopularOrigin != null ? overallStats.mostPopularOrigin : '暂无'}</div>
                        <div class="stat-label">最热门生源地</div>
                    </div>
                </div>
                
                <!-- 热门生源地 -->
                <c:if test="${not empty topOrigins}">
                    <div class="top-origins">
                        <h3>🔥 热门生源地 TOP 10</h3>
                        <div class="origin-list">
                            <c:forEach var="origin" items="${topOrigins}">
                                <div class="origin-item">
                                    <div class="origin-name">${origin.originName}</div>
                                    <div class="origin-count">${origin.studentCount} 人</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 