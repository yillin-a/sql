<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>编辑课程</title>
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
        input[type="text"], input[type="number"], select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input[type="text"]:focus, input[type="number"]:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        .btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
            margin-right: 15px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
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
        .error {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .required {
            color: #dc3545;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .course-id {
            background-color: #f8f9fa;
            color: #6c757d;
            font-weight: 600;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .form-row { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ 编辑课程</h2>

        <c:if test="${not empty error}">
            <div class="error">
                ❌ ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/course/update" method="post">
            <input type="hidden" name="hylCno10" value="${course.hylCno10}">
            
            <div class="form-group">
                <label for="hylCno10_display">课程编号</label>
                <input type="text" id="hylCno10_display" value="${course.hylCno10}" 
                       class="course-id" readonly>
            </div>

            <div class="form-group">
                <label for="hylCname10">课程名称 <span class="required">*</span></label>
                <input type="text" id="hylCname10" name="hylCname10" 
                       value="${course.hylCname10}" required 
                       placeholder="请输入课程名称">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="hylCcredit10">学分 <span class="required">*</span></label>
                    <input type="number" id="hylCcredit10" name="hylCcredit10" 
                           value="${course.hylCcredit10}" required 
                           step="0.5" min="0.5" max="10" 
                           placeholder="请输入学分">
                </div>
                <div class="form-group">
                    <label for="hylChour10">学时 <span class="required">*</span></label>
                    <input type="number" id="hylChour10" name="hylChour10" 
                           value="${course.hylChour10}" required 
                           min="1" max="200" 
                           placeholder="请输入学时">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="hylCtest10">考核方式 <span class="required">*</span></label>
                    <select id="hylCtest10" name="hylCtest10" required>
                        <option value="">请选择考核方式</option>
                        <option value="考试" ${course.hylCtest10 == '考试' ? 'selected' : ''}>考试</option>
                        <option value="考查" ${course.hylCtest10 == '考查' ? 'selected' : ''}>考查</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="hylCtype10">课程类型 <span class="required">*</span></label>
                    <select id="hylCtype10" name="hylCtype10" required>
                        <option value="">请选择课程类型</option>
                        <option value="必修课" ${course.hylCtype10 == '必修课' ? 'selected' : ''}>必修课</option>
                        <option value="限选课" ${course.hylCtype10 == '限选课' ? 'selected' : ''}>限选课</option>
                        <option value="通识课" ${course.hylCtype10 == '通识课' ? 'selected' : ''}>通识课</option>
                        <option value="实践课" ${course.hylCtype10 == '实践课' ? 'selected' : ''}>实践课</option>
                        <option value="体育课" ${course.hylCtype10 == '体育课' ? 'selected' : ''}>体育课</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="hylCprereq10">先修课程</label>
                <input type="text" id="hylCprereq10" name="hylCprereq10" 
                       value="${course.hylCprereq10}" 
                       placeholder="请输入先修课程（可选）">
            </div>

            <div class="form-group">
                <label for="hylCdesc10">课程描述</label>
                <textarea id="hylCdesc10" name="hylCdesc10" 
                          placeholder="请输入课程描述（可选）">${course.hylCdesc10}</textarea>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-warning">💾 更新课程</button>
                <a href="${pageContext.request.contextPath}/course/list" class="btn btn-secondary">❌ 取消</a>
                <a href="${pageContext.request.contextPath}/course/view?id=${course.hylCno10}" class="btn btn-primary">👁️ 查看详情</a>
            </div>
        </form>
    </div>

    <script>
        // 简单的客户端表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            var courseName = document.getElementById('hylCname10').value.trim();
            var credit = document.getElementById('hylCcredit10').value;
            var hour = document.getElementById('hylChour10').value;
            var testMethod = document.getElementById('hylCtest10').value;
            var courseType = document.getElementById('hylCtype10').value;

            if (!courseName) {
                alert('请输入课程名称');
                e.preventDefault();
                return;
            }

            if (!credit || credit <= 0) {
                alert('请输入有效的学分（大于0）');
                e.preventDefault();
                return;
            }

            if (!hour || hour <= 0) {
                alert('请输入有效的学时（大于0）');
                e.preventDefault();
                return;
            }

            if (!testMethod) {
                alert('请选择考核方式');
                e.preventDefault();
                return;
            }

            if (!courseType) {
                alert('请选择课程类型');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html> 