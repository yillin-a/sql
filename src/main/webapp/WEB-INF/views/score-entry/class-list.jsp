<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>选择教学班 - 成绩录入</title>
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
        
        .search-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
        }
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-input {
            flex: 1;
            min-width: 200px;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .search-input:focus {
            outline: none;
            border-color: #667eea;
        }
        .search-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: transform 0.2s ease;
        }
        .search-btn:hover {
            transform: translateY(-2px);
        }
        
        .stats-overview {
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
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .stat-card h4 {
            margin: 0 0 10px 0;
            font-size: 16px;
            opacity: 0.9;
        }
        .stat-card .value {
            font-size: 2.2em;
            font-weight: bold;
            margin: 0;
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
            position: sticky;
            top: 0;
        }
        tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
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
        
        .btn {
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin-right: 8px;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
            text-decoration: none;
        }
        
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
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
        
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .search-form { flex-direction: column; align-items: stretch; }
            .search-input { min-width: auto; }
            .stats-overview { grid-template-columns: 1fr; }
            table { font-size: 12px; }
            th, td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📝 成绩录入 - 选择教学班
            <c:if test="${userType == 'teacher'}">
                <span style="font-size: 0.6em; color: #666; font-weight: normal;">（我的教学班）</span>
            </c:if>
        </h2>
        
        <!-- 搜索区域 -->
        <div class="search-section">
            <form class="search-form" method="GET" action="${pageContext.request.contextPath}/score-entry/">
                <input type="text" name="courseName" value="${searchCourseName}" 
                       placeholder="输入课程名称进行搜索..." class="search-input">
                <button type="submit" class="search-btn">🔍 搜索</button>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${empty teachingClasses}">
                <div class="no-data">
                    <h3>📭 暂无教学班数据</h3>
                    <p>当前没有找到任何教学班数据。</p>
                    <c:if test="${userType == 'admin'}">
                        <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">📚 课程管理</a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 统计概览 -->
                <div class="stats-overview">
                    <div class="stat-card">
                        <h4>📚 教学班总数</h4>
                        <p class="value">${teachingClasses.size()}</p>
                    </div>
                    <div class="stat-card">
                        <h4>👥 学生总数</h4>
                        <p class="value">
                            <c:set var="totalStudents" value="0"/>
                            <c:forEach var="tc" items="${teachingClasses}">
                                <c:set var="totalStudents" value="${totalStudents + tc.student_count}"/>
                            </c:forEach>
                            ${totalStudents}
                        </p>
                    </div>
                    <div class="stat-card">
                        <h4>📈 平均班级人数</h4>
                        <p class="value">
                            <c:choose>
                                <c:when test="${teachingClasses.size() > 0}">
                                    ${Math.round(totalStudents / teachingClasses.size())}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
                
                <!-- 教学班列表表格 -->
                <table>
                    <thead>
                        <tr>
                            <th>教学班编号</th>
                            <th>课程名称</th>
                            <th>课程类型</th>
                            <th>授课教师</th>
                            <th>学年</th>
                            <th>学期</th>
                            <th>学生人数</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tc" items="${teachingClasses}">
                            <tr>
                                <td>
                                    <strong style="color: #667eea;">
                                        ${tc.hyl_tcno10}
                                    </strong>
                                </td>
                                <td>
                                    <strong style="color: #333;">
                                        ${tc.hyl_cname10}
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tc.hyl_ctype10 == '必修课'}">
                                            <span class="course-type type-required">必修课</span>
                                        </c:when>
                                        <c:when test="${tc.hyl_ctype10 == '限选课'}">
                                            <span class="course-type type-elective">限选课</span>
                                        </c:when>
                                        <c:when test="${tc.hyl_ctype10 == '通识课'}">
                                            <span class="course-type type-general">通识课</span>
                                        </c:when>
                                        <c:when test="${tc.hyl_ctype10 == '实践课'}">
                                            <span class="course-type type-practice">实践课</span>
                                        </c:when>
                                        <c:when test="${tc.hyl_ctype10 == '体育课'}">
                                            <span class="course-type type-sports">体育课</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">${tc.hyl_ctype10}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty tc.hyl_tname10}">
                                            ${tc.hyl_tname10}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未分配</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${tc.hyl_tcyear10}</td>
                                <td>第${tc.hyl_tcterm10}学期</td>
                                <td>
                                    <span style="font-weight: 600; color: #007bff;">
                                        ${tc.student_count} 人
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tc.student_count > 0}">
                                            <a href="${pageContext.request.contextPath}/score-entry/class?teachingClassId=${tc.hyl_tcno10}" 
                                               class="btn btn-primary">✏️ 逐个录入</a>
                                            <a href="${pageContext.request.contextPath}/score-entry/batch?teachingClassId=${tc.hyl_tcno10}" 
                                               class="btn btn-success">📊 批量录入</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999; font-style: italic;">暂无学生</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        
        <!-- 操作按钮 -->
        <div class="actions">
            <c:if test="${userType == 'admin'}">
                <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-primary">🏠 管理员首页</a>
                <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-warning">📚 选课管理</a>
            </c:if>
            <c:if test="${userType == 'teacher'}">
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-primary">🏠 教师首页</a>
                <a href="${pageContext.request.contextPath}/course/average-scores" class="btn btn-warning">📊 成绩统计</a>
            </c:if>
        </div>
    </div>
</body>
</html> 