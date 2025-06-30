<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学生列表</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container { 
            max-width: 1200px; 
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
        
        /* 搜索和过滤区域 */
        .search-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #dee2e6;
        }
        .search-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
        }
        .form-group input, .form-group select {
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .search-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.2s ease;
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        /* 统计卡片 */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .stat-label {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        /* 表格样式 */
        .table-container {
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            background: white;
        }
        th, td { 
            padding: 15px; 
            text-align: left; 
            border-bottom: 1px solid #e9ecef; 
        }
        th { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        tr:hover { 
            background-color: #f8f9fa;
            transform: scale(1.01);
            transition: all 0.2s ease;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        /* 按钮样式 */
        .btn { 
            padding: 8px 16px; 
            text-decoration: none; 
            border-radius: 6px; 
            font-size: 14px; 
            margin-right: 8px; 
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-block;
        }
        .btn-primary { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
        }
        .btn-success { 
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white; 
        }
        .btn-info { 
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white; 
        }
        .btn-warning { 
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white; 
        }
        .btn-danger { 
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
            color: white; 
            border: none;
            cursor: pointer;
        }
        .btn:hover { 
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        /* 操作按钮组 */
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        
        /* 导航按钮 */
        .nav-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        .nav-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .nav-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }
        
        /* 状态标签 */
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        /* 性别图标 */
        .gender-icon {
            font-size: 16px;
        }
        .male { color: #007bff; }
        .female { color: #e83e8c; }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .search-form { grid-template-columns: 1fr; }
            .stats-section { grid-template-columns: repeat(2, 1fr); }
            .nav-buttons { flex-direction: column; align-items: center; }
            .action-buttons { flex-direction: column; }
        }
        
        /* 消息提示样式 */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            border: 1px solid transparent;
        }
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-color: #c3e6cb;
            color: #155724;
        }
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border-color: #f5c6cb;
            color: #721c24;
        }
        .alert-info {
            background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
            border-color: #bee5eb;
            color: #0c5460;
        }
        
        /* 触发器信息提示 */
        .trigger-notice {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 2px solid #ffc107;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            text-align: center;
        }
        .trigger-notice h4 {
            color: #856404;
            margin-bottom: 10px;
        }
        .trigger-notice p {
            color: #856404;
            margin-bottom: 0;
        }
        
        /* 新学生信息卡片 */
        .new-student-card {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 2px solid #28a745;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .new-student-card h5 {
            color: #155724;
            margin-bottom: 15px;
        }
        .new-student-info {
            background: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .new-student-info strong {
            color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>👥 学生管理</h2>
        
        <!-- 触发器信息提示 -->
        <div class="trigger-notice">
            <h4>🔄 自动用户创建功能</h4>
            <p>系统已启用触发器功能，添加新学生时将自动创建登录账户（用户名=学号，默认密码=学号）</p>
        </div>
        
        <!-- 消息提示 -->
        <c:if test="${not empty message}">
            <div class="alert alert-success">
                <strong>✅ 操作成功！</strong><br>
                ${message}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <strong>❌ 操作失败！</strong><br>
                ${error}
            </div>
        </c:if>
        
        <!-- 新学生信息卡片 -->
        <c:if test="${not empty newStudent}">
            <div class="new-student-card">
                <h5>🎉 新学生添加成功！</h5>
                <div class="new-student-info">
                    <strong>学生姓名：</strong>${newStudent.hylSname10}<br>
                    <strong>学号：</strong>${newStudent.hylSno10}<br>
                    <strong>登录账户：</strong>用户名=${newStudent.hylSno10}，密码=Student@123<br>
                    <strong>请通知学生及时修改默认密码！</strong>
                </div>
            </div>
        </c:if>
        
        <!-- 统计卡片 -->
        <div class="stats-section">
            <div class="stat-card">
                <div class="stat-number">${students.size()}</div>
                <div class="stat-label">总学生数</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="maleCount" value="0"/>
                    <c:forEach var="student" items="${students}">
                        <c:if test="${student.hylSsex10 == '男'}">
                            <c:set var="maleCount" value="${maleCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${maleCount}
                </div>
                <div class="stat-label">男生</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="femaleCount" value="0"/>
                    <c:forEach var="student" items="${students}">
                        <c:if test="${student.hylSsex10 == '女'}">
                            <c:set var="femaleCount" value="${femaleCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${femaleCount}
                </div>
                <div class="stat-label">女生</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="activeCount" value="0"/>
                    <c:forEach var="student" items="${students}">
                        <c:if test="${student.hylSstatus10 == '在读'}">
                            <c:set var="activeCount" value="${activeCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${activeCount}
                </div>
                <div class="stat-label">在读学生</div>
            </div>
        </div>
        
        <!-- 搜索和过滤 -->
        <div class="search-section">
            <form action="${pageContext.request.contextPath}/student/search" method="get" class="search-form">
                <div class="form-group">
                    <label for="name">姓名搜索</label>
                    <input type="text" id="name" name="name" placeholder="输入学生姓名..." value="${searchName}">
                </div>
                <div class="form-group">
                    <label for="status">状态筛选</label>
                    <select id="status" name="status">
                        <option value="">全部状态</option>
                        <option value="在读" ${searchStatus == '在读' ? 'selected' : ''}>在读</option>
                        <option value="休学" ${searchStatus == '休学' ? 'selected' : ''}>休学</option>
                        <option value="退学" ${searchStatus == '退学' ? 'selected' : ''}>退学</option>
                        <option value="毕业" ${searchStatus == '毕业' ? 'selected' : ''}>毕业</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="gender">性别筛选</label>
                    <select id="gender" name="gender">
                        <option value="">全部性别</option>
                        <option value="男" ${searchGender == '男' ? 'selected' : ''}>男</option>
                        <option value="女" ${searchGender == '女' ? 'selected' : ''}>女</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="search-btn">🔍 搜索</button>
                </div>
            </form>
        </div>
        
        <!-- 学生列表表格 -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>学号</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>年龄</th>
                        <th>专业</th>
                        <th>班级</th>
                        <th>GPA</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="student" items="${students}">
                        <tr>
                            <td><strong>${student.hylSno10}</strong></td>
                            <td>
                                <span style="font-weight: 600; color: #333;">${student.hylSname10}</span>
                                <c:if test="${not empty student.hylSemail10}">
                                    <br><small style="color: #666;">📧 ${student.hylSemail10}</small>
                                </c:if>
                            </td>
                            <td>
                                <span class="gender-icon">
                                    <c:choose>
                                        <c:when test="${student.hylSsex10 == '男'}"> 👨 </c:when>
                                        <c:when test="${student.hylSsex10 == '女'}"> 👩 </c:when>
                                        <c:otherwise>❓</c:otherwise>
                                    </c:choose>
                                </span>
                                ${student.hylSsex10}
                            </td>
                            <td>${student.hylSage10} 岁</td>
                            <td>
                                <c:if test="${not empty student.majorName}">
                                    ${student.majorName}
                                </c:if>
                                <c:if test="${empty student.majorName}">
                                    <span style="color: #999;">未分配</span>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty student.className}">
                                    ${student.className}
                                </c:if>
                                <c:if test="${empty student.className}">
                                    <span style="color: #999;">未分配</span>
                                </c:if>
                            </td>
                            <td>
                                <span style="
                                    <c:choose>
                                        <c:when test="${student.hylSgpa10 >= 4.0}">color: #28a745; font-weight: bold;</c:when>
                                        <c:when test="${student.hylSgpa10 >= 3.0}">color: #007bff; font-weight: bold;</c:when>
                                        <c:when test="${student.hylSgpa10 >= 2.0}">color: #ffc107; font-weight: bold;</c:when>
                                        <c:otherwise>color: #dc3545; font-weight: bold;</c:otherwise>
                                    </c:choose>
                                ">${student.hylSgpa10}</span>
                            </td>
                            <td>
                                <span class="status-badge ${student.hylSstatus10 == '在读' ? 'status-active' : 'status-inactive'}">
                                    ${student.hylSstatus10}
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/student/view?id=${student.hylSno10}" class="btn btn-info">👁️ 详情</a>
                                    <a href="${pageContext.request.contextPath}/student/edit?id=${student.hylSno10}" class="btn btn-warning">✏️ 编辑</a>
                                    <a href="${pageContext.request.contextPath}/student/detail-scores?id=${student.hylSno10}" class="btn btn-success">📊 成绩</a>
                                    <form action="${pageContext.request.contextPath}/student/delete" method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="${student.hylSno10}"/>
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('⚠️ 确定要删除学生 ${student.hylSname10} 吗？此操作不可恢复！')">🗑️ 删除</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- 导航按钮 -->
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/student/add" class="nav-btn">➕ 添加学生</a>
            <a href="${pageContext.request.contextPath}/student/scores" class="nav-btn">📊 成绩管理</a>
            <a href="${pageContext.request.contextPath}/student/ranking" class="nav-btn">🏆 成绩排名</a>
            <a href="${pageContext.request.contextPath}/" class="nav-btn">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 