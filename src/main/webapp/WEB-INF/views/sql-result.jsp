<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>SQL执行结果 - 选课管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #667eea;
        }
        
        .header h1 {
            color: #333;
            font-size: 2em;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #666;
            font-size: 1.1em;
        }
        
        .result-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #667eea;
        }
        
        .result-item.success {
            border-left-color: #28a745;
            background: #d4edda;
        }
        
        .result-item.error {
            border-left-color: #dc3545;
            background: #f8d7da;
        }
        
        .result-item.warning {
            border-left-color: #ffc107;
            background: #fff3cd;
        }
        
        .result-item.verify {
            border-left-color: #17a2b8;
            background: #d1ecf1;
        }
        
        .result-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .result-message {
            color: #666;
            margin-bottom: 10px;
        }
        
        .result-details {
            background: white;
            padding: 10px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 0.9em;
            color: #333;
            margin-top: 10px;
        }
        
        .result-error {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 0.9em;
            margin-top: 10px;
        }
        
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            margin: 0 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .summary {
            background: #e7f3ff;
            border: 1px solid #b3d9ff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .summary h3 {
            color: #0066cc;
            margin-bottom: 15px;
        }
        
        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }
        
        .stat-item {
            text-align: center;
            padding: 15px;
            background: white;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        
        .stat-value {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            
            .actions {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            
            .btn {
                margin: 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔧 SQL执行结果</h1>
            <p>数据库操作执行状态和结果详情</p>
        </div>
        
        <c:if test="${not empty results}">
            <div class="summary">
                <h3>📊 执行摘要</h3>
                <div class="summary-stats">
                    <div class="stat-item">
                        <div class="stat-value">${results.size()}</div>
                        <div class="stat-label">总操作数</div>
                    </div>
                    <c:set var="successCount" value="0" />
                    <c:set var="errorCount" value="0" />
                    <c:forEach var="result" items="${results}">
                        <c:if test="${result.status == '成功' || result.status == '验证'}">
                            <c:set var="successCount" value="${successCount + 1}" />
                        </c:if>
                        <c:if test="${result.status == '错误'}">
                            <c:set var="errorCount" value="${errorCount + 1}" />
                        </c:if>
                    </c:forEach>
                    <div class="stat-item">
                        <div class="stat-value" style="color: #28a745;">${successCount}</div>
                        <div class="stat-label">成功操作</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value" style="color: #dc3545;">${errorCount}</div>
                        <div class="stat-label">失败操作</div>
                    </div>
                </div>
            </div>
            
            <c:forEach var="result" items="${results}">
                <div class="result-item ${result.status == '成功' ? 'success' : result.status == '错误' ? 'error' : result.status == '警告' ? 'warning' : 'verify'}">
                    <div class="result-title">
                        <c:choose>
                            <c:when test="${result.status == '成功'}">✅ ${result.testName}</c:when>
                            <c:when test="${result.status == '错误'}">❌ ${result.testName}</c:when>
                            <c:when test="${result.status == '警告'}">⚠️ ${result.testName}</c:when>
                            <c:when test="${result.status == '验证'}">🔍 ${result.testName}</c:when>
                            <c:otherwise>📋 ${result.testName}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="result-message">${result.message}</div>
                    
                    <c:if test="${not empty result.details}">
                        <div class="result-details">${result.details}</div>
                    </c:if>
                    
                    <c:if test="${not empty result.sql}">
                        <div class="result-details">
                            <strong>SQL语句:</strong><br>
                            ${result.sql}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty result.error}">
                        <div class="result-error">
                            <strong>错误详情:</strong><br>
                            ${result.error}
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </c:if>
        
        <c:if test="${empty results}">
            <div class="result-item">
                <div class="result-title">📋 无执行结果</div>
                <div class="result-message">没有找到任何SQL执行结果</div>
            </div>
        </c:if>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/test/database" class="btn">🔍 数据库测试</a>
            <a href="${pageContext.request.contextPath}/sql/execute?script=user_init" class="btn btn-success">🚀 执行用户初始化</a>
            <a href="${pageContext.request.contextPath}/sql/execute?script=test_connection" class="btn btn-secondary">🔗 测试连接</a>
            <a href="${pageContext.request.contextPath}/login" class="btn">🔐 返回登录</a>
        </div>
    </div>
</body>
</html> 