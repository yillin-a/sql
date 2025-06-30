<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>添加选课记录</title>
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }
        input[type="text"]:focus, input[type="number"]:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            margin-right: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .form-actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        .nav-buttons {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .required {
            color: #dc3545;
        }
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .form-row { flex-direction: column; }
            .btn { display: block; margin: 10px 0; text-align: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>➕ 添加选课记录</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-primary">📚 选课记录</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-warning">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-success">🏠 返回首页</a>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">
                <strong>❌ 错误：</strong> ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success-message">
                <strong>✅ 成功：</strong> ${success}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/enrollment/add" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="hylSno10">学号 <span class="required">*</span></label>
                    <input type="number" id="hylSno10" name="hylSno10" 
                           value="<c:out value='${enrollment.hylSno10}'/>" required 
                           placeholder="请输入学号">
                    <div class="help-text">请输入有效的学生学号</div>
                </div>
                <div class="form-group">
                    <label for="hylTcno10">教学班编号 <span class="required">*</span></label>
                    <input type="number" id="hylTcno10" name="hylTcno10" 
                           value="<c:out value='${enrollment.hylTcno10}'/>" required 
                           placeholder="请输入教学班编号">
                    <div class="help-text">请输入有效的教学班编号</div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="hylEscore10">成绩</label>
                    <input type="number" id="hylEscore10" name="hylEscore10" 
                           value="<c:out value='${enrollment.hylEscore10}'/>" 
                           min="0" max="100" 
                           placeholder="请输入成绩（0-100）">
                    <div class="help-text">成绩范围：0-100，可选填</div>
                </div>
                <div class="form-group">
                    <label for="hylStatus10">状态</label>
                    <select id="hylStatus10" name="hylStatus10">
                        <option value="">请选择状态</option>
                        <option value="在读" <c:if test="${not empty enrollment and enrollment.hylStatus10 == '在读'}">selected</c:if>>在读</option>
                        <option value="退学" <c:if test="${not empty enrollment and enrollment.hylStatus10 == '退学'}">selected</c:if>>退学</option>
                        <option value="休学" <c:if test="${not empty enrollment and enrollment.hylStatus10 == '休学'}">selected</c:if>>休学</option>
                        <option value="毕业" <c:if test="${not empty enrollment and enrollment.hylStatus10 == '毕业'}">selected</c:if>>毕业</option>
                    </select>
                    <div class="help-text">选择学生的当前状态</div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-success">💾 保存选课记录</button>
                <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-primary">📋 返回列表</a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-warning">🏠 返回首页</a>
            </div>
        </form>

        <div style="margin-top: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 10px;">
            <h4>📝 填写说明：</h4>
            <ul style="margin: 10px 0; padding-left: 20px;">
                <li><strong>学号：</strong>必须输入有效的学生学号，该学生必须已存在于系统中</li>
                <li><strong>教学班编号：</strong>必须输入有效的教学班编号，该教学班必须已存在于系统中</li>
                <li><strong>成绩：</strong>可选填，范围0-100分，如果暂时没有成绩可以留空</li>
                <li><strong>状态：</strong>选择学生的当前学习状态，默认为"在读"</li>
            </ul>
        </div>
    </div>

    <script>
        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            const studentId = document.getElementById('hylSno10').value;
            const teachingClassId = document.getElementById('hylTcno10').value;
            const score = document.getElementById('hylEscore10').value;
            
            if (!studentId || !teachingClassId) {
                alert('学号和教学班编号不能为空！');
                e.preventDefault();
                return;
            }
            
            if (score && (score < 0 || score > 100)) {
                alert('成绩必须在0-100之间！');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html> 