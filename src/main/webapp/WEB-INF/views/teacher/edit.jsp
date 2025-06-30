<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>编辑个人信息</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container { 
            max-width: 800px; 
            margin: 20px auto; 
            background-color: white; 
            padding: 30px; 
            border-radius: 15px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 { 
            text-align: center; 
            color: #333; 
            border-bottom: 3px solid #667eea; 
            padding-bottom: 15px; 
            margin-bottom: 30px;
        }
        .form-group { 
            margin-bottom: 20px; 
        }
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #555; 
        }
        input[type="text"], input[type="number"], input[type="email"], input[type="tel"], input[type="date"], select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .btn { 
            padding: 12px 24px; 
            text-decoration: none; 
            border-radius: 8px; 
            font-size: 16px; 
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            margin-right: 15px;
        }
        .btn-primary { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
        }
        .btn-secondary { 
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white; 
        }
        .form-actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        .error {
            color: #721c24;
            background-color: #f8d7da;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .readonly {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ 编辑个人信息</h2>
        
        <c:if test="${not empty error}">
            <div class="error">
                <strong>错误:</strong> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/teacher/update" method="post">
            <input type="hidden" name="id" value="${teacher.hylTno10}">
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylTno10">工号</label>
                    <input type="text" id="hylTno10" value="${teacher.hylTno10}" class="readonly" readonly>
                </div>
                <div class="form-group">
                    <label for="hylTname10">姓名</label>
                    <input type="text" id="hylTname10" name="hylTname10" value="${teacher.hylTname10}" required>
                </div>
            </div>

            <div class="form-row">
                 <div class="form-group">
                    <label for="hylTsex10">性别</label>
                    <select id="hylTsex10" name="hylTsex10" required>
                        <option value="男" ${teacher.hylTsex10 == '男' ? 'selected' : ''}>男</option>
                        <option value="女" ${teacher.hylTsex10 == '女' ? 'selected' : ''}>女</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="hylTage10">年龄</label>
                    <input type="number" id="hylTage10" name="hylTage10" value="${teacher.hylTage10}" min="22" max="70" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="hylTtitle10">职称</label>
                    <input type="text" id="hylTtitle10" name="hylTtitle10" value="${teacher.hylTtitle10}" required>
                </div>
                <div class="form-group">
                    <label for="hylTstatus10">状态</label>
                     <input type="text" id="hylTstatus10" name="hylTstatus10" value="${teacher.hylTstatus10}" class="readonly" readonly>
                </div>
            </div>
            
            <div class="form-group">
                <label for="hylFno10">所属学院</label>
                <input type="text" id="hylFno10" name="hylFno10" value="${teacher.facultyName}" class="readonly" readonly>
            </div>
            
             <div class="form-row">
                <div class="form-group">
                    <label for="hylTemail10">邮箱</label>
                    <input type="email" id="hylTemail10" name="hylTemail10" value="${teacher.hylTemail10}">
                </div>
                 <div class="form-group">
                    <label for="hylTphone10">电话</label>
                    <input type="tel" id="hylTphone10" name="hylTphone10" value="${teacher.hylTphone10}">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">💾 保存更改</button>
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-secondary">返回首页</a>
            </div>
        </form>
    </div>
    
    <script>
        // 年龄和出生日期的联动验证
        document.getElementById('hylTbirth10').addEventListener('change', function() {
            const birthDate = new Date(this.value);
            const today = new Date();
            const age = today.getFullYear() - birthDate.getFullYear();
            const monthDiff = today.getMonth() - birthDate.getMonth();
            
            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            
            document.getElementById('hylTage10').value = age;
        });
        
        document.getElementById('hylTage10').addEventListener('change', function() {
            const age = parseInt(this.value);
            if (age < 22 || age > 70) {
                alert('教师年龄必须在22-70岁之间');
                this.focus();
            }
        });
        
        // 邮箱格式验证
        document.getElementById('hylTemail10').addEventListener('blur', function() {
            const email = this.value;
            if (email && !email.includes('@')) {
                alert('请输入有效的邮箱地址');
                this.focus();
            }
        });
    </script>
</body>
</html> 