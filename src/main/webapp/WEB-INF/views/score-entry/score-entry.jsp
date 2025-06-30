<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>成绩录入 - ${course.hylCname10}</title>
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
        .sub-header {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1em;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 600;
        }
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .alert-error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .course-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #dee2e6;
        }
        .course-info h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.5em;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .info-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: 500;
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
            text-align: center;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        tr:hover {
            background-color: #f1f3f5;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .score-input {
            padding: 8px 12px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            width: 80px;
            transition: border-color 0.3s ease;
        }
        .score-input:focus {
            outline: none;
            border-color: #667eea;
        }
        .score-input.has-score {
            background-color: #e7f3ff;
            border-color: #007bff;
        }
        .score-input.no-score {
            background-color: #fff3cd;
            border-color: #ffc107;
        }
        
        .score-display {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            min-width: 50px;
            display: inline-block;
        }
        .score-excellent {
            background-color: #d4edda;
            color: #155724;
        }
        .score-good {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .score-average {
            background-color: #fff3cd;
            color: #856404;
        }
        .score-poor {
            background-color: #f8d7da;
            color: #721c24;
        }
        .score-none {
            background-color: #e2e3e5;
            color: #6c757d;
            font-style: italic;
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
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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
        
        .form-inline {
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
        }
        
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .info-grid { grid-template-columns: 1fr; }
            table { font-size: 12px; }
            th, td { padding: 8px; }
            .form-inline { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ 成绩录入</h2>
        <p class="sub-header">课程: <strong>${course.hylCname10}</strong> | 教学班编号: <strong>${teachingClassId}</strong></p>
        
        <!-- 显示成功或错误消息 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ✅ ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>
        
        <!-- 课程基本信息 -->
        <div class="course-info">
            <h3>📖 课程基本信息</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">课程名称</div>
                    <div class="info-value">${course.hylCname10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">课程类型</div>
                    <div class="info-value">${course.hylCtype10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">学分</div>
                    <div class="info-value">${course.hylCcredit10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">学时</div>
                    <div class="info-value">${course.hylChour10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">考核方式</div>
                    <div class="info-value">${course.hylCtest10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">选课人数</div>
                    <div class="info-value">${enrollments.size()} 人</div>
                </div>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty enrollments}">
                <div class="no-data">
                    <h3>📭 该教学班没有学生</h3>
                    <p>当前教学班没有学生选课，无法录入成绩。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 学生成绩列表 -->
                <table>
                    <thead>
                        <tr>
                            <th>学号</th>
                            <th>学生姓名</th>
                            <th>当前成绩</th>
                            <th>录入成绩</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="enrollment" items="${enrollments}">
                            <tr>
                                <td>
                                    <strong style="color: #667eea;">
                                        ${enrollment.hylSno10}
                                    </strong>
                                </td>
                                <td>
                                    <strong style="color: #333;">
                                        <c:choose>
                                            <c:when test="${not empty enrollment.studentName}">
                                                ${enrollment.studentName}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999;">未知</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty enrollment.hylEscore10}">
                                            <c:choose>
                                                <c:when test="${enrollment.hylEscore10 >= 90}">
                                                    <span class="score-display score-excellent">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 80}">
                                                    <span class="score-display score-good">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 70}">
                                                    <span class="score-display score-average">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:when test="${enrollment.hylEscore10 >= 60}">
                                                    <span class="score-display score-average">${enrollment.hylEscore10}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="score-display score-poor">${enrollment.hylEscore10}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="score-display score-none">未录入</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <form method="POST" action="${pageContext.request.contextPath}/score-entry/update-score" class="form-inline">
                                        <input type="hidden" name="studentId" value="${enrollment.hylSno10}">
                                        <input type="hidden" name="teachingClassId" value="${teachingClassId}">
                                        <input type="number" name="score" value="${enrollment.hylEscore10}" 
                                               min="0" max="100" class="score-input ${not empty enrollment.hylEscore10 ? 'has-score' : 'no-score'}"
                                               placeholder="0-100">
                                </td>
                                <td>
                                        <button type="submit" class="btn btn-primary">💾 保存</button>
                                        <c:if test="${not empty enrollment.hylEscore10}">
                                            <button type="submit" name="score" value="" class="btn btn-danger">🗑️ 清除</button>
                                        </c:if>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        
        <!-- 操作按钮 -->
        <div class="actions">
            <a href="${pageContext.request.contextPath}/score-entry/" class="btn btn-warning">📋 返回教学班列表</a>
            <a href="${pageContext.request.contextPath}/score-entry/batch?teachingClassId=${teachingClassId}" class="btn btn-success">📊 批量录入</a>
            <c:if test="${userType == 'admin'}">
                <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-primary">🏠 管理员首页</a>
            </c:if>
            <c:if test="${userType == 'teacher'}">
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-primary">🏠 教师首页</a>
            </c:if>
        </div>
    </div>
    
    <script>
        // 自动保存功能（可选）
        document.querySelectorAll('.score-input').forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.target.closest('form').submit();
                }
            });
            
            // 实时验证
            input.addEventListener('input', function(e) {
                const value = parseInt(e.target.value);
                const form = e.target.closest('form');
                const saveBtn = form.querySelector('.btn-primary');
                
                if (e.target.value === '') {
                    e.target.className = 'score-input no-score';
                    saveBtn.textContent = '💾 保存';
                } else if (value >= 0 && value <= 100) {
                    e.target.className = 'score-input has-score';
                    saveBtn.textContent = '💾 更新';
                } else {
                    e.target.className = 'score-input';
                    saveBtn.textContent = '❌ 无效';
                }
            });
        });
    </script>
</body>
</html> 