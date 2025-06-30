<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>错误页面</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-container { 
            max-width: 600px; 
            background-color: white; 
            padding: 40px; 
            border-radius: 15px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            text-align: center;
        }
        .error-icon {
            font-size: 4em;
            margin-bottom: 20px;
        }
        h1 { 
            color: #dc3545; 
            margin-bottom: 20px;
        }
        .error-message {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
            color: #721c24;
        }
        .btn { 
            padding: 12px 24px; 
            text-decoration: none; 
            border-radius: 8px; 
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin: 10px;
        }
        .btn-primary { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
        }
        .btn-secondary { 
            background: #6c757d;
            color: white; 
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .error-details {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            max-height: 200px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1>出错了！</h1>
        
        <div class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:when test="${not empty exception}">
                    ${exception.message}
                </c:when>
                <c:otherwise>
                    发生了一个未知错误，请稍后重试。
                </c:otherwise>
            </c:choose>
        </div>
        
        <c:if test="${not empty exception}">
            <div class="error-details">
                <strong>错误详情:</strong><br>
                ${exception}
            </div>
        </c:if>
        
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
            <a href="javascript:history.back()" class="btn btn-secondary">⬅️ 返回上一页</a>
        </div>
        
        <div style="margin-top: 30px; color: #666; font-size: 14px;">
            <p>如果问题持续存在，请联系系统管理员</p>
            <p>错误时间: ${pageContext.request.getAttribute("javax.servlet.error.timestamp")}</p>
        </div>
    </div>
</body>
</html> 