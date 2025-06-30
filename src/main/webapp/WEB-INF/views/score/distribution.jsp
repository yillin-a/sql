<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>成绩分布</title>
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
        .distribution-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .distribution-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }
        .distribution-card.excellent {
            border-left: 5px solid #28a745;
        }
        .distribution-card.good {
            border-left: 5px solid #17a2b8;
        }
        .distribution-card.average {
            border-left: 5px solid #ffc107;
        }
        .distribution-card.pass {
            border-left: 5px solid #fd7e14;
        }
        .distribution-card.fail {
            border-left: 5px solid #dc3545;
        }
        .distribution-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .distribution-number {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .excellent .distribution-number { color: #28a745; }
        .good .distribution-number { color: #17a2b8; }
        .average .distribution-number { color: #ffc107; }
        .pass .distribution-number { color: #fd7e14; }
        .fail .distribution-number { color: #dc3545; }
        .distribution-label {
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
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .distribution-grid { grid-template-columns: 1fr; }
            .nav-buttons { flex-direction: column; align-items: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 成绩分布统计</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/score/stats" class="btn btn-primary">📈 成绩统计</a>
            <a href="${pageContext.request.contextPath}/score/ranking" class="btn btn-success">🏆 成绩排名</a>
            <a href="${pageContext.request.contextPath}/score/analysis" class="btn btn-info">📋 成绩分析</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <!-- 专业筛选 -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/score/distribution">
                <label for="major">选择专业：</label>
                <select name="major" id="major">
                    <option value="">全部专业</option>
                    <option value="计算机科学与技术" ${selectedMajor == '计算机科学与技术' ? 'selected' : ''}>计算机科学与技术</option>
                    <option value="软件工程" ${selectedMajor == '软件工程' ? 'selected' : ''}>软件工程</option>
                    <option value="信息管理与信息系统" ${selectedMajor == '信息管理与信息系统' ? 'selected' : ''}>信息管理与信息系统</option>
                </select>
                <button type="submit">筛选</button>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${empty distribution}">
                <div style="text-align: center; padding: 40px; color: #666;">
                    <h3>📭 暂无成绩分布数据</h3>
                    <p>当前没有找到任何成绩分布记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 成绩分布卡片 -->
                <div class="distribution-grid">
                    <div class="distribution-card excellent">
                        <div class="distribution-number">${distribution.excellent}</div>
                        <div class="distribution-label">优秀 (90-100分)</div>
                    </div>
                    <div class="distribution-card good">
                        <div class="distribution-number">${distribution.good}</div>
                        <div class="distribution-label">良好 (80-89分)</div>
                    </div>
                    <div class="distribution-card average">
                        <div class="distribution-number">${distribution.average}</div>
                        <div class="distribution-label">中等 (70-79分)</div>
                    </div>
                    <div class="distribution-card pass">
                        <div class="distribution-number">${distribution.pass}</div>
                        <div class="distribution-label">及格 (60-69分)</div>
                    </div>
                    <div class="distribution-card fail">
                        <div class="distribution-number">${distribution.fail}</div>
                        <div class="distribution-label">不及格 (<60分)</div>
                    </div>
                </div>
                
                <c:if test="${not empty selectedMajor}">
                    <div style="text-align: center; margin-top: 20px; color: #666;">
                        <p>📊 显示专业：<strong>${selectedMajor}</strong> 的成绩分布</p>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/score/stats" class="btn btn-success">📊 成绩统计</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 