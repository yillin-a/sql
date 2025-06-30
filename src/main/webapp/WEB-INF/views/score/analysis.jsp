<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>成绩分析</title>
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
        .analysis-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .analysis-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }
        .analysis-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .analysis-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }
        .analysis-label {
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
        .filter-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        .filter-section select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-right: 10px;
        }
        .filter-section button {
            padding: 8px 16px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .stats-detail {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
        .stats-detail h3 {
            color: #333;
            margin-bottom: 15px;
            text-align: center;
        }
        .stats-detail p {
            margin: 8px 0;
            color: #666;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .analysis-grid { grid-template-columns: 1fr; }
            .nav-buttons { flex-direction: column; align-items: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📋 成绩分析报告</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/score/stats" class="btn btn-primary">📈 成绩统计</a>
            <a href="${pageContext.request.contextPath}/score/ranking" class="btn btn-success">🏆 成绩排名</a>
            <a href="${pageContext.request.contextPath}/score/distribution" class="btn btn-info">📊 成绩分布</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <!-- 专业筛选 -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/score/analysis">
                <label for="major">选择专业：</label>
                <select name="major" id="major">
                    <option value="">全部专业</option>
                    <option value="计算机科学与技术" ${selectedMajor == '计算机科学与技术' ? 'selected' : ''}>计算机科学与技术</option>
                    <option value="软件工程" ${selectedMajor == '软件工程' ? 'selected' : ''}>软件工程</option>
                    <option value="信息管理与信息系统" ${selectedMajor == '信息管理与信息系统' ? 'selected' : ''}>信息管理与信息系统</option>
                </select>
                <button type="submit">分析</button>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${empty analysis}">
                <div style="text-align: center; padding: 40px; color: #666;">
                    <h3>📭 暂无成绩分析数据</h3>
                    <p>当前没有找到任何成绩分析记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 成绩分析卡片 -->
                <div class="analysis-grid">
                    <div class="analysis-card">
                        <div class="analysis-number">${analysis.totalStudents}</div>
                        <div class="analysis-label">总学生数</div>
                    </div>
                    <div class="analysis-card">
                        <div class="analysis-number">${analysis.totalCourses}</div>
                        <div class="analysis-label">总课程数</div>
                    </div>
                    <div class="analysis-card">
                        <div class="analysis-number">${analysis.totalScores}</div>
                        <div class="analysis-label">总成绩数</div>
                    </div>
                    <div class="analysis-card">
                        <div class="analysis-number">
                            <fmt:formatNumber value="${analysis.avgScore}" pattern="#.##"/>
                        </div>
                        <div class="analysis-label">平均成绩</div>
                    </div>
                    <div class="analysis-card">
                        <div class="analysis-number">${analysis.minScore}</div>
                        <div class="analysis-label">最低成绩</div>
                    </div>
                    <div class="analysis-card">
                        <div class="analysis-number">${analysis.maxScore}</div>
                        <div class="analysis-label">最高成绩</div>
                    </div>
                </div>
                
                <!-- 详细统计信息 -->
                <div class="stats-detail">
                    <h3>📊 详细统计信息</h3>
                    <c:if test="${not empty selectedMajor}">
                        <p><strong>分析范围：</strong>${selectedMajor}专业</p>
                    </c:if>
                    <p><strong>学生参与度：</strong>${analysis.totalScores}个成绩记录，平均每个学生${analysis.totalStudents > 0 ? analysis.totalScores / analysis.totalStudents : 0}门课程</p>
                    <p><strong>成绩分布：</strong>最高分${analysis.maxScore}分，最低分${analysis.minScore}分，差距${analysis.maxScore - analysis.minScore}分</p>
                    <p><strong>成绩水平：</strong>平均成绩${analysis.avgScore}分，整体表现${analysis.avgScore >= 80 ? '优秀' : analysis.avgScore >= 70 ? '良好' : analysis.avgScore >= 60 ? '中等' : '需要改进'}</p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/score/stats" class="btn btn-success">📊 成绩统计</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 