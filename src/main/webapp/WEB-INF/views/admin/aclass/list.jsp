<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>行政班管理 - 选课管理系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
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
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background-color: #138496;
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
        .search-form {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .search-form input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .table th, .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }
        .table tbody tr:hover {
            background-color: #f5f5f5;
        }
        .actions {
            display: flex;
            gap: 5px;
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
        .stats-info {
            background-color: #e9ecef;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            color: #495057;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/home">管理员控制台</a> > 行政班管理
    </div>
    
    <div class="header">
        <h1>🏫 行政班管理</h1>
        <div>
            <a href="${pageContext.request.contextPath}/admin/aclass/add" class="btn btn-primary">➕ 添加行政班</a>
            <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-secondary">🏠 返回首页</a>
        </div>
    </div>

    <!-- 成功/错误消息 -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            ${error}
        </div>
    </c:if>

    <!-- 统计信息 -->
    <div class="stats-info">
        共有 <strong>${aClasses.size()}</strong> 个行政班
        <c:if test="${not empty searchKeyword}">
            （搜索关键词："${searchKeyword}"）
        </c:if>
    </div>

    <!-- 搜索表单 -->
    <form method="get" action="${pageContext.request.contextPath}/admin/aclass/search" class="search-form">
        <input type="text" name="keyword" placeholder="搜索行政班名称、专业或学院..." 
               value="${searchKeyword}" style="width: 300px;">
        <button type="submit" class="btn btn-info">🔍 搜索</button>
        <c:if test="${not empty searchKeyword}">
            <a href="${pageContext.request.contextPath}/admin/aclass/list" class="btn btn-secondary">清除搜索</a>
        </c:if>
    </form>

    <!-- 行政班列表 -->
    <c:choose>
        <c:when test="${not empty aClasses}">
            <table class="table">
                <thead>
                    <tr>
                        <th>编号</th>
                        <th>班级名称</th>
                        <th>入学年份</th>
                        <th>所属专业</th>
                        <th>所属学院</th>
                        <th>人数上限</th>
                        <th>当前人数</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="aClass" items="${aClasses}">
                        <tr>
                            <td>${aClass.hylAcno10}</td>
                            <td><strong>${aClass.hylAcname10}</strong></td>
                            <td>${aClass.hylAcyear10}</td>
                            <td>${aClass.majorName}</td>
                            <td>${aClass.facultyName}</td>
                            <td>${aClass.hylAcmaxstu10}</td>
                            <td>
                                <span style="color: ${aClass.currentStudents >= aClass.hylAcmaxstu10 ? '#dc3545' : '#28a745'}">
                                    ${aClass.currentStudents}
                                </span>
                                <c:if test="${aClass.currentStudents >= aClass.hylAcmaxstu10}">
                                    <span style="color: #dc3545; font-size: 12px;">（已满）</span>
                                </c:if>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/aclass/view?id=${aClass.hylAcno10}" 
                                       class="btn btn-info" style="font-size: 12px; padding: 5px 10px;">查看</a>
                                    <a href="${pageContext.request.contextPath}/admin/aclass/edit?id=${aClass.hylAcno10}" 
                                       class="btn btn-warning" style="font-size: 12px; padding: 5px 10px;">编辑</a>
                                    <c:if test="${aClass.currentStudents == 0}">
                                        <button onclick="confirmDelete(${aClass.hylAcno10}, '${aClass.hylAcname10}')" 
                                                class="btn btn-danger" style="font-size: 12px; padding: 5px 10px;">删除</button>
                                    </c:if>
                                    <c:if test="${aClass.currentStudents > 0}">
                                        <span style="font-size: 12px; color: #6c757d;">有学生</span>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="no-data">
                <h3>😔 暂无行政班数据</h3>
                <p>
                    <c:choose>
                        <c:when test="${not empty searchKeyword}">
                            没有找到匹配的行政班，请尝试其他搜索关键词。
                        </c:when>
                        <c:otherwise>
                            系统中还没有行政班数据，请先添加行政班。
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="${pageContext.request.contextPath}/admin/aclass/add" class="btn btn-primary">➕ 添加第一个行政班</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 删除确认表单 -->
<form id="deleteForm" method="post" style="display: none;">
    <input type="hidden" name="id" id="deleteId">
</form>

<script>
    function confirmDelete(id, name) {
        if (confirm('确定要删除行政班 "' + name + '" 吗？\n\n注意：删除后无法恢复！')) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/admin/aclass/delete';
            document.getElementById('deleteForm').submit();
        }
    }
</script>
</body>
</html> 