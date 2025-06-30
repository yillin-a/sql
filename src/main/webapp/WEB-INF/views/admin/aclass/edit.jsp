<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑行政班 - 选课管理系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #007bff;
        }
        .header h1 {
            color: #333;
            margin: 0;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #333;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }
        .required {
            color: #dc3545;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .form-actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
        .alert {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .breadcrumb {
            margin-bottom: 20px;
        }
        .breadcrumb a {
            color: #007bff;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        .current-info {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .current-info h3 {
            margin: 0 0 10px 0;
            color: #495057;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        .info-label {
            font-weight: 600;
        }
        .warning-text {
            color: #dc3545;
            font-size: 12px;
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/home">管理员控制台</a> > 
        <a href="${pageContext.request.contextPath}/admin/aclass/list">行政班管理</a> > 
        <a href="${pageContext.request.contextPath}/admin/aclass/view?id=${aClass.hylAcno10}">行政班详情</a> > 
        编辑行政班
    </div>
    
    <div class="header">
        <h1>✏️ 编辑行政班</h1>
    </div>

    <!-- 当前信息显示 -->
    <div class="current-info">
        <h3>📋 当前行政班信息</h3>
        <div class="info-item">
            <span class="info-label">行政班编号:</span>
            <span>${aClass.hylAcno10}</span>
        </div>
        <div class="info-item">
            <span class="info-label">当前学生人数:</span>
            <span><strong>${aClass.currentStudents}人</strong></span>
        </div>
        <div class="info-item">
            <span class="info-label">所属专业:</span>
            <span>${aClass.majorName} (${aClass.facultyName})</span>
        </div>
        <c:if test="${aClass.currentStudents > 0}">
            <div style="margin-top: 10px; color: #856404; background-color: #fff3cd; padding: 8px; border-radius: 4px;">
                ⚠️ 注意：该班级已有学生，修改信息时请谨慎操作
            </div>
        </c:if>
    </div>

    <!-- 错误消息 -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            ${error}
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/admin/aclass/update" onsubmit="return validateForm()">
        <input type="hidden" name="hylAcno10" value="${aClass.hylAcno10}">
        
        <div class="form-group">
            <label for="hylAcname10">行政班名称 <span class="required">*</span></label>
            <input type="text" id="hylAcname10" name="hylAcname10" 
                   value="${aClass.hylAcname10}" required maxlength="50"
                   placeholder="例如：计算机科学与技术1班">
            <div class="help-text">行政班名称，长度不超过50个字符</div>
        </div>

        <div class="form-group">
            <label for="hylAcyear10">入学年份 <span class="required">*</span></label>
            <input type="number" id="hylAcyear10" name="hylAcyear10" 
                   value="${aClass.hylAcyear10}" required min="2020" max="2030"
                   placeholder="例如：2024">
            <div class="help-text">学生入学年份</div>
            <c:if test="${aClass.currentStudents > 0}">
                <div class="warning-text">⚠️ 修改入学年份可能影响现有学生的年级计算</div>
            </c:if>
        </div>

        <div class="form-group">
            <label for="hylMno10">所属专业 <span class="required">*</span></label>
            <select id="hylMno10" name="hylMno10" required>
                <option value="">请选择专业</option>
                <c:forEach var="major" items="${majors}">
                    <option value="${major.hylMno10}" 
                            ${aClass.hylMno10 == major.hylMno10 ? 'selected' : ''}>
                        ${major.hylMname10} (${major.facultyName})
                    </option>
                </c:forEach>
            </select>
            <div class="help-text">选择行政班所属的专业</div>
            <c:if test="${aClass.currentStudents > 0}">
                <div class="warning-text">⚠️ 修改专业可能影响现有学生的专业归属</div>
            </c:if>
        </div>

        <div class="form-group">
            <label for="hylAcmaxstu10">班级人数上限 <span class="required">*</span></label>
            <input type="number" id="hylAcmaxstu10" name="hylAcmaxstu10" 
                   value="${aClass.hylAcmaxstu10}" required min="1" max="100"
                   placeholder="例如：30">
            <div class="help-text">
                班级最大容纳学生数量，当前学生人数：${aClass.currentStudents}人
                <c:if test="${aClass.currentStudents > 0}">
                    <br><span class="warning-text">⚠️ 人数上限不能少于当前学生人数</span>
                </c:if>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">💾 保存修改</button>
            <a href="${pageContext.request.contextPath}/admin/aclass/view?id=${aClass.hylAcno10}" class="btn btn-secondary">❌ 取消</a>
        </div>
    </form>
</div>

<script>
    // 表单验证
    function validateForm() {
        const className = document.getElementById('hylAcname10').value.trim();
        const year = parseInt(document.getElementById('hylAcyear10').value);
        const majorId = document.getElementById('hylMno10').value;
        const maxStudents = parseInt(document.getElementById('hylAcmaxstu10').value);
        const currentStudents = ${aClass.currentStudents};
        
        if (!className) {
            alert('请输入行政班名称');
            return false;
        }
        
        if (className.length > 50) {
            alert('行政班名称长度不能超过50个字符');
            return false;
        }
        
        if (!year || year < 2020 || year > 2030) {
            alert('请输入有效的入学年份（2020-2030）');
            return false;
        }
        
        if (!majorId) {
            alert('请选择所属专业');
            return false;
        }
        
        if (!maxStudents || maxStudents < 1 || maxStudents > 100) {
            alert('班级人数上限必须在1-100之间');
            return false;
        }
        
        // 检查人数上限不能少于当前学生人数
        if (maxStudents < currentStudents) {
            alert('班级人数上限（' + maxStudents + '）不能少于当前学生人数（' + currentStudents + '）');
            return false;
        }
        
        // 如果有学生且要修改关键信息，给出警告
        if (currentStudents > 0) {
            const originalYear = ${aClass.hylAcyear10};
            const originalMajor = ${aClass.hylMno10};
            
            if (year !== originalYear || majorId != originalMajor) {
                if (!confirm('该班级已有 ' + currentStudents + ' 名学生。\n' +
                           '修改入学年份或专业可能影响现有学生信息。\n\n' +
                           '确定要继续修改吗？')) {
                    return false;
                }
            }
        }
        
        return true;
    }
</script>
</body>
</html> 