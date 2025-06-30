<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>选课管理系统 - 用户登录</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        
        .logo {
            font-size: 2.5em;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .title {
            color: #333;
            font-size: 1.8em;
            margin-bottom: 30px;
            font-weight: 600;
        }
        
        .subtitle {
            color: #666;
            font-size: 1em;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 0.9em;
        }
        
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #f8f9fa;
        }
        
        input[type="text"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .login-btn:active {
            transform: translateY(0);
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            font-size: 14px;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            font-size: 14px;
        }
        
        .info-box {
            background-color: #e7f3ff;
            border: 1px solid #b3d9ff;
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
            text-align: left;
        }
        
        .info-box h4 {
            color: #0066cc;
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .info-box ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .info-box li {
            color: #333;
            font-size: 12px;
            margin-bottom: 5px;
            padding-left: 15px;
            position: relative;
        }
        
        .info-box li:before {
            content: "•";
            color: #667eea;
            font-weight: bold;
            position: absolute;
            left: 0;
        }
        
        .user-type-info {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .user-type {
            text-align: center;
            flex: 1;
        }
        
        .user-type-icon {
            font-size: 2em;
            margin-bottom: 5px;
        }
        
        .user-type-label {
            font-size: 12px;
            color: #666;
            font-weight: 600;
        }
        
        .user-type-range {
            font-size: 10px;
            color: #999;
        }
        
        @media (max-width: 480px) {
            .login-container {
                margin: 20px;
                padding: 30px 20px;
            }
            
            .title {
                font-size: 1.5em;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">🎓</div>
        <h1 class="title">选课管理系统</h1>
        <p class="subtitle">请使用您的用户号码和密码登录</p>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                <strong>❌ 登录失败：</strong> ${error}
            </div>
        </c:if>
        
        <c:if test="${param.message == 'password_changed'}">
            <div class="success-message">
                <strong>✅ 密码修改成功：</strong> 请使用新密码登录系统
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="uno">用户号码</label>
                <input type="text" id="uno" name="uno" 
                       value="<c:out value='${uno}'/>" 
                       placeholder="请输入您的用户号码" required>
            </div>
            
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" 
                       placeholder="请输入您的密码" required>
            </div>
            
            <button type="submit" class="login-btn">🔐 登录系统</button>
        </form>
        
        <div class="info-box">
            <h4>📋 登录说明：</h4>
            <ul>
                <li>默认密码与您的用户号码相同</li>
                <li>学生用户号码范围：600001-699999</li>
                <li>教师用户号码范围：700001-799999</li>
                <li>管理员用户号码范围：100001-199999</li>
            </ul>
        </div>
        
        <div class="user-type-info">
            <div class="user-type">
                <div class="user-type-icon">👨‍🎓</div>
                <div class="user-type-label">学生</div>
                <div class="user-type-range">600001-699999</div>
            </div>
            <div class="user-type">
                <div class="user-type-icon">👨‍🏫</div>
                <div class="user-type-label">教师</div>
                <div class="user-type-range">700001-799999</div>
            </div>
            <div class="user-type">
                <div class="user-type-icon">👨‍💼</div>
                <div class="user-type-label">管理员</div>
                <div class="user-type-range">100001-199999</div>
            </div>
        </div>
    </div>
    
    <script>
        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!username || !password) {
                alert('请填写完整的登录信息！');
                e.preventDefault();
                return;
            }
            
            // 验证用户号码格式
            const userId = parseInt(username);
            if (isNaN(userId) || userId < 100001 || userId > 799999) {
                alert('请输入有效的用户号码！\n学生：600001-699999\n教师：700001-799999\n管理员：100001-199999');
                e.preventDefault();
                return;
            }
        });
        
        // 自动聚焦到用户名输入框
        document.getElementById('username').focus();
    </script>
</body>
</html> 