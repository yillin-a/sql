<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教学班管理</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background-color: white;
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
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            margin-right: 5px;
            border: none;
            cursor: pointer;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            align-items: center;
        }
        .search-form input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            width: 300px;
        }
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
            border-radius: 8px;
            text-align: center;
        }
        .stat-card h4 {
            margin: 0 0 10px 0;
            font-size: 14px;
            opacity: 0.9;
        }
        .stat-card .number {
            font-size: 2em;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        .no-data h3 {
            color: #999;
            margin-bottom: 10px;
        }
        .term-badge {
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            color: white;
        }
        .term-1 { background-color: #007bff; }
        .term-2 { background-color: #28a745; }
        .term-3 { background-color: #ffc107; color: #212529; }
        .repeat-badge {
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
        }
        .repeat-normal {
            background-color: #e7f3ff;
            color: #0066cc;
        }
        .repeat-class {
            background-color: #fff3cd;
            color: #856404;
        }
        .student-count {
            color: #007bff;
            font-weight: bold;
        }
        .course-type {
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 11px;
            color: white;
        }
        .type-required { background-color: #dc3545; }
        .type-elective { background-color: #007bff; }
        .type-general { background-color: #6f42c1; }
        .type-physical { background-color: #fd7e14; }
        .type-practice { background-color: #20c997; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🏫 教学班管理</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/teaching-class/add" class="btn btn-success">➕ 添加教学班</a>
                <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-info">🏠 返回首页</a>
            </div>
        </div>

        <!-- 显示成功或错误消息 -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-success">
                ✅ ${param.message}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>

        <!-- 统计信息 -->
        <div class="stats-grid">
            <div class="stat-card">
                <h4>📚 教学班总数</h4>
                <div class="number">${stats.totalClasses}</div>
            </div>
            <div class="stat-card">
                <h4>👥 学生总数</h4>
                <div class="number">${stats.totalStudents}</div>
            </div>
            <div class="stat-card">
                <h4>📊 平均班级人数</h4>
                <div class="number">
                    <fmt:formatNumber value="${stats.avgStudents}" pattern="#.#"/>
                </div>
            </div>
            <div class="stat-card">
                <h4>📖 涉及课程数</h4>
                <div class="number">${stats.distinctCourses}</div>
            </div>
            <div class="stat-card">
                <h4>👨‍🏫 授课教师数</h4>
                <div class="number">${stats.distinctTeachers}</div>
            </div>
        </div>

        <!-- 搜索表单 -->
        <form action="${pageContext.request.contextPath}/admin/teaching-class/search" method="get" class="search-form">
            <input type="text" name="keyword" placeholder="搜索教学班名称、课程名称或教师姓名..." 
                   value="${searchKeyword}">
            <button type="submit" class="btn btn-primary">🔍 搜索</button>
            <c:if test="${not empty searchKeyword}">
                <a href="${pageContext.request.contextPath}/admin/teaching-class/list" class="btn btn-info">📋 查看全部</a>
            </c:if>
        </form>

        <!-- 教学班列表 -->
        <c:choose>
            <c:when test="${empty teachingClasses}">
                <div class="no-data">
                    <h3>📭 暂无教学班数据</h3>
                    <p>还没有教学班记录，点击上方按钮添加第一个教学班。</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>教学班编号</th>
                            <th>教学班名称</th>
                            <th>课程信息</th>
                            <th>授课教师</th>
                            <th>学年学期</th>
                            <th>班次</th>
                            <th>类型</th>
                            <th>学生人数</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tc" items="${teachingClasses}">
                            <tr>
                                <td><strong>${tc.hylTcno10}</strong></td>
                                <td>
                                    <strong style="color: #333;">${tc.hylTcname10}</strong>
                                </td>
                                <td>
                                    <div style="margin-bottom: 5px;">
                                        <strong style="color: #007bff;">${tc.courseName}</strong>
                                        <span class="course-type type-${tc.courseType == '必修课' ? 'required' : tc.courseType == '限选课' ? 'elective' : tc.courseType == '通识课' ? 'general' : tc.courseType == '体育课' ? 'physical' : 'practice'}">
                                            ${tc.courseType}
                                        </span>
                                    </div>
                                    <div style="font-size: 12px; color: #666;">
                                        <c:if test="${tc.courseCredit != null}">学分: ${tc.courseCredit} | </c:if>
                                        <c:if test="${tc.courseHour != null}">学时: ${tc.courseHour} | </c:if>
                                        <c:if test="${tc.testType != null}">${tc.testType}</c:if>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty tc.teacherName}">
                                            <strong style="color: #28a745;">${tc.teacherName}</strong>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未分配</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div>
                                        <strong>${tc.hylTcyear10}</strong> 年
                                    </div>
                                    <span class="term-badge term-${tc.hylTcterm10}">
                                        第${tc.hylTcterm10}学期
                                    </span>
                                </td>
                                <td>
                                    <strong style="color: #6f42c1;">${tc.hylTcbatch10}</strong>
                                </td>
                                <td>
                                    <span class="repeat-badge ${tc.hylTcrepeat10 == '重修班' ? 'repeat-class' : 'repeat-normal'}">
                                        ${tc.hylTcrepeat10}
                                    </span>
                                </td>
                                <td>
                                    <div class="student-count">
                                        ${tc.hylTccurstu10} / ${tc.hylTcmaxstu10}
                                    </div>
                                    <div style="font-size: 11px; color: #666;">
                                        使用率: <fmt:formatNumber value="${tc.hylTcmaxstu10 > 0 ? (tc.hylTccurstu10 * 100.0 / tc.hylTcmaxstu10) : 0}" pattern="#.#"/>%
                                    </div>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/teaching-class/view?id=${tc.hylTcno10}" 
                                       class="btn btn-info">👁️ 查看</a>
                                    <a href="${pageContext.request.contextPath}/admin/teaching-class/edit?id=${tc.hylTcno10}" 
                                       class="btn btn-warning">✏️ 编辑</a>
                                    <c:if test="${tc.hylTccurstu10 == 0}">
                                        <button onclick="deleteTeachingClass(${tc.hylTcno10}, '${tc.hylTcname10}')" 
                                                class="btn btn-danger">🗑️ 删除</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function deleteTeachingClass(id, name) {
            if (confirm('确定要删除教学班 "' + name + '" 吗？\n\n注意：删除后不可恢复！')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/teaching-class/delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html> 