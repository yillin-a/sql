<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学生详细排名</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background-color: #f5f5f5; 
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            background-color: white; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        h2 { 
            color: #333; 
            border-bottom: 2px solid #007bff; 
            padding-bottom: 10px; 
            margin-bottom: 20px;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
        }
        th, td { 
            padding: 12px; 
            text-align: left; 
            border-bottom: 1px solid #ddd; 
        }
        th { 
            background-color: #f8f9fa; 
            font-weight: bold; 
            color: #333; 
        }
        tr:hover { 
            background-color: #f5f5f5; 
        }
        .rank-1 { 
            background-color: #fff3cd; 
            font-weight: bold;
        }
        .rank-2 { 
            background-color: #f8f9fa; 
        }
        .rank-3 { 
            background-color: #fff3cd; 
        }
        .btn { 
            padding: 8px 16px; 
            text-decoration: none; 
            border-radius: 4px; 
            font-size: 14px; 
            margin-right: 5px; 
        }
        .btn-primary { 
            background-color: #007bff; 
            color: white; 
        }
        .btn-success { 
            background-color: #28a745; 
            color: white; 
        }
        .btn-info { 
            background-color: #17a2b8; 
            color: white; 
        }
        .gpa-excellent { 
            color: #28a745; 
            font-weight: bold; 
        }
        .gpa-good { 
            color: #007bff; 
            font-weight: bold; 
        }
        .gpa-average { 
            color: #ffc107; 
            font-weight: bold; 
        }
        .gpa-poor { 
            color: #dc3545; 
            font-weight: bold; 
        }
        .nav-buttons { 
            margin-bottom: 20px; 
        }
        .nav-buttons .btn { 
            margin-right: 10px; 
        }
        .stats-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        .stat-item {
            text-align: center;
            padding: 10px;
            background-color: white;
            border-radius: 5px;
            border: 1px solid #dee2e6;
        }
        .stat-number {
            font-size: 1.5em;
            font-weight: bold;
            color: #007bff;
        }
        .stat-label {
            font-size: 0.9em;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📈 学生详细排名</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/student/scores" class="btn btn-primary">📊 成绩排名</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-info">👥 学生列表</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-success">🏠 返回首页</a>
        </div>
        
        <!-- 统计摘要 -->
        <div class="stats-summary">
            <h3>📊 排名统计</h3>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number">${rankings.size()}</div>
                    <div class="stat-label">参与排名学生</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <c:set var="excellentCount" value="0"/>
                        <c:forEach var="ranking" items="${rankings}">
                            <c:if test="${ranking.gpa >= 4.0}">
                                <c:set var="excellentCount" value="${excellentCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${excellentCount}
                    </div>
                    <div class="stat-label">优秀学生(GPA≥4.0)</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <c:set var="goodCount" value="0"/>
                        <c:forEach var="ranking" items="${rankings}">
                            <c:if test="${ranking.gpa >= 3.0 && ranking.gpa < 4.0}">
                                <c:set var="goodCount" value="${goodCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${goodCount}
                    </div>
                    <div class="stat-label">良好学生(GPA≥3.0)</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <c:set var="totalScore" value="0"/>
                        <c:set var="studentCount" value="${rankings.size()}"/>
                        <c:forEach var="ranking" items="${rankings}">
                            <c:set var="totalScore" value="${totalScore + ranking.avgScore}"/>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${studentCount > 0}">
                                <fmt:formatNumber value="${totalScore / studentCount}" pattern="#.##"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="0" pattern="#.##"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">平均成绩</div>
                </div>
            </div>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>排名</th>
                    <th>学号</th>
                    <th>姓名</th>
                    <th>专业</th>
                    <th>班级</th>
                    <th>GPA</th>
                    <th>专业排名</th>
                    <th>课程数</th>
                    <th>平均分</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ranking" items="${rankings}" varStatus="status">
                    <tr class="<c:if test='${status.index == 0}'>rank-1</c:if><c:if test='${status.index == 1}'>rank-2</c:if><c:if test='${status.index == 2}'>rank-3</c:if>">
                        <td>${status.index + 1}</td>
                        <td>${ranking.studentId}</td>
                        <td>${ranking.studentName}</td>
                        <td>${ranking.majorName}</td>
                        <td>${ranking.className}</td>
                        <td class="<c:choose><c:when test="${ranking.gpa >= 4.0}">gpa-excellent</c:when><c:when test="${ranking.gpa >= 3.0}">gpa-good</c:when><c:when test="${ranking.gpa >= 2.0}">gpa-average</c:when><c:otherwise>gpa-poor</c:otherwise></c:choose>">${ranking.gpa}</td>
                        <td>第 ${ranking.rank} 名</td>
                        <td>${ranking.courseCount}</td>
                        <td><fmt:formatNumber value="${ranking.avgScore}" pattern="#.##"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/student/view?id=${ranking.studentId}" class="btn btn-primary">详情</a>
                            <a href="${pageContext.request.contextPath}/student/detail-scores?id=${ranking.studentId}" class="btn btn-success">成绩</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/student/scores" class="btn btn-primary">返回成绩排名</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-info">返回学生列表</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-success">返回首页</a>
        </div>
    </div>
</body>
</html> 