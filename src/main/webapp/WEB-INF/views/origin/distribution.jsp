<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>生源地分布</title>
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
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        th, td { 
            padding: 15px; 
            text-align: left; 
            border-bottom: 1px solid #e9ecef; 
        }
        th { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
        }
        tr:hover { 
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 5px 0; text-align: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 生源地分布</h2>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/origin/stats" class="btn btn-success">📈 统计概览</a>
            <a href="${pageContext.request.contextPath}/origin/ranking" class="btn btn-info">🏆 生源地排名</a>
            <a href="${pageContext.request.contextPath}/origin/analysis" class="btn btn-primary">📈 生源地分析</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <c:choose>
            <c:when test="${empty distribution}">
                <div class="no-data">
                    <h3>📭 暂无生源地数据</h3>
                    <p>当前没有找到任何生源地记录。</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>排名</th>
                            <th>生源地</th>
                            <th>学生人数</th>
                            <th>占比</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="origin" items="${distribution}" varStatus="status">
                            <tr>
                                <td><strong>${status.index + 1}</strong></td>
                                <td>
                                    <span style="font-weight: 600; color: #333;">
                                        <c:out value="${origin.originName}" default="未知"/>
                                    </span>
                                </td>
                                <td>
                                    <span style="color: #667eea; font-weight: bold;">
                                        ${origin.studentCount} 人
                                    </span>
                                </td>
                                <td>
                                    <c:set var="percentage" value="${origin.studentCount * 100.0 / distribution.size()}" />
                                    <fmt:formatNumber value="${percentage}" pattern="#.##"/>%
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