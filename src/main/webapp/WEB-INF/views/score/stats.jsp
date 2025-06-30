<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>成绩统计</title>
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
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .stats-grid { grid-template-columns: 1fr; }
            .nav-buttons { flex-direction: column; align-items: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 成绩统计概览</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/score/ranking" class="btn btn-success">📈 成绩排名</a>
            <a href="${pageContext.request.contextPath}/score/analysis" class="btn btn-info">📋 成绩分析</a>
            <a href="${pageContext.request.contextPath}/score/distribution" class="btn btn-primary">📊 成绩分布</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <c:choose>
            <c:when test="${empty overallStats}">
                <div style="text-align: center; padding: 40px; color: #666;">
                    <h3>📭 暂无成绩数据</h3>
                    <p>当前没有找到任何成绩记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 总体统计卡片 -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">${overallStats.totalStudents}</div>
                        <div class="stat-label">总学生数</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <fmt:formatNumber value="${overallStats.avgGPA}" pattern="#.##"/>
                        </div>
                        <div class="stat-label">平均GPA</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <fmt:formatNumber value="${overallStats.avgScore}" pattern="#.##"/>
                        </div>
                        <div class="stat-label">平均成绩</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${overallStats.excellentCount}</div>
                        <div class="stat-label">优秀学生</div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/student/scores" class="btn btn-success">📊 学生成绩</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 