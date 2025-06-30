<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>选课记录管理</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1400px;
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
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
            font-size: 14px;
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
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 12px;
            margin-right: 5px;
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
        .search-box input {
            padding: 10px;
            width: 200px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            margin-right: 10px;
        }
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .search-box button {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
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
        .score-excellent {
            color: #28a745;
            font-weight: bold;
        }
        .score-good {
            color: #007bff;
            font-weight: bold;
        }
        .score-average {
            color: #ffc107;
            font-weight: bold;
        }
        .score-poor {
            color: #dc3545;
            font-weight: bold;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
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
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .search-box input { width: 100%; margin-bottom: 10px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 5px 0; text-align: center; }
            table { font-size: 12px; }
            th, td { padding: 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📚 选课记录管理</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/enrollment/add" class="btn btn-success">➕ 添加选课</a>
            <a href="${pageContext.request.contextPath}/enrollment/course-average" class="btn btn-info">📊 课程平均成绩</a>
            <a href="${pageContext.request.contextPath}/enrollment/analysis" class="btn btn-warning">📈 成绩分析</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-primary">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-warning">🏠 返回首页</a>
        </div>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/enrollment/list" method="get">
                <input type="text" name="studentName" placeholder="输入学生姓名搜索..." value="${param.studentName}">
                <input type="text" name="courseName" placeholder="输入课程名称搜索..." value="${param.courseName}">
                <button type="submit">🔍 搜索</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty enrollments}">
                <div class="no-data">
                    <h3>📭 暂无选课记录</h3>
                    <p>当前没有找到任何选课记录，请先添加选课信息。</p>
                    <a href="${pageContext.request.contextPath}/enrollment/add" class="btn btn-primary">➕ 添加选课</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>学号</th>
                            <th>学生姓名</th>
                            <th>教学班编号</th>
                            <th>课程名称</th>
                            <th>教师姓名</th>
                            <th>学年</th>
                            <th>学期</th>
                            <th>成绩</th>
                            <th>GPA</th>
                            <th>选课时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="enrollment" items="${enrollments}">
                            <tr>
                                <td><strong>${enrollment.hylSno10}</strong></td>
                                <td>
                                    <span style="font-weight: 600; color: #333;">
                                        <c:out value="${enrollment.studentName}" default="未知"/>
                                    </span>
                                </td>
                                <td><strong>${enrollment.hylTcno10}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.courseName}">
                                            <c:out value="${enrollment.courseName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未知课程</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.teacherName}">
                                            <c:out value="${enrollment.teacherName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未分配</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.year}">
                                            ${enrollment.year}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.term}">
                                            ${enrollment.term}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.hylEscore10}">
                                            <c:choose>
                                                <c:when test="${enrollment.hylEscore10 >= 90}">
                                                    <span class="score-excellent">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 80}">
                                                    <span class="score-good">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 70}">
                                                    <span class="score-average">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 60}">
                                                    <span class="score-average">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="score-poor">${enrollment.hylEscore10}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未录入</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.hylEgpa10}">
                                            <fmt:formatNumber value="${enrollment.hylEgpa10}" pattern="#.###"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.hylEnrolldate10}">
                                            <fmt:formatDate value="${enrollment.hylEnrolldate10}" pattern="yyyy-MM-dd"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${enrollment.hylStatus10 == '在读'}">
                                            <span class="status-badge status-active">
                                                <c:out value="${enrollment.hylStatus10}" default="未知"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <c:out value="${enrollment.hylStatus10}" default="未知"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/enrollment/student?studentId=${enrollment.hylSno10}" 
                                           class="btn btn-info">👁️ 查看</a>
                                        <a href="${pageContext.request.contextPath}/enrollment/edit?studentId=${enrollment.hylSno10}&teachingClassId=${enrollment.hylTcno10}" 
                                           class="btn btn-warning">✏️ 编辑</a>
                                        <a href="javascript:void(0)" 
                                           onclick="if(confirm('确定要删除这条选课记录吗？')) window.location.href='${pageContext.request.contextPath}/enrollment/delete?studentId=${enrollment.hylSno10}&teachingClassId=${enrollment.hylTcno10}'" 
                                           class="btn btn-danger">🗑️ 删除</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/enrollment/add" class="btn btn-success">➕ 添加选课</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 