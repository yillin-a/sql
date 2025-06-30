<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>个人信息修改 - 教师管理系统</title>
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
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h2 {
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 15px;
            margin-bottom: 10px;
        }
        
        .header .subtitle {
            color: #666;
            font-size: 14px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding-left: 10px;
            border-left: 4px solid #667eea;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group input:disabled {
            background-color: #f5f5f5;
            color: #666;
            cursor: not-allowed;
        }
        
        .editable {
            border-color: #28a745 !important;
        }
        
        .editable:focus {
            border-color: #20c997 !important;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        
        .readonly-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            margin-bottom: 20px;
        }
        
        .readonly-info h4 {
            color: #495057;
            margin-bottom: 10px;
        }
        
        .readonly-info p {
            color: #6c757d;
            margin: 5px 0;
        }
        
        .buttons {
            text-align: center;
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        
        .btn-secondary:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>👤 个人信息修改</h2>
            <p class="subtitle">您可以修改邮箱和电话信息，其他信息由管理员统一管理</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">❌ ${error}</div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        
        <!-- 不可修改的基本信息 -->
        <div class="form-section">
            <div class="section-title">📋 基本信息（不可修改）</div>
            <div class="readonly-info">
                <div class="form-grid">
                    <div>
                        <h4>工号</h4>
                        <p>${teacher.hylTno10}</p>
                    </div>
                    <div>
                        <h4>姓名</h4>
                        <p>${teacher.hylTname10}</p>
                    </div>
                    <div>
                        <h4>性别</h4>
                        <p>${teacher.hylTsex10}</p>
                    </div>
                    <div>
                        <h4>年龄</h4>
                        <p>${teacher.hylTage10} 岁</p>
                    </div>
                    <div>
                        <h4>职称</h4>
                        <p>${teacher.hylTtitle10}</p>
                    </div>
                    <div>
                        <h4>状态</h4>
                        <p>${teacher.hylTstatus10}</p>
                    </div>
                    <c:if test="${not empty teacher.hylTbirth10}">
                        <div>
                            <h4>出生日期</h4>
                            <p><fmt:formatDate value="${teacher.hylTbirth10}" pattern="yyyy年MM月dd日"/></p>
                        </div>
                    </c:if>
                    <c:if test="${not empty teacher.hylTjoindate10}">
                        <div>
                            <h4>入职时间</h4>
                            <p><fmt:formatDate value="${teacher.hylTjoindate10}" pattern="yyyy年MM月dd日"/></p>
                        </div>
                    </c:if>
                    <c:if test="${not empty teacher.facultyName}">
                        <div>
                            <h4>所属学院</h4>
                            <p>${teacher.facultyName}</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty teacher.hylToffice10}">
                        <div>
                            <h4>办公室</h4>
                            <p>${teacher.hylToffice10}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- 可修改的联系信息 -->
        <form action="${pageContext.request.contextPath}/teacher/profile" method="post">
            <div class="form-section">
                <div class="section-title">📞 联系信息（可修改）</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="hylTemail10">邮箱地址</label>
                        <input type="email" id="hylTemail10" name="hylTemail10" 
                               value="${teacher.hylTemail10}" 
                               class="editable"
                               placeholder="请输入邮箱地址" 
                               maxlength="100">
                        <div class="help-text">用于接收重要通知，请确保邮箱地址正确</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="hylTphone10">手机号码</label>
                        <input type="tel" id="hylTphone10" name="hylTphone10" 
                               value="${teacher.hylTphone10}" 
                               class="editable"
                               placeholder="请输入手机号码" 
                               maxlength="20" 
                               pattern="[0-9]{11}">
                        <div class="help-text">11位手机号码，用于紧急联系</div>
                    </div>
                </div>
            </div>
            
            <div class="buttons">
                <button type="submit" class="btn btn-primary">💾 保存修改</button>
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-secondary">🔙 返回首页</a>
            </div>
        </form>
    </div>
    
    <script>
        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            const email = document.getElementById('hylTemail10').value.trim();
            const phone = document.getElementById('hylTphone10').value.trim();
            
            // 验证邮箱格式（如果填写）
            if (email && !email.includes('@')) {
                alert('邮箱格式不正确！');
                e.preventDefault();
                return;
            }
            
            // 验证手机号格式（如果填写）
            if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
                alert('手机号格式不正确！请输入11位有效手机号');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html> 