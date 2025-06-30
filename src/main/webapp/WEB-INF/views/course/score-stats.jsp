<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程成绩统计</title>
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
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin-right: 15px;
            margin-bottom: 10px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-info {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
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
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .btn { display: block; margin: 5px 0; text-align: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📈 课程成绩统计</h2>

        <c:choose>
            <c:when test="${empty scoreStats}">
                <div class="no-data">
                    <h3>📭 暂无成绩数据</h3>
                    <p>当前没有找到任何课程的成绩统计信息。</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>课程名称</th>
                            <th>课程类型</th>
                            <th>选课人数</th>
                            <th>平均成绩</th>
                            <th>最高分</th>
                            <th>最低分</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="stat" items="${scoreStats}">
                            <tr>
                                <td>
                                    <strong style="color: #333;">
                                        ${stat.courseName}
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stat.courseType == '必修课'}">
                                            <span class="course-type type-required">必修课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '限选课'}">
                                            <span class="course-type type-elective">限选课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '通识课'}">
                                            <span class="course-type type-general">通识课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '实践课'}">
                                            <span class="course-type type-practice">实践课</span>
                                        </c:when>
                                        <c:when test="${stat.courseType == '体育课'}">
                                            <span class="course-type type-sports">体育课</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">未知</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #007bff;">
                                        ${stat.studentCount} 人
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stat.avgScore >= 90}">
                                            <span class="score-excellent">
                                                <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                            </span>
                                        </c:when>
                                        <c:when test="${stat.avgScore >= 80}">
                                            <span class="score-good">
                                                <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                            </span>
                                        </c:when>
                                        <c:when test="${stat.avgScore >= 70}">
                                            <span class="score-average">
                                                <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="score-poor">
                                                <fmt:formatNumber value="${stat.avgScore}" pattern="#.#"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #28a745;">
                                        ${stat.maxScore}
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #dc3545;">
                                        ${stat.minScore}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">📋 课程列表</a>
            <a href="${pageContext.request.contextPath}/course/stats" class="btn btn-info">📊 课程统计</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 