<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>添加教师</title>
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
        .form-group label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #333; 
        }
        .form-group input, .form-group select { 
            width: 100%; 
            padding: 12px; 
            border: 2px solid #e9ecef; 
            border-radius: 8px; 
            font-size: 14px; 
            box-sizing: border-box;
        }
        .form-group input:focus, .form-group select:focus {
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
            font-size: 14px; 
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn-primary { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        .error-message {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .required {
            color: #dc3545;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>➕ 添加教师</h2>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                <strong>❌ 错误：</strong> ${error}
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/teacher/add" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="hylTname10">姓名 <span class="required">*</span></label>
                    <input type="text" id="hylTname10" name="hylTname10" 
                           value="${teacher.hylTname10}" required>
                </div>
                <div class="form-group">
                    <label for="hylTsex10">性别 <span class="required">*</span></label>
                    <select id="hylTsex10" name="hylTsex10" required>
                        <option value="">请选择性别</option>
                        <option value="男" ${teacher.hylTsex10 == '男' ? 'selected' : ''}>男</option>
                        <option value="女" ${teacher.hylTsex10 == '女' ? 'selected' : ''}>女</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylTbirth10">出生日期</label>
                    <input type="date" id="hylTbirth10" name="hylTbirth10" 
                           value="${teacher.hylTbirth10}">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylTtitle10">职称 <span class="required">*</span></label>
                    <select id="hylTtitle10" name="hylTtitle10" required>
                        <option value="">请选择职称</option>
                        <option value="教授" ${teacher.hylTtitle10 == '教授' ? 'selected' : ''}>教授</option>
                        <option value="副教授" ${teacher.hylTtitle10 == '副教授' ? 'selected' : ''}>副教授</option>
                        <option value="讲师" ${teacher.hylTtitle10 == '讲师' ? 'selected' : ''}>讲师</option>
                        <option value="助教" ${teacher.hylTtitle10 == '助教' ? 'selected' : ''}>助教</option>
                        <option value="无" ${teacher.hylTtitle10 == '无' ? 'selected' : ''}>无</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="hylFno10">所属学院</label>
                    <select id="hylFno10" name="hylFno10">
                        <option value="">请选择学院</option>
                        <c:forEach var="faculty" items="${faculties}">
                            <option value="${faculty.facultyId}" 
                                    ${teacher.hylFno10 == faculty.facultyId ? 'selected' : ''}>
                                ${faculty.facultyName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylTemail10">邮箱</label>
                    <input type="email" id="hylTemail10" name="hylTemail10" 
                           value="${teacher.hylTemail10}">
                </div>
                <div class="form-group">
                    <label for="hylTphone10">电话</label>
                    <input type="tel" id="hylTphone10" name="hylTphone10" 
                           value="${teacher.hylTphone10}">
                </div>
            </div>
            
            <div class="form-group">
                <label for="hylToffice10">办公室</label>
                <input type="text" id="hylToffice10" name="hylToffice10" 
                       value="${teacher.hylToffice10}">
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn btn-primary">💾 保存教师</button>
                <a href="${pageContext.request.contextPath}/teacher/list" class="btn btn-secondary">❌ 取消</a>
            </div>
        </form>
    </div>
</body>
</html> 