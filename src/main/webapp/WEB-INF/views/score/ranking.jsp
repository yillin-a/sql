<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>成绩排名</title>
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
        .filter-section select, .filter-section input {
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
        .ranking-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .ranking-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        .ranking-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        .ranking-table tr:hover {
            background-color: #f8f9fa;
        }
        .rank-1 { background-color: #fff3cd; }
        .rank-2 { background-color: #f8f9fa; }
        .rank-3 { background-color: #fff3cd; }
        .gpa-score {
            font-weight: bold;
            color: #667eea;
        }
        .avg-score {
            font-weight: bold;
            color: #28a745;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .ranking-table { font-size: 14px; }
            .ranking-table th, .ranking-table td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏆 成绩排名榜</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/score/stats" class="btn btn-primary">📈 成绩统计</a>
            <a href="${pageContext.request.contextPath}/score/analysis" class="btn btn-info">📋 成绩分析</a>
            <a href="${pageContext.request.contextPath}/score/distribution" class="btn btn-success">📊 成绩分布</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <!-- 筛选条件 -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/score/ranking">
                <label for="major">选择专业：</label>
                <select name="major" id="major">
                    <option value="">全部专业</option>
                    <option value="计算机科学与技术" ${selectedMajor == '计算机科学与技术' ? 'selected' : ''}>计算机科学与技术</option>
                    <option value="软件工程" ${selectedMajor == '软件工程' ? 'selected' : ''}>软件工程</option>
                    <option value="信息管理与信息系统" ${selectedMajor == '信息管理与信息系统' ? 'selected' : ''}>信息管理与信息系统</option>
                </select>
                <label for="limit">显示前N名：</label>
                <input type="number" name="limit" id="limit" value="${limit}" min="1" max="100" style="width: 80px;">
                <button type="submit">查询</button>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${empty rankings}">
                <div style="text-align: center; padding: 40px; color: #666;">
                    <h3>📭 暂无排名数据</h3>
                    <p>当前没有找到任何成绩排名记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 排名表格 -->
                <table class="ranking-table">
                    <thead>
                        <tr>
                            <th>排名</th>
                            <th>学号</th>
                            <th>姓名</th>
                            <th>专业</th>
                            <th>班级</th>
                            <th>GPA</th>
                            <th>平均成绩</th>
                            <th>课程数</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ranking" items="${rankings}" varStatus="status">
                            <tr class="rank-${status.index + 1}">
                                <td>${status.index + 1}</td>
                                <td>${ranking.studentId}</td>
                                <td>${ranking.studentName}</td>
                                <td>${ranking.majorName}</td>
                                <td>${ranking.className}</td>
                                <td class="gpa-score">
                                    <fmt:formatNumber value="${ranking.gpa}" pattern="#.##"/>
                                </td>
                                <td class="avg-score">
                                    <fmt:formatNumber value="${ranking.avgScore}" pattern="#.##"/>
                                </td>
                                <td>${ranking.courseCount}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <c:if test="${not empty selectedMajor}">
                    <div style="text-align: center; margin-top: 20px; color: #666;">
                        <p>📊 显示专业：<strong>${selectedMajor}</strong> 的成绩排名</p>
                    </div>
                </c:if>
                
                <c:if test="${not empty limit}">
                    <div style="text-align: center; margin-top: 10px; color: #666;">
                        <p>📈 显示前 <strong>${limit}</strong> 名学生</p>
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