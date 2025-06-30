<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>行政班详情 - 选课管理系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #007bff;
        }
        .header h1 {
            color: #333;
            margin: 0;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
            margin-left: 10px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }
        .info-card h3 {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 18px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        .info-value {
            color: #333;
        }
        .alert {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
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
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-full {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-available {
            background-color: #d4edda;
            color: #155724;
        }
        .status-warning {
            background-color: #fff3cd;
            color: #856404;
        }
        .actions-section {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/home">管理员控制台</a> > 
        <a href="${pageContext.request.contextPath}/admin/aclass/list">行政班管理</a> > 
        行政班详情
    </div>
    
    <div class="header">
        <h1>🏫 ${aClass.hylAcname10}</h1>
        <div>
            <a href="${pageContext.request.contextPath}/admin/aclass/edit?id=${aClass.hylAcno10}" class="btn btn-warning">✏️ 编辑</a>
            <c:if test="${aClass.currentStudents == 0}">
                <button onclick="confirmDelete()" class="btn btn-danger">🗑️ 删除</button>
            </c:if>
            <a href="${pageContext.request.contextPath}/admin/aclass/list" class="btn btn-secondary">📋 返回列表</a>
        </div>
    </div>

    <!-- 成功消息 -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <div class="info-grid">
        <!-- 基本信息 -->
        <div class="info-card">
            <h3>📋 基本信息</h3>
            <div class="info-item">
                <span class="info-label">行政班编号:</span>
                <span class="info-value">${aClass.hylAcno10}</span>
            </div>
            <div class="info-item">
                <span class="info-label">行政班名称:</span>
                <span class="info-value"><strong>${aClass.hylAcname10}</strong></span>
            </div>
            <div class="info-item">
                <span class="info-label">入学年份:</span>
                <span class="info-value">${aClass.hylAcyear10}年</span>
            </div>
        </div>

        <!-- 专业信息 -->
        <div class="info-card">
            <h3>🎓 专业信息</h3>
            <div class="info-item">
                <span class="info-label">所属专业:</span>
                <span class="info-value"><strong>${aClass.majorName}</strong></span>
            </div>
            <div class="info-item">
                <span class="info-label">所属学院:</span>
                <span class="info-value">${aClass.facultyName}</span>
            </div>
            <div class="info-item">
                <span class="info-label">专业编号:</span>
                <span class="info-value">${aClass.hylMno10}</span>
            </div>
        </div>

        <!-- 学生信息 -->
        <div class="info-card">
            <h3>👥 学生信息</h3>
            <div class="info-item">
                <span class="info-label">人数上限:</span>
                <span class="info-value">${aClass.hylAcmaxstu10}人</span>
            </div>
            <div class="info-item">
                <span class="info-label">当前人数:</span>
                <span class="info-value">
                    <strong style="color: ${aClass.currentStudents >= aClass.hylAcmaxstu10 ? '#dc3545' : '#28a745'}">
                        ${aClass.currentStudents}人
                    </strong>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">剩余名额:</span>
                <span class="info-value">
                    <c:set var="remaining" value="${aClass.hylAcmaxstu10 - aClass.currentStudents}" />
                    <strong style="color: ${remaining <= 0 ? '#dc3545' : (remaining <= 5 ? '#ffc107' : '#28a745')}">
                        ${remaining}人
                    </strong>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">班级状态:</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${aClass.currentStudents >= aClass.hylAcmaxstu10}">
                            <span class="status-badge status-full">已满员</span>
                        </c:when>
                        <c:when test="${aClass.currentStudents >= aClass.hylAcmaxstu10 * 0.8}">
                            <span class="status-badge status-warning">接近满员</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-available">可招生</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <!-- 统计信息 -->
        <div class="info-card">
            <h3>📊 统计信息</h3>
            <div class="info-item">
                <span class="info-label">使用率:</span>
                <span class="info-value">
                    <c:set var="utilization" value="${(aClass.currentStudents * 100) / aClass.hylAcmaxstu10}" />
                    <strong style="color: ${utilization >= 100 ? '#dc3545' : (utilization >= 80 ? '#ffc107' : '#28a745')}">
                        ${String.format("%.1f", utilization)}%
                    </strong>
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">年级:</span>
                <span class="info-value">
                    <c:set var="currentYear" value="${java.time.Year.now().value}" />
                    <c:set var="grade" value="${currentYear - aClass.hylAcyear10 + 1}" />
                    ${grade > 0 ? (grade <= 4 ? grade + "年级" : "已毕业") : "未入学"}
                </span>
            </div>
            <div class="info-item">
                <span class="info-label">可否删除:</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${aClass.currentStudents == 0}">
                            <span style="color: #28a745;">✅ 可删除</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #dc3545;">❌ 有学生，不可删除</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
    </div>

    <div class="actions-section">
        <h3>🔧 可用操作</h3>
        <a href="${pageContext.request.contextPath}/student/list?class=${aClass.hylAcno10}" class="btn btn-primary">
            👥 查看班级学生
        </a>
        <a href="${pageContext.request.contextPath}/admin/aclass/edit?id=${aClass.hylAcno10}" class="btn btn-warning">
            ✏️ 编辑班级信息
        </a>
        <c:if test="${aClass.currentStudents == 0}">
            <button onclick="confirmDelete()" class="btn btn-danger">
                🗑️ 删除班级
            </button>
        </c:if>
    </div>
</div>

<!-- 删除确认表单 -->
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/aclass/delete" style="display: none;">
    <input type="hidden" name="id" value="${aClass.hylAcno10}">
</form>

<script>
    function confirmDelete() {
        if (confirm('确定要删除行政班 "${aClass.hylAcname10}" 吗？\n\n注意：删除后无法恢复！')) {
            document.getElementById('deleteForm').submit();
        }
    }
</script>
</body>
</html> 