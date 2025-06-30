<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程管理</title>
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
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-info {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
            color: white;
        }
        .search-box {
            margin-bottom: 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }
        .search-box input, .search-box select {
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            margin-right: 10px;
        }
        .search-box input:focus, .search-box select:focus {
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
        .nav-buttons {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .nav-buttons .btn {
            margin-right: 10px;
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
        .course-type {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .type-required {
            background-color: #d4edda;
            color: #155724;
        }
        .type-elective {
            background-color: #fff3cd;
            color: #856404;
        }
        .type-general {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .type-practice {
            background-color: #f8d7da;
            color: #721c24;
        }
        .type-sports {
            background-color: #e2e3e5;
            color: #383d41;
        }
        .test-method {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        .test-exam {
            background-color: #d4edda;
            color: #155724;
        }
        .test-check {
            background-color: #fff3cd;
            color: #856404;
        }
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 600;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .search-box input, .search-box select { width: 100%; margin-bottom: 10px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 5px 0; text-align: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📚 课程管理</h2>

        <!-- 消息提示 -->
        <c:if test="${param.message != null}">
            <div class="message success">
                ✅ ${param.message}
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="message error">
                ❌ ${param.error}
            </div>
        </c:if>

        <div class="nav-buttons">
            <!-- 管理员功能 -->
            <c:if test="${userType == 'admin'}">
                <a href="${pageContext.request.contextPath}/course/add" class="btn btn-success">➕ 添加课程</a>
                <a href="${pageContext.request.contextPath}/course/stats" class="btn btn-info">📊 课程统计</a>
                <a href="${pageContext.request.contextPath}/course/score-stats" class="btn btn-warning">📈 成绩统计</a>
                <a href="${pageContext.request.contextPath}/course/average-scores" class="btn btn-info">📊 平均成绩统计</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/course/search" method="get">
                <input type="text" name="name" placeholder="输入课程名称搜索..." value="${searchName}">
                <select name="type">
                    <option value="">所有类型</option>
                    <option value="必修课" ${searchType == '必修课' ? 'selected' : ''}>必修课</option>
                    <option value="限选课" ${searchType == '限选课' ? 'selected' : ''}>限选课</option>
                    <option value="通识课" ${searchType == '通识课' ? 'selected' : ''}>通识课</option>
                    <option value="实践课" ${searchType == '实践课' ? 'selected' : ''}>实践课</option>
                    <option value="体育课" ${searchType == '体育课' ? 'selected' : ''}>体育课</option>
                </select>
                <button type="submit">🔍 搜索</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty courses}">
                <div class="no-data">
                    <h3>📭 暂无课程数据</h3>
                    <p>当前没有找到任何课程记录，请先添加课程信息。</p>
                    <a href="${pageContext.request.contextPath}/course/add" class="btn btn-primary">➕ 添加课程</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>课程编号</th>
                            <th>课程名称</th>
                            <th>学分</th>
                            <th>学时</th>
                            <th>考核方式</th>
                            <th>课程类型</th>
                            <th>先修课程</th>
                            <th>平均成绩</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="course" items="${courses}">
                            <tr>
                                <td><strong>${course.hylCno10}</strong></td>
                                <td>
                                    <span style="font-weight: 600; color: #333;">
                                        <c:out value="${course.hylCname10}" default="未知"/>
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #007bff;">
                                        ${course.hylCcredit10} 学分
                                    </span>
                                </td>
                                <td>
                                    <span style="color: #6c757d;">
                                        ${course.hylChour10} 学时
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${course.hylCtest10 == '考试'}">
                                            <span class="test-method test-exam">📝 考试</span>
                                        </c:when>
                                        <c:when test="${course.hylCtest10 == '考查'}">
                                            <span class="test-method test-check">📋 考查</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未知</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${course.hylCtype10 == '必修课'}">
                                            <span class="course-type type-required">必修课</span>
                                        </c:when>
                                        <c:when test="${course.hylCtype10 == '限选课'}">
                                            <span class="course-type type-elective">限选课</span>
                                        </c:when>
                                        <c:when test="${course.hylCtype10 == '通识课'}">
                                            <span class="course-type type-general">通识课</span>
                                        </c:when>
                                        <c:when test="${course.hylCtype10 == '实践课'}">
                                            <span class="course-type type-practice">实践课</span>
                                        </c:when>
                                        <c:when test="${course.hylCtype10 == '体育课'}">
                                            <span class="course-type type-sports">体育课</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未知</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty course.hylCprereq10}">
                                            <c:out value="${course.hylCprereq10}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">无</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${course.hylCavgscore10 != null}">
                                            <span style="font-weight: 600; color: #28a745;">
                                                <fmt:formatNumber value="${course.hylCavgscore10}" pattern="#.#"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">暂无</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/course/view?id=${course.hylCno10}" class="btn btn-info">👁️ 详情</a>
                                    <!-- 管理员专用功能 -->
                                    <c:if test="${userType == 'admin'}">
                                        <a href="${pageContext.request.contextPath}/course/edit?id=${course.hylCno10}" class="btn btn-warning">✏️ 编辑</a>
                                        <a href="javascript:void(0)" onclick="deleteCourse(${course.hylCno10}, '${course.hylCname10}')" class="btn btn-danger">🗑️ 删除</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <div style="text-align: center; margin-top: 30px;">
            <!-- 管理员功能 -->
            <c:if test="${userType == 'admin'}">
                <a href="${pageContext.request.contextPath}/course/add" class="btn btn-success">➕ 添加课程</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>

    <script>
        function deleteCourse(courseId, courseName) {
            if (confirm('确定要删除课程 "' + courseName + '" 吗？\n\n注意：如果该课程已被学生选课，则无法删除。')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/course/delete';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = courseId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html> 