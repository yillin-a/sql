<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>编辑专业</title>
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
            max-width: 800px; 
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
            color: #ffc107;
        }
        
        /* 专业信息卡片 */
        .info-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border: 1px solid #dee2e6;
        }
        .info-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 10px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        .info-value {
            color: #007bff;
            font-weight: 500;
        }
        
        /* 表单样式 */
        .form-section {
            margin-bottom: 25px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #495057;
            margin-bottom: 15px;
            padding-left: 10px;
            border-left: 4px solid #ffc107;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            margin-bottom: 8px;
            font-weight: 500;
            color: #495057;
        }
        .form-group label.required::after {
            content: " *";
            color: #dc3545;
        }
        .form-group input, .form-group select {
            padding: 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #ffc107;
            box-shadow: 0 0 0 3px rgba(255,193,7,0.1);
        }
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
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
        
        /* 消息提示 */
        .alert {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-weight: 500;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
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
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .form-row, .info-row {
                grid-template-columns: 1fr;
            }
            .actions {
                flex-direction: column;
            }
            .btn {
                justify-content: center;
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
            &gt; ✏️ 编辑专业
        </div>
        
        <!-- 页面标题 -->
        <div class="header">
            <h1 class="title">
                <span class="icon">✏️</span>编辑专业
            </h1>
        </div>
        
        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ❌ ${error}
            </div>
        </c:if>
        
        <!-- 当前专业信息 -->
        <div class="info-card">
            <h3 style="margin-top: 0; color: #495057;">📋 当前专业信息</h3>
            <div class="info-row">
                <div class="info-item">
                    <span class="info-label">专业编号:</span>
                    <span class="info-value">${major.hylMno10}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">当前学生数:</span>
                    <span class="info-value">${major.studentCount} 人</span>
                </div>
            </div>
            <c:if test="${major.studentCount > 0}">
                <div class="alert alert-warning" style="margin-top: 15px; margin-bottom: 0;">
                    ⚠️ 该专业下有 ${major.studentCount} 名学生，请谨慎修改专业信息。
                </div>
            </c:if>
        </div>
        
        <!-- 编辑表单 -->
        <form method="post" action="${pageContext.request.contextPath}/admin/major/edit" id="editMajorForm">
            <input type="hidden" name="hylMno10" value="${major.hylMno10}">
            
            <!-- 基本信息 -->
            <div class="form-section">
                <div class="section-title">📝 专业信息</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="hylMname10" class="required">专业名称</label>
                        <input type="text" id="hylMname10" name="hylMname10" 
                               value="${major.hylMname10}" required maxlength="50"
                               placeholder="请输入专业名称">
                        <div class="help-text">专业的完整名称，如：计算机科学与技术</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="hylMdegree10" class="required">学位类型</label>
                        <select id="hylMdegree10" name="hylMdegree10" required>
                            <option value="">请选择学位类型</option>
                            <option value="本科" ${major.hylMdegree10 == '本科' ? 'selected' : ''}>本科</option>
                            <option value="硕士" ${major.hylMdegree10 == '硕士' ? 'selected' : ''}>硕士</option>
                            <option value="博士" ${major.hylMdegree10 == '博士' ? 'selected' : ''}>博士</option>
                        </select>
                        <div class="help-text">该专业授予的学位类型</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="hylMyears10" class="required">学制年限</label>
                        <input type="number" id="hylMyears10" name="hylMyears10" 
                               value="${major.hylMyears10}" required min="1" max="10"
                               placeholder="请输入学制年限">
                        <div class="help-text">专业的标准学制年限（1-10年）</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="hylFno10" class="required">所属学院</label>
                        <select id="hylFno10" name="hylFno10" required>
                            <option value="">请选择所属学院</option>
                            <c:forEach var="faculty" items="${faculties}">
                                <option value="${faculty.facultyId}" 
                                        ${major.hylFno10 == faculty.facultyId ? 'selected' : ''}>
                                    ${faculty.facultyName}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="help-text">专业归属的学院</div>
                    </div>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="actions">
                <button type="submit" class="btn btn-warning">
                    💾 保存修改
                </button>
                <a href="${pageContext.request.contextPath}/admin/major/list" class="btn btn-secondary">
                    ❌ 取消
                </a>
                <a href="${pageContext.request.contextPath}/admin/major/view?id=${major.hylMno10}" class="btn btn-info">
                    👁️ 查看详情
                </a>
            </div>
        </form>
    </div>
    
    <script>
        // 表单验证
        document.getElementById('editMajorForm').addEventListener('submit', function(e) {
            const majorName = document.getElementById('hylMname10').value.trim();
            const degree = document.getElementById('hylMdegree10').value;
            const years = document.getElementById('hylMyears10').value;
            const facultyId = document.getElementById('hylFno10').value;
            
            if (!majorName) {
                alert('❌ 请输入专业名称');
                e.preventDefault();
                return;
            }
            
            if (!degree) {
                alert('❌ 请选择学位类型');
                e.preventDefault();
                return;
            }
            
            if (!years || years < 1 || years > 10) {
                alert('❌ 请输入有效的学制年限（1-10年）');
                e.preventDefault();
                return;
            }
            
            if (!facultyId) {
                alert('❌ 请选择所属学院');
                e.preventDefault();
                return;
            }
            
            // 确认保存
            if (!confirm('确定要保存对专业 "' + majorName + '" 的修改吗？')) {
                e.preventDefault();
                return;
            }
        });
        
        // 专业名称输入提示
        document.getElementById('hylMname10').addEventListener('input', function() {
            const value = this.value;
            if (value.length > 30) {
                this.style.borderColor = '#ffc107';
            } else if (value.length > 45) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#ced4da';
            }
        });
        
        // 检测修改
        const originalValues = {
            name: '${major.hylMname10}',
            degree: '${major.hylMdegree10}',
            years: '${major.hylMyears10}',
            faculty: '${major.hylFno10}'
        };
        
        function checkChanges() {
            const currentValues = {
                name: document.getElementById('hylMname10').value,
                degree: document.getElementById('hylMdegree10').value,
                years: document.getElementById('hylMyears10').value,
                faculty: document.getElementById('hylFno10').value
            };
            
            const hasChanges = Object.keys(originalValues).some(key => 
                originalValues[key] !== currentValues[key]
            );
            
            const submitBtn = document.querySelector('button[type="submit"]');
            if (hasChanges) {
                submitBtn.style.backgroundColor = '#28a745';
                submitBtn.innerHTML = '💾 保存修改 (有变更)';
            } else {
                submitBtn.style.backgroundColor = '#ffc107';
                submitBtn.innerHTML = '💾 保存修改';
            }
        }
        
        // 监听表单变化
        document.querySelectorAll('input, select').forEach(element => {
            element.addEventListener('change', checkChanges);
            element.addEventListener('input', checkChanges);
        });
    </script>
</body>
</html> 