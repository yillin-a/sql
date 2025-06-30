<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学生成绩排名</title>
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
        .rank-1 {
            background-color: #fff3cd !important;
            font-weight: bold;
        }
        .rank-2 {
            background-color: #f8f9fa !important;
        }
        .rank-3 {
            background-color: #fff3cd !important;
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
        .gpa-excellent {
            color: #28a745;
            font-weight: bold;
        }
        .gpa-good {
            color: #007bff;
            font-weight: bold;
        }
        .gpa-average {
            color: #ffc107;
            font-weight: bold;
        }
        .gpa-poor {
            color: #dc3545;
            font-weight: bold;
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

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .search-box input { width: 100%; margin-bottom: 10px; }
            .nav-buttons { flex-direction: column; align-items: center; }
            .btn { display: block; margin: 5px 0; text-align: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 学生成绩排名</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/student/ranking" class="btn btn-success">📈 详细排名</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-primary">👥 学生列表</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-info">🏠 返回首页</a>
        </div>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/student/search" method="get">
                <input type="text" name="name" placeholder="输入学生姓名搜索..." value="${searchName}">
                <button type="submit">🔍 搜索</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty students}">
                <div class="no-data">
                    <h3>📭 暂无学生数据</h3>
                    <p>当前没有找到任何学生记录，请先添加学生信息。</p>
                    <a href="${pageContext.request.contextPath}/student/add" class="btn btn-primary">➕ 添加学生</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>排名</th>
                            <th>学号</th>
                            <th>姓名</th>
                            <th>性别</th>
                            <th>专业</th>
                            <th>班级</th>
                            <th>已修学分</th>
                            <th>GPA</th>
                            <th>专业排名</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}" varStatus="status">
                            <c:choose>
                                <c:when test="${status.index == 0}">
                                    <c:set var="rowClass" value="rank-1"/>
                                </c:when>
                                <c:when test="${status.index == 1}">
                                    <c:set var="rowClass" value="rank-2"/>
                                </c:when>
                                <c:when test="${status.index == 2}">
                                    <c:set var="rowClass" value="rank-3"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="rowClass" value=""/>
                                </c:otherwise>
                            </c:choose>
                            <tr class="${rowClass}">
                                <td>
                                    <c:choose>
                                        <c:when test="${status.index == 0}">🥇</c:when>
                                        <c:when test="${status.index == 1}">🥈</c:when>
                                        <c:when test="${status.index == 2}">🥉</c:when>
                                        <c:otherwise>${status.index + 1}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong>${student.hylSno10}</strong></td>
                                <td>
                                    <span style="font-weight: 600; color: #333;">
                                        <c:out value="${student.hylSname10}" default="未知"/>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${student.hylSsex10 == '男'}">👨 男</c:when>
                                        <c:when test="${student.hylSsex10 == '女'}">👩 女</c:when>
                                        <c:otherwise>❓ 未知</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty student.majorName}">
                                            <c:out value="${student.majorName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未分配</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty student.className}">
                                            <c:out value="${student.className}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未分配</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${student.hylScreditsum10}" pattern="#.#" var="credits"/>
                                    ${credits} 学分
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${student.hylSgpa10 >= 4.0}">
                                            <span class="gpa-excellent">
                                                <fmt:formatNumber value="${student.hylSgpa10}" pattern="#.###"/>
                                            </span>
                                        </c:when>
                                        <c:when test="${student.hylSgpa10 >= 3.0}">
                                            <span class="gpa-good">
                                                <fmt:formatNumber value="${student.hylSgpa10}" pattern="#.###"/>
                                            </span>
                                        </c:when>
                                        <c:when test="${student.hylSgpa10 >= 2.0}">
                                            <span class="gpa-average">
                                                <fmt:formatNumber value="${student.hylSgpa10}" pattern="#.###"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="gpa-poor">
                                                <fmt:formatNumber value="${student.hylSgpa10}" pattern="#.###"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${student.hylSrank10 > 0}">
                                            第 ${student.hylSrank10} 名
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未排名</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${student.hylSstatus10 == '在读'}">
                                            <span class="status-badge status-active">
                                                <c:out value="${student.hylSstatus10}" default="未知"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <c:out value="${student.hylSstatus10}" default="未知"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/student/view?id=${student.hylSno10}" class="btn btn-info">👁️ 详情</a>
                                    <a href="${pageContext.request.contextPath}/student/detail-scores?id=${student.hylSno10}" class="btn btn-success">📊 成绩</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-primary">返回学生列表</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">返回首页</a>
        </div>
    </div>
</body>
</html>