<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>专业管理</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { 
            font-family: 'Microsoft YaHei', Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background-color: #f8f9fa;
        }
        .container { 
            max-width: 1400px; 
            margin: 0 auto; 
            background-color: white; 
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }
        .title {
            font-size: 28px;
            font-weight: bold;
            color: #2c3e50;
            margin: 0;
        }
        .title .icon {
            margin-right: 10px;
            color: #3498db;
        }
        
        /* 统计信息卡片 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .stat-card.secondary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .stat-card.success {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .stat-card.warning {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 0.95em;
            opacity: 0.9;
        }
        
        /* 搜索和操作区域 */
        .actions-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border: 1px solid #dee2e6;
        }
        .search-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            min-width: 150px;
        }
        .form-group label {
            margin-bottom: 5px;
            font-weight: 500;
            color: #495057;
        }
        .form-group input, .form-group select {
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 14px;
        }
        
        /* 按钮样式 */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            transform: translateY(-1px);
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #1e7e34;
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
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background-color: #138496;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }
        
        /* 表格样式 */
        .table-container {
            overflow-x: auto;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }
        th {
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
            padding: 15px 12px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        
        /* 学位类型标签 */
        .degree-tag {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            color: white;
        }
        .degree-undergraduate {
            background-color: #28a745;
        }
        .degree-master {
            background-color: #007bff;
        }
        .degree-doctoral {
            background-color: #6f42c1;
        }
        
        /* 学院分布图表区域 */
        .distribution-section {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        .distribution-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #495057;
        }
        .distribution-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .distribution-item:last-child {
            border-bottom: none;
        }
        
        /* 消息提示 */
        .alert {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
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
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .search-form {
                flex-direction: column;
                align-items: stretch;
            }
            .form-group {
                min-width: auto;
            }
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 页面标题和主要操作 -->
        <div class="header">
            <h1 class="title">
                <span class="icon">🎓</span>专业管理
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/major/add" class="btn btn-success">
                    ➕ 添加专业
                </a>
                <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-info">
                    🏠 返回管理首页
                </a>
            </div>
        </div>
        
        <!-- 成功/错误消息 -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                ✅ ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ❌ ${error}
            </div>
        </c:if>
        
        <!-- 统计信息 -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${statistics.totalMajors}</div>
                <div class="stat-label">专业总数</div>
            </div>
            <div class="stat-card secondary">
                <div class="stat-number">${statistics.totalStudents}</div>
                <div class="stat-label">在读学生</div>
            </div>
            <div class="stat-card success">
                <div class="stat-number">${statistics.facultyCount}</div>
                <div class="stat-label">开设学院</div>
            </div>
            <div class="stat-card warning">
                <div class="stat-number">
                    <fmt:formatNumber value="${statistics.avgYears}" pattern="#.#"/>
                </div>
                <div class="stat-label">平均学制(年)</div>
            </div>
        </div>
        
        <!-- 搜索和过滤 -->
        <div class="actions-section">
            <form class="search-form" method="get" action="${pageContext.request.contextPath}/admin/major/search">
                <div class="form-group">
                    <label for="keyword">关键词搜索</label>
                    <input type="text" id="keyword" name="keyword" 
                           value="${searchKeyword}" placeholder="专业名称或学院名称">
                </div>
                <div class="form-group">
                    <label for="facultyId">所属学院</label>
                    <select id="facultyId" name="facultyId">
                        <option value="">全部学院</option>
                        <c:forEach var="faculty" items="${faculties}">
                            <option value="${faculty.facultyId}" 
                                    ${selectedFacultyId == faculty.facultyId ? 'selected' : ''}>
                                ${faculty.facultyName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">🔍 搜索</button>
                </div>
                <div class="form-group">
                    <a href="${pageContext.request.contextPath}/admin/major/list" class="btn btn-warning">
                        🔄 重置
                    </a>
                </div>
            </form>
        </div>
        
        <!-- 专业列表 -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>专业编号</th>
                        <th>专业名称</th>
                        <th>学位类型</th>
                        <th>学制年限</th>
                        <th>所属学院</th>
                        <th>学生人数</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="major" items="${majors}">
                        <tr>
                            <td>${major.hylMno10}</td>
                            <td>
                                <strong>${major.hylMname10}</strong>
                            </td>
                            <td>
                                <span class="degree-tag 
                                    <c:choose>
                                        <c:when test="${major.hylMdegree10 == '本科'}">degree-undergraduate</c:when>
                                        <c:when test="${major.hylMdegree10 == '硕士'}">degree-master</c:when>
                                        <c:when test="${major.hylMdegree10 == '博士'}">degree-doctoral</c:when>
                                    </c:choose>">
                                    ${major.hylMdegree10}
                                </span>
                            </td>
                            <td>${major.hylMyears10} 年</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty major.facultyName}">
                                        ${major.facultyName}
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999;">未分配</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <strong style="color: #007bff;">${major.studentCount}</strong> 人
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/major/view?id=${major.hylMno10}" 
                                   class="btn btn-info btn-sm">👁️ 查看</a>
                                <a href="${pageContext.request.contextPath}/admin/major/edit?id=${major.hylMno10}" 
                                   class="btn btn-warning btn-sm">✏️ 编辑</a>
                                <button onclick="deleteMajor(${major.hylMno10}, '${major.hylMname10}')" 
                                        class="btn btn-danger btn-sm">🗑️ 删除</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty majors}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 40px; color: #999;">
                                📋 暂无专业数据
                                <c:if test="${not empty searchKeyword or not empty selectedFacultyId}">
                                    <br><small>尝试修改搜索条件</small>
                                </c:if>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- 学院专业分布 -->
        <div class="distribution-section">
            <div class="distribution-title">📊 各学院专业分布</div>
            <c:forEach var="item" items="${facultyDistribution}">
                <div class="distribution-item">
                    <span>
                        <strong>${item.facultyName}</strong>
                        <small style="color: #666;">(${item.studentCount} 名学生)</small>
                    </span>
                    <span>
                        <strong style="color: #007bff;">${item.majorCount}</strong> 个专业
                    </span>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <script>
        function deleteMajor(majorId, majorName) {
            if (confirm('确定要删除专业 "' + majorName + '" 吗？\n\n注意：如果该专业下存在学生，将无法删除。')) {
                fetch('${pageContext.request.contextPath}/admin/major/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + majorId
                })
                .then(response => response.text())
                .then(data => {
                    if (data.startsWith('success:')) {
                        alert('✅ ' + data.substring(8));
                        location.reload();
                    } else if (data.startsWith('error:')) {
                        alert('❌ ' + data.substring(6));
                    } else {
                        alert('❌ 删除失败：未知错误');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('❌ 删除失败：网络错误');
                });
            }
        }
        
        // 页面加载时的提示
        document.addEventListener('DOMContentLoaded', function() {
            // 如果有搜索参数，高亮显示搜索结果
            const searchKeyword = '${searchKeyword}';
            if (searchKeyword) {
                const keyword = searchKeyword.toLowerCase();
                const rows = document.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    if (text.includes(keyword)) {
                        row.style.backgroundColor = '#fff3cd';
                    }
                });
            }
        });
    </script>
</body>
</html> 