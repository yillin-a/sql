<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>教师列表</title>
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
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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
        }
        tr:hover { 
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .btn { 
            padding: 8px 16px; 
            text-decoration: none; 
            border-radius: 6px; 
            font-size: 14px; 
            margin-right: 8px; 
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
        }
        .btn-primary { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
        }
        .btn-warning { 
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: #212529; 
        }
        .btn-danger { 
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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
        .nav-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            justify-content: center;
        }
        .search-box { 
            margin-bottom: 20px; 
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }
        .search-box input { 
            padding: 12px; 
            width: 300px; 
            border: 2px solid #e9ecef; 
            border-radius: 8px; 
            font-size: 14px;
            margin-right: 10px;
        }
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .search-box button { 
            padding: 12px 24px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.2s ease;
        }
        .search-box button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        .filter-box { 
            margin-bottom: 20px; 
            display: flex; 
            gap: 15px; 
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-box select { 
            padding: 12px; 
            border: 2px solid #e9ecef; 
            border-radius: 8px; 
            font-size: 14px;
        }
        .filter-box select:focus {
            outline: none;
            border-color: #667eea;
        }
        .status-active { 
            color: #28a745; 
            font-weight: bold; 
        }
        .status-inactive { 
            color: #dc3545; 
            font-weight: bold; 
        }
        .title-professor { 
            color: #dc3545; 
            font-weight: bold; 
        }
        .title-associate { 
            color: #fd7e14; 
            font-weight: bold; 
        }
        .title-lecturer { 
            color: #007bff; 
            font-weight: bold; 
        }
        .title-assistant { 
            color: #6c757d; 
            font-weight: bold; 
        }
        .stats-info {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border: 1px solid #2196f3;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            color: #1976d2;
            font-weight: 600;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
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
        
        /* 新教师信息卡片 */
        .new-teacher-card {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 2px solid #28a745;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .new-teacher-card h5 {
            color: #155724;
            margin-bottom: 15px;
        }
        .new-teacher-info {
            background: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .new-teacher-info strong {
            color: #28a745;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 5px 0; text-align: center; }
            .search-box input { width: 100%; margin-bottom: 10px; }
            .filter-box { flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>👨‍🏫 教师管理</h2>
        
        <!-- 触发器信息提示 -->
        <div class="trigger-notice">
            <h4>🔄 自动用户创建功能</h4>
            <p>系统已启用触发器功能，添加新教师时将自动创建登录账户（用户名=工号，默认密码=工号）</p>
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
        
        <!-- 新教师信息卡片 -->
        <c:if test="${not empty newTeacher}">
            <div class="new-teacher-card">
                <h5>🎉 新教师添加成功！</h5>
                <div class="new-teacher-info">
                    <strong>教师姓名：</strong>${newTeacher.hylTname10}<br>
                    <strong>工号：</strong>${newTeacher.hylTno10}<br>
                    <strong>登录账户：</strong>用户名=${newTeacher.hylTno10}，密码=${newTeacher.hylTno10}<br>
                    <strong>请通知教师及时修改默认密码！</strong>
                </div>
            </div>
        </c:if>
        
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/teacher/add" class="btn btn-success">➕ 添加教师</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
        
        <div class="search-box">
            <form action="${pageContext.request.contextPath}/teacher/search" method="get">
                <input type="text" name="name" placeholder="输入教师姓名搜索..." value="${searchName}">
                <button type="submit">🔍 搜索</button>
            </form>
        </div>
        
        <div class="filter-box">
            <form action="${pageContext.request.contextPath}/teacher/title" method="get">
                <select name="title">
                    <option value="">选择职称</option>
                    <option value="教授" ${searchTitle == '教授' ? 'selected' : ''}>教授</option>
                    <option value="副教授" ${searchTitle == '副教授' ? 'selected' : ''}>副教授</option>
                    <option value="讲师" ${searchTitle == '讲师' ? 'selected' : ''}>讲师</option>
                    <option value="助教" ${searchTitle == '助教' ? 'selected' : ''}>助教</option>
                    <option value="无" ${searchTitle == '无' ? 'selected' : ''}>无</option>
                </select>
                <button type="submit" class="btn btn-info">筛选</button>
            </form>
            
            <a href="${pageContext.request.contextPath}/teacher/active" class="btn btn-info">👥 在职教师</a>
            <a href="${pageContext.request.contextPath}/teacher/list" class="btn btn-primary">📋 全部教师</a>
        </div>
        
        <c:if test="${filterActive}">
            <div class="stats-info">当前显示：在职教师</div>
        </c:if>
        
        <c:if test="${not empty searchTitle}">
            <div class="stats-info">当前筛选：${searchTitle}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty teachers}">
                <div class="no-data">
                    <h3>📭 暂无教师数据</h3>
                    <p>当前没有找到任何教师记录，请先添加教师信息。</p>
                    <a href="${pageContext.request.contextPath}/teacher/add" class="btn btn-success">➕ 添加教师</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>教师编号</th>
                            <th>姓名</th>
                            <th>性别</th>
                            <th>年龄</th>
                            <th>职称</th>
                            <th>学院</th>
                            <th>邮箱</th>
                            <th>电话</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="teacher" items="${teachers}">
                            <tr>
                                <td><strong>${teacher.hylTno10}</strong></td>
                                <td>
                                    <span style="font-weight: 600; color: #333;">
                                        <c:out value="${teacher.hylTname10}" default="未知"/>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${teacher.hylTsex10 == '男'}">👨 男</c:when>
                                        <c:when test="${teacher.hylTsex10 == '女'}">👩 女</c:when>
                                        <c:otherwise>❓ 未知</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${teacher.hylTage10} 岁</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${teacher.hylTtitle10 == '教授'}">
                                            <span class="title-professor">${teacher.hylTtitle10}</span>
                                        </c:when>
                                        <c:when test="${teacher.hylTtitle10 == '副教授'}">
                                            <span class="title-associate">${teacher.hylTtitle10}</span>
                                        </c:when>
                                        <c:when test="${teacher.hylTtitle10 == '讲师'}">
                                            <span class="title-lecturer">${teacher.hylTtitle10}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="title-assistant">${teacher.hylTtitle10}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty teacher.facultyName}">
                                            <c:out value="${teacher.facultyName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未分配</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty teacher.hylTemail10}">
                                            <c:out value="${teacher.hylTemail10}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty teacher.hylTphone10}">
                                            <c:out value="${teacher.hylTphone10}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${teacher.hylTstatus10 == '在职'}">
                                            <span class="status-active">${teacher.hylTstatus10}</span>
                                        </c:when>
                                        <c:when test="${teacher.hylTstatus10 == '离职' || teacher.hylTstatus10 == '退休'}">
                                            <span class="status-inactive">${teacher.hylTstatus10}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">${teacher.hylTstatus10}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/teacher/view?id=${teacher.hylTno10}" class="btn btn-primary">👁️ 详情</a>
                                    <a href="${pageContext.request.contextPath}/teacher/edit?id=${teacher.hylTno10}" class="btn btn-warning">✏️ 编辑</a>
                                    <form action="${pageContext.request.contextPath}/teacher/delete" method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="${teacher.hylTno10}"/>
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('确定要删除这个教师吗？此操作不可恢复！')">🗑️ 删除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/teacher/add" class="btn btn-success">➕ 添加教师</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 