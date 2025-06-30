<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>编辑学生</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; }
        .btn { padding: 12px 24px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; margin-right: 10px; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn:hover { opacity: 0.8; }
        .error { color: #dc3545; margin-top: 5px; font-size: 14px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .readonly { background-color: #f8f9fa; color: #6c757d; }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ 编辑学生信息</h2>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/student/update" method="post">
            <input type="hidden" name="hylSno10" value="${student.hylSno10}">
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylSno10">学号</label>
                    <input type="text" id="hylSno10" value="${student.hylSno10}" class="readonly" readonly>
                </div>
                
                <div class="form-group">
                    <label for="hylSname10">姓名 *</label>
                    <input type="text" id="hylSname10" name="hylSname10" value="${student.hylSname10}" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylSsex10">性别 *</label>
                    <select id="hylSsex10" name="hylSsex10" required>
                        <option value="">请选择性别</option>
                        <option value="男" ${student.hylSsex10 == '男' ? 'selected' : ''}>男</option>
                        <option value="女" ${student.hylSsex10 == '女' ? 'selected' : ''}>女</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="hylSage10">年龄 *</label>
                    <input type="number" id="hylSage10" name="hylSage10" value="${student.hylSage10}" min="16" max="35" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylSbirth10">出生日期 *</label>
                    <input type="date" id="hylSbirth10" name="hylSbirth10" 
                           value="<fmt:formatDate value="${student.hylSbirth10}" pattern="yyyy-MM-dd"/>" required>
                </div>
                
                <div class="form-group">
                    <label for="hylSplace10">籍贯 *</label>
                    <input type="text" id="hylSplace10" name="hylSplace10" value="${student.hylSplace10}" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylSemail10">邮箱</label>
                    <input type="email" id="hylSemail10" name="hylSemail10" value="${student.hylSemail10}">
                </div>
                
                <div class="form-group">
                    <label for="hylSphone10">电话</label>
                    <input type="tel" id="hylSphone10" name="hylSphone10" value="${student.hylSphone10}">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="hylMno10">专业 *</label>
                    <select id="hylMno10" name="hylMno10" required>
                        <option value="">请选择专业</option>
                        <c:forEach var="major" items="${majors}">
                            <option value="${major.hylMno10}" ${student.hylMno10 == major.hylMno10 ? 'selected' : ''}>
                                ${major.hylMno10} - ${major.hylMname10} (${major.facultyName})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="hylAcno10">行政班 *</label>
                    <select id="hylAcno10" name="hylAcno10" required>
                        <option value="">请选择行政班</option>
                        <c:forEach var="aClass" items="${aClasses}">
                            <option value="${aClass.hylAcno10}" ${student.hylAcno10 == aClass.hylAcno10 ? 'selected' : ''}>
                                ${aClass.hylAcno10} - ${aClass.hylAcname10} (${aClass.majorName} ${aClass.hylAcyear10}级)
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn btn-primary">保存修改</button>
                <a href="${pageContext.request.contextPath}/student/view?id=${student.hylSno10}" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</body>
</html> 