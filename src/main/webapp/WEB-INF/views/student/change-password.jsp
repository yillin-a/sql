<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>修改密码 - 学生</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .password-form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            padding: 40px;
            max-width: 500px;
            width: 100%;
            margin: 0 auto;
        }
        .form-title {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 1.8em;
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.2s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
        }
        .strength-weak { color: #dc3545; }
        .strength-medium { color: #ffc107; }
        .strength-strong { color: #28a745; }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
        }
        .password-field {
            position: relative;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="password-form-container">
            <div class="form-title">
                <i class="fas fa-user-graduate text-primary"></i> 学生密码修改
            </div>
            
            <!-- 消息提示 -->
            <c:if test="${not empty message}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>
            
            <!-- 密码修改表单 -->
            <form action="${pageContext.request.contextPath}/password/change" method="post" id="passwordForm">
                <div class="form-group">
                    <label for="currentPassword" class="form-label">
                        <i class="fas fa-key"></i> 当前密码
                    </label>
                    <div class="password-field">
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" 
                               placeholder="请输入当前密码" required>
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('currentPassword')"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="newPassword" class="form-label">
                        <i class="fas fa-lock"></i> 新密码
                    </label>
                    <div class="password-field">
                        <input type="password" class="form-control" id="newPassword" name="newPassword" 
                               placeholder="请输入新密码" required onkeyup="checkPasswordStrength()">
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('newPassword')"></i>
                    </div>
                    <div class="password-strength" id="passwordStrength"></div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">
                        <i class="fas fa-check-circle"></i> 确认新密码
                    </label>
                    <div class="password-field">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                               placeholder="请再次输入新密码" required onkeyup="checkPasswordMatch()">
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('confirmPassword')"></i>
                    </div>
                    <div class="password-strength" id="passwordMatch"></div>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-save"></i> 修改密码
                    </button>
                </div>
            </form>
            
            <!-- 密码要求提示 -->
            <div class="alert alert-info">
                <h6><i class="fas fa-info-circle"></i> 密码要求：</h6>
                <ul class="mb-0">
                    <li>至少6位字符</li>
                    <li>必须包含字母和数字</li>
                    <li>建议使用大小写字母、数字和特殊字符的组合</li>
                </ul>
            </div>
            
            <!-- 返回链接 -->
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/student/dashboard">
                    <i class="fas fa-arrow-left"></i> 返回学生面板
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 切换密码显示/隐藏
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.nextElementSibling;
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // 检查密码强度
        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            const strengthDiv = document.getElementById('passwordStrength');
            
            if (password.length === 0) {
                strengthDiv.innerHTML = '';
                return;
            }
            
            let strength = 0;
            let feedback = [];
            
            if (password.length >= 6) strength++;
            else feedback.push('至少6位');
            
            if (/[a-zA-Z]/.test(password)) strength++;
            else feedback.push('包含字母');
            
            if (/\d/.test(password)) strength++;
            else feedback.push('包含数字');
            
            if (/[A-Z]/.test(password)) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[!@#$%^&*]/.test(password)) strength++;
            
            let strengthText = '';
            let strengthClass = '';
            
            if (strength <= 2) {
                strengthText = '弱';
                strengthClass = 'strength-weak';
            } else if (strength <= 4) {
                strengthText = '中等';
                strengthClass = 'strength-medium';
            } else {
                strengthText = '强';
                strengthClass = 'strength-strong';
            }
            
            strengthDiv.innerHTML = `<span class="${strengthClass}">密码强度：${strengthText}</span>`;
            if (feedback.length > 0) {
                strengthDiv.innerHTML += `<br><small class="text-muted">需要：${feedback.join('、')}</small>`;
            }
        }
        
        // 检查密码匹配
        function checkPasswordMatch() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword.length === 0) {
                matchDiv.innerHTML = '';
                return;
            }
            
            if (newPassword === confirmPassword) {
                matchDiv.innerHTML = '<span class="strength-strong">✓ 密码匹配</span>';
            } else {
                matchDiv.innerHTML = '<span class="strength-weak">✗ 密码不匹配</span>';
            }
        }
        
        // 表单验证
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('新密码与确认密码不匹配！');
                return false;
            }
            
            if (newPassword.length < 6 || !/[a-zA-Z]/.test(newPassword) || !/\d/.test(newPassword)) {
                e.preventDefault();
                alert('新密码格式不正确！密码至少6位，必须包含字母和数字。');
                return false;
            }
        });
    </script>
</body>
</html> 