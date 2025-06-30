<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>系统测试</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container { 
            max-width: 800px; 
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
        .test-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            background-color: #f8f9fa;
        }
        .test-section h3 {
            color: #333;
            margin-bottom: 15px;
        }
        .btn { 
            padding: 12px 24px; 
            text-decoration: none; 
            border-radius: 8px; 
            font-size: 14px; 
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
            margin-right: 10px;
            margin-bottom: 10px;
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
        .status {
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
            font-weight: 600;
        }
        .status.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔧 系统功能测试</h2>
        
        <div class="test-section">
            <h3>📊 数据库连接测试</h3>
            <a href="${pageContext.request.contextPath}/database/test" class="btn btn-primary">🔗 测试数据库连接</a>
            <a href="${pageContext.request.contextPath}/database/init" class="btn btn-info">🗄️ 初始化数据库</a>
        </div>
        
        <div class="test-section">
            <h3>👨‍🏫 教师管理测试</h3>
            <a href="${pageContext.request.contextPath}/teacher/list" class="btn btn-success">📋 教师列表</a>
            <a href="${pageContext.request.contextPath}/teacher/add" class="btn btn-primary">➕ 添加教师</a>
        </div>
        
        <div class="test-section">
            <h3>👨‍🎓 学生管理测试</h3>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-success">📋 学生列表</a>
            <a href="${pageContext.request.contextPath}/student/scores" class="btn btn-info">📊 学生成绩</a>
        </div>
        
        <div class="test-section">
            <h3>📈 成绩统计测试</h3>
            <a href="${pageContext.request.contextPath}/score/stats" class="btn btn-info">📊 成绩统计</a>
        </div>
        
        <div class="test-section">
            <h3>🌍 生源地统计测试</h3>
            <a href="${pageContext.request.contextPath}/origin/stats" class="btn btn-info">📊 生源地统计</a>
            <a href="${pageContext.request.contextPath}/origin/distribution" class="btn btn-success">📈 生源地分布</a>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <!-- 测试结果显示 -->
        <c:if test="${not empty result}">
            <div class="test-section">
                <h3>📋 测试结果</h3>
                <c:choose>
                    <c:when test="${result.success}">
                        <div class="status success">
                            ✅ 测试成功
                        </div>
                        <c:if test="${not empty result.message}">
                            <p><strong>消息：</strong> ${result.message}</p>
                        </c:if>
                        <c:if test="${not empty result.databaseProductName}">
                            <p><strong>数据库：</strong> ${result.databaseProductName} ${result.databaseProductVersion}</p>
                            <p><strong>驱动：</strong> ${result.driverName} ${result.driverVersion}</p>
                        </c:if>
                        <c:if test="${not empty result.tables}">
                            <p><strong>数据库表：</strong></p>
                            <ul>
                                <c:forEach var="table" items="${result.tables}">
                                    <li>${table}</li>
                                </c:forEach>
                            </ul>
                        </c:if>
                        <c:if test="${not empty result.faculties}">
                            <p><strong>学院列表：</strong></p>
                            <ul>
                                <c:forEach var="faculty" items="${result.faculties}">
                                    <li>${faculty.facultyName} (编号: ${faculty.facultyId})</li>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="status error">
                            ❌ 测试失败
                        </div>
                        <p><strong>错误：</strong> ${result.error}</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <h3>生源地统计测试</h3>
        <c:choose>
            <c:when test="${not empty originStats}">
                <p><strong>总学生数：</strong>${originStats.totalStudents}</p>
                <p><strong>生源地数量：</strong>${originStats.totalOrigins}</p>
                <p><strong>平均每地学生数：</strong>${originStats.avgStudentsPerOrigin}</p>
                <p><strong>最热门生源地：</strong>${originStats.mostPopularOrigin}</p>
            </c:when>
            <c:otherwise>
                <p>生源地统计数据为空</p>
            </c:otherwise>
        </c:choose>
        
        <h3>生源地分布测试</h3>
        <c:choose>
            <c:when test="${not empty originDistribution}">
                <p><strong>高密度地区（≥10人）：</strong>${originDistribution.highDensity}</p>
                <p><strong>中密度地区（5-9人）：</strong>${originDistribution.mediumDensity}</p>
                <p><strong>低密度地区（2-4人）：</strong>${originDistribution.lowDensity}</p>
                <p><strong>单学生地区（1人）：</strong>${originDistribution.singleStudent}</p>
            </c:when>
            <c:otherwise>
                <p>生源地分布数据为空</p>
            </c:otherwise>
        </c:choose>
        
        <h3>热门生源地TOP 10</h3>
        <c:choose>
            <c:when test="${not empty topOrigins}">
                <ul>
                    <c:forEach var="origin" items="${topOrigins}">
                        <li>${origin.originName}: ${origin.studentCount} 人</li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>热门生源地数据为空</p>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html> 