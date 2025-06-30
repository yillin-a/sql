<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>专业详情</title>
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
            max-width: 900px; 
            margin: 0 auto; 
            background-color: white; 
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
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
            color: #17a2b8;
        }
        
        /* 专业信息卡片 */
        .info-section {
            margin-bottom: 30px;
        }
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #495057;
            margin-bottom: 20px;
            padding-left: 15px;
            border-left: 4px solid #17a2b8;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .info-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            text-align: center;
        }
        .info-card.primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .info-card.success {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        .info-card.warning {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }
        .info-card.danger {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .info-value {
            font-size: 2.2em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .info-label {
            font-size: 0.9em;
            opacity: 0.9;
        }
        
        /* 详细信息表格 */
        .details-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #dee2e6;
        }
        .details-table th {
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            width: 30%;
        }
        .details-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
        }
        .details-table tr:last-child td {
            border-bottom: none;
        }
        
        /* 学位类型标签 */
        .degree-tag {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 14px;
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
        
        /* 按钮样式 */
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
            transform: translateY(-1px);
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
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background-color: #138496;
        }
        
        /* 操作按钮区域 */
        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        /* 导航面包屑 */
        .breadcrumb {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }
        .breadcrumb a {
            color: #007bff;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        
        /* 状态指示器 */
        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .info-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .details-table th {
                width: 40%;
            }
            .actions {
                flex-direction: column;
            }
            .btn {
                justify-content: center;
            }
        }
        
        @media (max-width: 480px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 导航面包屑 -->
        <div class="breadcrumb">
            🏠 <a href="${pageContext.request.contextPath}/admin/home">管理首页</a> 
            &gt; 📋 <a href="${pageContext.request.contextPath}/admin/major/list">专业管理</a> 
            &gt; 👁️ 专业详情
        </div>
        
        <!-- 页面标题 -->
        <div class="header">
            <h1 class="title">
                <span class="icon">👁️</span>${major.hylMname10} - 专业详情
            </h1>
        </div>
        
        <!-- 关键指标 -->
        <div class="info-section">
            <div class="section-title">📊 关键指标</div>
            <div class="info-grid">
                <div class="info-card primary">
                    <div class="info-value">${major.hylMno10}</div>
                    <div class="info-label">专业编号</div>
                </div>
                <div class="info-card success">
                    <div class="info-value">${major.studentCount}</div>
                    <div class="info-label">在读学生</div>
                </div>
                <div class="info-card warning">
                    <div class="info-value">${major.hylMyears10}</div>
                    <div class="info-label">学制年限</div>
                </div>
                <div class="info-card danger">
                    <div class="info-value">
                        <span class="degree-tag 
                            <c:choose>
                                <c:when test="${major.hylMdegree10 == '本科'}">degree-undergraduate</c:when>
                                <c:when test="${major.hylMdegree10 == '硕士'}">degree-master</c:when>
                                <c:when test="${major.hylMdegree10 == '博士'}">degree-doctoral</c:when>
                            </c:choose>">
                            ${major.hylMdegree10}
                        </span>
                    </div>
                    <div class="info-label">学位类型</div>
                </div>
            </div>
        </div>
        
        <!-- 详细信息 -->
        <div class="info-section">
            <div class="section-title">📋 详细信息</div>
            <table class="details-table">
                <tr>
                    <th>专业编号</th>
                    <td><strong style="color: #007bff;">${major.hylMno10}</strong></td>
                </tr>
                <tr>
                    <th>专业名称</th>
                    <td><strong>${major.hylMname10}</strong></td>
                </tr>
                <tr>
                    <th>学位类型</th>
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
                </tr>
                <tr>
                    <th>学制年限</th>
                    <td>${major.hylMyears10} 年</td>
                </tr>
                <tr>
                    <th>所属学院</th>
                    <td>
                        <c:choose>
                            <c:when test="${not empty major.facultyName}">
                                <strong style="color: #28a745;">${major.facultyName}</strong>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #999;">未分配学院</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>学院编号</th>
                    <td>${major.hylFno10}</td>
                </tr>
                <tr>
                    <th>在读学生数</th>
                    <td>
                        <strong style="color: #007bff; font-size: 1.1em;">${major.studentCount}</strong> 人
                        <c:choose>
                            <c:when test="${major.studentCount == 0}">
                                <span class="status-indicator status-warning">
                                    ⚠️ 暂无学生
                                </span>
                            </c:when>
                            <c:when test="${major.studentCount > 0}">
                                <span class="status-indicator status-active">
                                    ✅ 正常招生
                                </span>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </div>
        
        <!-- 操作建议 -->
        <div class="info-section">
            <div class="section-title">💡 操作建议</div>
            <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; border: 1px solid #dee2e6;">
                <c:choose>
                    <c:when test="${major.studentCount == 0}">
                        <p style="margin: 0; color: #856404;">
                            <strong>📝 建议：</strong> 该专业目前没有在读学生，可以安全地进行编辑或删除操作。
                            如果不再需要此专业，建议及时删除以保持数据整洁。
                        </p>
                    </c:when>
                    <c:when test="${major.studentCount > 0 && major.studentCount <= 10}">
                        <p style="margin: 0; color: #0c5460;">
                            <strong>📊 建议：</strong> 该专业学生数量较少（${major.studentCount}人），
                            建议关注招生情况。编辑专业信息时请谨慎，避免影响现有学生。
                        </p>
                    </c:when>
                    <c:when test="${major.studentCount > 10}">
                        <p style="margin: 0; color: #155724;">
                            <strong>✅ 状态良好：</strong> 该专业有${major.studentCount}名在读学生，运行状态良好。
                            编辑专业信息时请特别谨慎，确保不影响学生的正常学习。
                        </p>
                    </c:when>
                </c:choose>
            </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="actions">
            <a href="${pageContext.request.contextPath}/admin/major/edit?id=${major.hylMno10}" class="btn btn-warning">
                ✏️ 编辑专业
            </a>
            <c:if test="${major.studentCount == 0}">
                <button onclick="deleteMajor(${major.hylMno10}, '${major.hylMname10}')" class="btn btn-danger">
                    🗑️ 删除专业
                </button>
            </c:if>
            <a href="${pageContext.request.contextPath}/admin/major/list" class="btn btn-secondary">
                📋 返回列表
            </a>
            <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-info">
                🏠 管理首页
            </a>
        </div>
    </div>
    
    <script>
        function deleteMajor(majorId, majorName) {
            if (confirm('确定要删除专业 "' + majorName + '" 吗？\n\n注意：此操作不可撤销！')) {
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
                        window.location.href = '${pageContext.request.contextPath}/admin/major/list?success=' + encodeURIComponent(data.substring(8));
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
        
        // 页面加载动画
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.info-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html> 