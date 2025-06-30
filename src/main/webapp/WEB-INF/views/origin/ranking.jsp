<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>生源地排名</title>
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
            text-align: center;
            font-weight: 600;
        }
        
        .ranking-table td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        
        .ranking-table tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
            transition: all 0.3s ease;
        }
        
        .rank-medal {
            font-size: 1.5em;
            margin-right: 5px;
        }
        
        .rank-1 { color: #FFD700; }
        .rank-2 { color: #C0C0C0; }
        .rank-3 { color: #CD7F32; }
        
        .origin-name {
            font-weight: 600;
            color: #333;
        }
        
        .student-count {
            color: #667eea;
            font-weight: bold;
        }
        
        .avg-gpa {
            color: #28a745;
            font-weight: bold;
        }
        
        .good-students {
            color: #17a2b8;
            font-weight: bold;
        }
        
        .stats-summary {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .stat-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 1.8em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
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
            .ranking-table { font-size: 14px; }
            .ranking-table th, .ranking-table td { padding: 8px; }
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏆 生源地成绩排名</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/origin/stats" class="btn btn-success">📈 统计概览</a>
            <a href="${pageContext.request.contextPath}/origin/distribution" class="btn btn-success">📊 生源地分布</a>
            <a href="${pageContext.request.contextPath}/origin/analysis" class="btn btn-primary">📈 生源地分析</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <c:choose>
            <c:when test="${empty ranking}">
                <div class="no-data">
                    <h3>📭 暂无排名数据</h3>
                    <p>当前没有找到任何生源地排名记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 排名统计摘要 -->
                <div class="stats-summary">
                    <h3>📊 排名统计摘要</h3>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number">${ranking.size()}</div>
                            <div class="stat-label">参与排名地区</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">
                                <fmt:formatNumber value="${ranking[0].avgGPA}" pattern="#.##"/>
                            </div>
                            <div class="stat-label">最高平均GPA</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">
                                <c:set var="totalStudents" value="0"/>
                                <c:forEach var="origin" items="${ranking}">
                                    <c:set var="totalStudents" value="${totalStudents + origin.studentCount}"/>
                                </c:forEach>
                                ${totalStudents}
                            </div>
                            <div class="stat-label">总学生数</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">
                                <c:set var="totalGoodStudents" value="0"/>
                                <c:forEach var="origin" items="${ranking}">
                                    <c:set var="totalGoodStudents" value="${totalGoodStudents + origin.goodStudents}"/>
                                </c:forEach>
                                ${totalGoodStudents}
                            </div>
                            <div class="stat-label">优秀学生总数(GPA≥3.0)</div>
                        </div>
                    </div>
                </div>
                
                <!-- 排名表格 -->
                <table class="ranking-table">
                    <thead>
                        <tr>
                            <th>排名</th>
                            <th>生源地</th>
                            <th>学生人数</th>
                            <th>平均GPA</th>
                            <th>优秀学生数</th>
                            <th>优秀率</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="origin" items="${ranking}" varStatus="status">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${status.index == 0}">
                                            <span class="rank-medal rank-1">🥇</span>${status.index + 1}
                                        </c:when>
                                        <c:when test="${status.index == 1}">
                                            <span class="rank-medal rank-2">🥈</span>${status.index + 1}
                                        </c:when>
                                        <c:when test="${status.index == 2}">
                                            <span class="rank-medal rank-3">🥉</span>${status.index + 1}
                                        </c:when>
                                        <c:otherwise>
                                            <strong>${status.index + 1}</strong>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="origin-name">
                                        <c:out value="${origin.originName}" default="未知"/>
                                    </span>
                                </td>
                                <td>
                                    <span class="student-count">${origin.studentCount} 人</span>
                                </td>
                                <td>
                                    <span class="avg-gpa">
                                        <fmt:formatNumber value="${origin.avgGPA}" pattern="#.##"/>
                                    </span>
                                </td>
                                <td>
                                    <span class="good-students">${origin.goodStudents} 人</span>
                                </td>
                                <td>
                                    <c:set var="excellentRate" value="${origin.studentCount > 0 ? (origin.goodStudents * 100.0 / origin.studentCount) : 0}" />
                                    <fmt:formatNumber value="${excellentRate}" pattern="#.#"/>%
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 